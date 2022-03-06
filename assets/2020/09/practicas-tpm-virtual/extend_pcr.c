/* Extend a PCR with a value
 *
 * Reinoso G.  2020/09/22
 *
 * Compile with: gcc -o extend_pcr extend_pcr.c -l tspi
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

/*#include <tss/platform.h>
#include <tss/tcpa_defines.h>
#include <tss/tcpa_typedef.h>
#include <tss/tcpa_struct.h>
#include <tss/tss_typedef.h>
#include <tss/tss_structs.h>
#include <tss/tspi.h>*/


#include <tss/platform.h>
#include <tss/tss_defines.h>
#include <tss/tss_typedef.h>
#include <tss/tss_structs.h>
#include <tss/tspi.h>
#include <trousers/trousers.h>
#include <tss/tss_error.h>

int main(int argc, char ** argv) {
	BYTE * rgbPcrValue, * rgbNumPcrs;
	UINT32 ulPcrValueLength;
	int j;

	TSS_RESULT result;
	TSS_HCONTEXT hContext;
	TSS_HTPM hTPM;

	UINT32 ulPcrIndex = 0;
	BYTE pbPcrData[20];
	UINT32 ulPcrDataLength = 20;
	memset (pbPcrData, 0, 20);


	if (argc < 2) {
		printf("Extend select PCR with 0 value.\n" \
			"Usage:  %s #pcr    (#pcr = 0-23)\n", argv[0]);
		exit(0);
	}

	ulPcrIndex = atoi(argv[1]);

	//Get tpm handle
	result = Tspi_Context_Create( &hContext);
	result = Tspi_Context_Connect(hContext, NULL);
	result = Tspi_Context_GetTpmObject(hContext, &hTPM);

	result = Tspi_TPM_PcrExtend(
		hTPM, 
		ulPcrIndex, 
		ulPcrDataLength, 
		pbPcrData,
		NULL,
		&ulPcrValueLength, 
		&rgbPcrValue);

	if (result) {
		printf("Tspi_TPM_PcrExtend: %s\n", Trspi_Error_String(result));
		exit(1);
	}

	printf("PCR%02u: ", ulPcrIndex);
	for (j = 0; j < ulPcrValueLength; j++) {
		printf("%02x", rgbPcrValue[j] & 0xff);
	}
	printf("\n");


	result = Tspi_Context_FreeMemory(hContext, NULL);
	result = Tspi_Context_Close(hContext);
	return 0;
}




