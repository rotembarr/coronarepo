#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "../lib/aes_ni.c"

#ifndef BUFF_LEN
#define BUFF_LEN 1024
#endif

int ascii_to_hex(char c)
{
    int num = (int) c;
    if(num < 58 && num > 47) {
        return num - 48; 
    }
    if(num < 103 && num > 96) {
        return num - 87;
    }
    return num;
}

int main(int argc, char** argv)
{
	if (argc != 4){
		printf("Please enter DEC/ENC, name of file to read from and to write to.\n");
		return 1;
	}
	int encryption = (int) (argv[1][0] - '0');
	// The variables for reading the file
    FILE *fp_r = fopen(argv[2],"r");

    // The variables for writing the data into the file
    FILE *fp_w = fopen(argv[3], "w");
    unsigned char c1, c2, sum;
    //unsigned char sum;

    // The variable for reading each line in the file
    char* line;
    line = (char*) malloc(BUFF_LEN*sizeof(char));
    if (line == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }
    memset(line, '\0', BUFF_LEN);

    // The variable for reading each line in the file in hexadecimal
    char* hex_line;
    hex_line = (char*) malloc(BUFF_LEN*sizeof(char));
    if (hex_line == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }
    memset(hex_line, '\0', BUFF_LEN);

    // This string will hold the key for the AES encryption
	char* enc_key_str = "0000000000000000\0";

    // Auxiliary variables for the encryption process
    // This char* will hold the line encrypted
	char* line_enc;
	line_enc = (char*) malloc(BUFF_LEN*sizeof(char));
	if (line_enc == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }
	memset(line_enc, '\0', BUFF_LEN);

	// Will hold the whole message encrypted in uint8_t type
	uint8_t* line_enc_aux;
	line_enc_aux = (uint8_t*) malloc(BUFF_LEN*sizeof(uint8_t));
	if (line_enc_aux == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }
	memset(line_enc_aux, '\0', BUFF_LEN);

	// data_to_enc will hold each 16 bytes to encrypt for each encryption process (for each block)
	char* data_to_enc;
	data_to_enc = (char*) malloc(17*sizeof(char));
	if (data_to_enc == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }
	memset(data_to_enc, '\0', 17);

	// This varaible will point to the encrypted data in uint8_t type
	uint8_t* aux_enc;

    // Read all the lines in the file
    while ((fgets(line, BUFF_LEN, fp_r)) != NULL) {
        // Printing the data into the file
    	for (int i = 0; i < strlen(line) - 1; i+=2)
    	{
    		// Casting into hex
        	c1 = ascii_to_hex(line[i]);
        	c2 = ascii_to_hex(line[i+1]);
        	sum = c1 << 4 | c2;
        	hex_line[i/2] = (char)sum;
   		}

        // Encryption process for each block in the line
		// Number of 16-bytes iterartions needed for the AES process
		int num_encryptions = (int) ceil((double)(strlen(hex_line)-1)/16.0);

		// Setting the memory to \0
		memset(line_enc_aux, '\0', BUFF_LEN);
		memset(line_enc, 	 '\0', BUFF_LEN);
		memset(data_to_enc,  '\0', 17);

		// Encrypt for each process of 16-byte
		for (int i = 0; i < num_encryptions; i++)
		{
			memcpy(data_to_enc, hex_line+16*i*sizeof(char), 16*sizeof(char));
			data_to_enc[16] = '\0';
			if (encryption){
				aux_enc = aes_enc_128bits(data_to_enc, enc_key_str);
			} else {
				aux_enc = aes_dec_128bits(data_to_enc, enc_key_str);
			}
			// Check if the decryption failed
			if (aux_enc == NULL){
				return 1;
			}
			memcpy(line_enc_aux+16*i*sizeof(char), aux_enc, 16*sizeof(uint8_t));
			free(aux_enc);
		}

		// Casting the message to chars
		for (int i = 0; i < num_encryptions*16+1; i++)
    	{
        	line_enc[i] = (char)line_enc_aux[i];
    	}

    	// Printing the data into the file
    	for (int i = 0; i < num_encryptions*16; i++)
    	{
        	unsigned char c = (unsigned char) line_enc[i];
        	fprintf(fp_w, "%02x", c);
   		}
   		// Ending each line with \n
   		fprintf(fp_w, "\n");

   		// Setting the data back to \0
   		memset(hex_line, '\0', BUFF_LEN);
   		memset(line, 	 '\0', BUFF_LEN);
    }

    // Free the memory
    free(line);
    free(hex_line);
    free(line_enc);
    free(line_enc_aux);
    free(data_to_enc);

    // Closing the file
    fclose(fp_r);
    fclose(fp_w);

    return 0;
}
