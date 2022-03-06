/* List all PCRs
 * Original: https://www.eit.lth.se/sprapport.php?uid=848
 *
 * Reinoso G.  2020/09/22
 *
 * Compile with: gcc -o list_pcrs list_pcrs.c -l tspi
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

#include <tss/platform.h>
#include <tss/tss_defines.h>
#include <tss/tss_typedef.h>
#include <tss/tss_structs.h>
#include <tss/tspi.h>
#include <trousers/trousers.h>
#include <tss/tss_error.h>

#define DEBUG 0

#define DBG(message, tResult) {  if (DEBUG) printf("(Line%d, %s) \
	%s returned 0x%08x. %s.\n", __LINE__, __func__, message, \
	tResult, (char * ) Trspi_Error_String(tResult)); }

int main(int argc, char ** argv) {
	BYTE * rgbPcrValue, * rgbNumPcrs;
	UINT32 ulPcrValueLength;
	UINT32 exitCode, subCapSize, numPcrs, subCap, i, j;

	TSS_HCONTEXT hContext = 0;
	TSS_HTPM hTPM = 0;
	TSS_RESULT result;
	TSS_HKEY hSRK = 0;
	TSS_HPOLICY hSRKPolicy = 0;
	TSS_UUID SRK_UUID = TSS_UUID_SRK;

	//By default SRK is 20 bytes
	//0 takeownership -z
	BYTE wks[20];
	memset(wks, 0, 20);


	//At the beginning
	//Create context and get tpm handle
	result = Tspi_Context_Create( &hContext);
	DBG("Create a context\n", result);

	result = Tspi_Context_Connect(hContext, NULL);
	DBG("Connect to TPM\n", result);

	result = Tspi_Context_GetTpmObject(hContext, &hTPM);
	DBG("Get TPM handle\n", result);

	subCap = TSS_TPMCAP_PROP_PCR;
	//Retrieve number of PCR’s from the TPM
	result = Tspi_TPM_GetCapability(hTPM,
		TSS_TPMCAP_PROPERTY,
		sizeof(UINT32),
		(BYTE *) &subCap, 
		&ulPcrValueLength,
		&rgbNumPcrs);
	DBG("Get Num PCRs\n", result);


	if (result == TSS_SUCCESS) {

		//Algorithm found at trousers/testsuite
		numPcrs = * (UINT32 * ) rgbNumPcrs;
		printf("\nPCR List\n");

		for (i = 0; i < numPcrs; i++) {
			result = Tspi_TPM_PcrRead(hTPM, i, &ulPcrValueLength, &rgbPcrValue);
			DBG("PCR read\n", result);
			
			printf("PCR%02u: ", i);

			for (j = 0; j < ulPcrValueLength; j++) {
				printf("%02x", rgbPcrValue[j] & 0xff);
			}

			printf("\n");
		}
		printf("\n");
	}
		//Free memory
	result = Tspi_Context_FreeMemory(hContext, NULL);
	DBG("Tspi Context Free Memory\n", result);
	result = Tspi_Context_Close(hContext);
	DBG("Tspi Context Close\n", result);
	return 0;
}




