// Include the libraries
#include "../lib/udp_lib.c"
#include "../lib/aes_ni.c"
#include <stdio.h>
#include <winsock2.h>
#include <math.h>

// The compilation line is:
// gcc server_w.c -o server -g -O0 -Wall -msse2 -msse -march=native -maes -l ws2_32

int main()
{
	struct sockaddr_in server_addr, client_addr;
	int socket_id;
	int slen, recv_len;
	char server_ip[IP_LEN];
	int port_num;
	WSADATA wsa;

	// This string will hold the key for the AES encryption
	char* enc_key_str = "1111111111111111\0";
	
	// A variable for the buffer to receive data from the client 
	char* buff;
	buff = (char*) malloc(BUFF_LEN*sizeof(char));
	if (buff == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }
	memset(buff, '\0', BUFF_LEN);

	// The size of server_addr struct
	slen = sizeof(client_addr);

	// Get the ip address of the server
	printf("Please enter the IP server:\n");
	gets(server_ip);
	while(!valid_ip(server_ip)) {
		printf("Please enter a valid IP address:\n");
		gets(server_ip);
	}

	// Get the port number (assuming the input is an integer)
	printf("Please enter the port number:\n");
	scanf("%d", &port_num);
	while(port_num < 1024 || port_num > 65535) {
		printf("Please enter a valid port number:\n");
		scanf("%d", &port_num);
	}
	
	// Initialize winsock
	printf("\nInitializing Winsock...");
	if (WSAStartup(MAKEWORD(2,2),&wsa) != 0)
	{
		printf("Failed. Error Code : %d", WSAGetLastError());
		exit(EXIT_FAILURE);
	}
	printf("Initialized.\n");
	
	// Create the socket
	if((socket_id = socket(AF_INET, SOCK_DGRAM, 0)) == INVALID_SOCKET)
	{
		printf("Could not create socket : %d" , WSAGetLastError());
	}
	printf("Socket created.\n");
	
	// Setup address structure
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.S_un.S_addr = inet_addr(server_ip);
	server_addr.sin_port = htons(port_num);
	
	// Bind
	if (bind(socket_id, (struct sockaddr *)&server_addr, sizeof(server_addr)) == SOCKET_ERROR)	{
		printf("Bind failed with error code : %d" , WSAGetLastError());
		exit(EXIT_FAILURE);
	}
	puts("Bind done");

	// Auxiliary variables for the decryption process
	// This varaible will point to the decrypted data in uint8_t type
	uint8_t* dec_aux;

	// data_to_dec will hold each 16 bytes to decrypt for each decryption process
	char* data_to_dec;
	data_to_dec = (char*) malloc(17*sizeof(char));
	if (data_to_dec == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }

	// Will hold the whole data decrypted
	char* dec_message;
	dec_message = (char*) malloc(BUFF_LEN*sizeof(char));
	if (dec_message == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }

	// A variable for the decrypted data in uiny8_t type
	uint8_t* dec_message_aux;
	dec_message_aux = (uint8_t*) malloc(BUFF_LEN*sizeof(uint8_t));
	if (dec_message_aux == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }
	memset(dec_message_aux, '\0', BUFF_LEN);

	// Auxiliary variables for the encryption process
	// This varaible will point to the encrypted data in uint8_t type
	uint8_t* enc_aux;

	// data_to_dec will hold each 16 bytes to encrypt for each encryption process
	char* data_to_enc;
	data_to_enc = (char*) malloc(17*sizeof(char));
	if (data_to_enc == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }

	// Will hold the whole data encrypted
	char* enc_message;
	enc_message = (char*) malloc(BUFF_LEN*sizeof(char));
	if (enc_message == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }

	// A variable for the decrypted data in uiny8_t type
	uint8_t* enc_message_aux;
	enc_message_aux = (uint8_t*) malloc(BUFF_LEN*sizeof(uint8_t));
	if (enc_message_aux == NULL) {
        printf("Malloc failed.\n");
        return 1;
    }
	memset(enc_message_aux, '\0', BUFF_LEN);

	// Start the communication, listening to data
	while(strcmp("exit\0", dec_message))
	{
		printf("Waiting for data...");
		fflush(stdout);
		
		//clear the buffer by filling null, it might have previously received data
		memset(buff, '\0', BUFF_LEN);
		
		// Try to receive some data, this is a blocking call
		if ((recv_len = recvfrom(socket_id, buff, BUFF_LEN, 0, (struct sockaddr *) &client_addr, &slen)) == SOCKET_ERROR) {
			printf("recvfrom() failed with error code : %d" , WSAGetLastError());
			exit(EXIT_FAILURE);
		}
		
		printf("Data encrypted: %s\n" , buff);

		// Decrypt the message
		// Number of 16-bytes iterartions needed for the AES process
		int num_decryptions = (int) ceil((double)strlen(buff)/16.0);

		// Setting the memory
		memset(data_to_dec, 	'\0', 17);
		memset(dec_message, 	'\0', BUFF_LEN);
		memset(dec_message_aux, '\0', BUFF_LEN);

		// Decrypt for each process of 16-byte
		for (int i = 0; i < num_decryptions; i++)
		{
			memcpy(data_to_dec, buff+16*i*sizeof(char), 16*sizeof(char));
			data_to_dec[16] = '\0';
			dec_aux = aes_dec_128bits(data_to_dec, enc_key_str);
			// Check if the decryption failed
			if (dec_aux == NULL){
				return 1;
			}
			memcpy(dec_message_aux+16*i*sizeof(char), dec_aux, 16*sizeof(uint8_t));
			free(dec_aux);
		}

		// Casting the message to chars
		for (int i = 0; i < num_decryptions*16+1; i++)
    	{
        	dec_message[i] = (char)dec_message_aux[i];
    	}
		
		// Print details of the client/peer and the data received
		printf("Received packet from %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
		printf("Data: %s\n" , dec_message);


		// Encryption process
		// Number of 16-bytes iterartions needed for the AES process
		int num_encryptions = (int) ceil((double)strlen(dec_message)/16.0);

		// Setting the memory to \0
		memset(data_to_enc, 	'\0', 17);
		memset(enc_message, 	'\0', BUFF_LEN);
		memset(enc_message_aux, '\0', BUFF_LEN);

		// Encrypt for each process of 16-byte
		for (int i = 0; i < num_encryptions; i++)
		{
			memcpy(data_to_enc, dec_message+16*i*sizeof(char), 16*sizeof(char));
			data_to_enc[16] = '\0';
			enc_aux = aes_enc_128bits(data_to_enc, enc_key_str);
			// Check if the encryption failed
			if (enc_aux == NULL){
				return 1;
			}
			memcpy(enc_message_aux+16*i*sizeof(char), enc_aux, 16*sizeof(uint8_t));
			free(enc_aux);
		}

		// Casting the message to chars
		for (int i = 0; i < num_encryptions*16+1; i++)
    	{
        	enc_message[i] = (char)enc_message_aux[i];
    	}

		// Now reply the client with the same data
		if (sendto(socket_id, enc_message, recv_len, 0, (struct sockaddr*) &client_addr, slen) == SOCKET_ERROR) {
			printf("sendto() failed with error code : %d" , WSAGetLastError());
			exit(EXIT_FAILURE);
		}
	}

	// Free the memory
	free(buff);
	free(enc_message);
	free(dec_message);
	free(data_to_enc);
	free(data_to_dec);
	free(enc_message_aux);
	free(dec_message_aux);

	// Close the socket
	closesocket(socket_id);
	WSACleanup();
	
	return 0;
}