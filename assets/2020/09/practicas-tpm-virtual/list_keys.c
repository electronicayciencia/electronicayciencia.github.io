/* compile with gcc -o list_keys list_keys.c -l tspi
 *
 * Original: https://www.eit.lth.se/sprapport.php?uid=848
 */

#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<tss/platform.h>
#include<tss/tss_defines.h>
#include<tss/tss_typedef.h>
#include<tss/tss_structs.h>
#include<tss/tspi.h>
#include<trousers/trousers.h>
#include<tss/tss_error.h>

void print_KM_KEYINFO (TSS_KM_KEYINFO * k);


#define DEBUG 0
#define DBG(message, tResult) { if(DEBUG) printf("(Line%d, %s) \
%s returned 0x%08x. %s.\n",__LINE__ ,__func__ , message, tResult, \
(char *)Trspi_Error_String(tResult));}
int
main (int argc, char **argv)
{
  UINT32 i, pulKeyHierarchySize;
  TSS_HKEY hKey;
  TSS_KM_KEYINFO *ppKeyHierarchy;
  TSS_HCONTEXT hContext = 0;
  TSS_HTPM hTPM = 0;
  TSS_RESULT result;
  TSS_HKEY hSRK = 0;
  TSS_HPOLICY hSRKPolicy = 0;
  TSS_UUID SRK_UUID = TSS_UUID_SRK;
//By default SRK is 20bytes 0
//takeownership -z
  BYTE wks[20];
  memset (wks, 0, 20);
//At the beginning
//Create context and get tpm handle
  result = Tspi_Context_Create (&hContext);
  DBG ("Create a context\n", result);
  result = Tspi_Context_Connect (hContext, NULL);
  DBG ("Connect to TPM\n", result);
  result = Tspi_Context_GetTpmObject (hContext, &hTPM);
  DBG ("Get TPM handle\n", result);
//Get SRK handle
//This operation need SRK secret when you takeownership
//if takeownership -z the SRK is wks by default
  result = Tspi_Context_LoadKeyByUUID (hContext, TSS_PS_TYPE_SYSTEM, SRK_UUID,
				       &hSRK);
  DBG ("Get SRK handle\n", result);
  result = Tspi_GetPolicyObject (hSRK, TSS_POLICY_USAGE, &hSRKPolicy);
  DBG ("Get SRK Policy\n", result);
  result = Tspi_Policy_SetSecret (hSRKPolicy, TSS_SECRET_MODE_SHA1, 20, wks);
  DBG ("Tspi_Policy_SetSecret\n", result);
//Get Registered Keys By UUID
//Out:pulKeyHierarchySize - size of the key list
//ppKeyHierarchy- the keys in the keylist
  result = Tspi_Context_GetRegisteredKeysByUUID (hContext,
						 TSS_PS_TYPE_SYSTEM, NULL,
						 &pulKeyHierarchySize,
						 &ppKeyHierarchy);
  if (result == TSS_SUCCESS)
    {
      DBG ("Tspi_Context_GetRegisteredKeysByUUID\n", result);
//Print the key info for each loaded key in the tpm.
      for (i = 0; i < pulKeyHierarchySize; i++)
	{
	  printf ("Registered key %u:\n", i);
	  print_KM_KEYINFO (&ppKeyHierarchy[i]);
	}
    }
  Tspi_Context_CloseObject (hContext, hKey);
  result = Tspi_Context_FreeMemory (hContext, NULL);
  DBG ("Tspi Context Free Memory\n", result);
  result = Tspi_Context_Close (hContext);
  DBG ("Tspi Context Close\n", result);
  return 0;
}

//method to print the key info from print_KM_KEYINFO
//This method was taken from trousers/testsuite.
void
print_KM_KEYINFO (TSS_KM_KEYINFO * k)
{
  printf ("Version: %hhu.%hhu.%hhu.%hhu\n",
	  k->versionInfo.bMajor,
	  k->versionInfo.bMinor,
	  k->versionInfo.bRevMajor, k->versionInfo.bRevMinor);
  printf ("UUID: %08x %04hx %04hx %02hhx %02hhx \
%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx\n", k->keyUUID.ulTimeLow, k->keyUUID.usTimeMid, k->keyUUID.usTimeHigh, k->keyUUID.bClockSeqHigh, k->keyUUID.bClockSeqLow, k->keyUUID.rgbNode[0] & 0xff, k->keyUUID.rgbNode[1] & 0xff, k->keyUUID.rgbNode[2] & 0xff, k->keyUUID.rgbNode[3] & 0xff, k->keyUUID.rgbNode[4] & 0xff, k->keyUUID.rgbNode[5] & 0xff);
  printf ("parent UUID : %08x %04hx %04hx %02hhx \
%02hhx %02hhx%02hhx%02hhx%02hhx%02hhx%02hhx\n", k->parentKeyUUID.ulTimeLow, k->parentKeyUUID.usTimeMid, k->parentKeyUUID.usTimeHigh, k->parentKeyUUID.bClockSeqHigh, k->parentKeyUUID.bClockSeqLow, k->parentKeyUUID.rgbNode[0] & 0xff, k->parentKeyUUID.rgbNode[1] & 0xff, k->parentKeyUUID.rgbNode[2] & 0xff, k->parentKeyUUID.rgbNode[3] & 0xff, k->parentKeyUUID.rgbNode[4] & 0xff, k->parentKeyUUID.rgbNode[5] & 0xff);
  printf ("auth: %s\n", k->bAuthDataUsage ? "YES" : "NO");
  if (k->ulVendorDataLength)
    printf ("vendor data : \"%s\" (%u bytes)\n",
	    k->rgbVendorData, k->ulVendorDataLength);
  else
    printf ("vendor data: (0 bytes)\n");
  printf ("\n");
}
