// Include the libraries
#include "../lib/udp_lib.c"
#include "../lib/aes_ni.c"
#include <stdio.h>
#include <winsock2.h>
#include <math.h>

// The compilation line is:
// gcc client_w.c -o client -g -O0 -Wall -msse2 -msse -march=native -maes -l ws2_32

int main()
{
	struct sockaddr_in server_addr;
	int socket_id, slen;
	char server_ip[IP_LEN];
	int port_num;
	WSADATA wsa;

	// This string will hold the key for the AES encryption
	char* enc_key_str = "1111111111111111\0";

	// A variable for the buffer to receive data from the server 
	char* buff;
	buff = (char*) malloc(BUFF_LEN*sizeof(char));
	memset(buff, '\0', BUFF_LEN);

	// A variable for the data to get from the user to send to the server
	char* message;
	message = (char*) malloc(BUFF_LEN*sizeof(char));
	memset(message, '\0', BUFF_LEN);

	// This char* will hold the message encrypted
	char* message_enc;
	message_enc = (char*) malloc(BUFF_LEN*sizeof(char));
	memset(message_enc, '\0', BUFF_LEN);

	// A variable for the buffer to receive data from the server 
	char* message_dec;
	message_dec = (char*) malloc(BUFF_LEN*sizeof(char));
	memset(message_dec, '\0', BUFF_LEN);

	// The size of server_addr struct
	slen = sizeof(server_addr);

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
	if (WSAStartup(MAKEWORD(2,2), &wsa) != 0) {
		printf("Failed. Error Code : %d",WSAGetLastError());
		exit(EXIT_FAILURE);
	}
	printf("Initialized.\n");
	
	// Create the socket
	if ((socket_id=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == SOCKET_ERROR) {
		printf("socket() failed with error code : %d" , WSAGetLastError());
		exit(EXIT_FAILURE);
	}
	
	// Setup address structure
	memset((char *) &server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(port_num);
	server_addr.sin_addr.S_un.S_addr = inet_addr(server_ip);

	// Auxiliary variables for the encryption process (data to the server)
	// data_to_enc will hold each 16 bytes to encrypt for each encryption process
	char* data_to_enc;
	data_to_enc = (char*) malloc(17*sizeof(char));
	memset(data_to_enc, '\0', 17);

	// This varaible will point to the encrypted data in uint8_t type
	uint8_t* aux_enc;

	// Will hold the whole message encrypted in uint8_t type
	uint8_t* enc_message_aux;
	enc_message_aux = (uint8_t*) malloc(BUFF_LEN*sizeof(uint8_t));
	memset(enc_message_aux, '\0', BUFF_LEN);

	// Auxiliary variables for the decryption process (data from the server)
	// data_to_dec will hold each 16 bytes to decrypt for each encryption process
	char* data_to_dec;
	data_to_dec = (char*) malloc(17*sizeof(char));
	memset(data_to_dec, '\0', 17);

	// This varaible will point to the encrypted data in uint8_t type
	uint8_t* aux_dec;

	// Will hold the whole message encrypted in uint8_t type
	uint8_t* dec_message_aux;
	dec_message_aux = (uint8_t*) malloc(BUFF_LEN*sizeof(uint8_t));
	memset(dec_message_aux, '\0', BUFF_LEN);

	// Start the communication
	while(strcmp("exit", message) & strcmp("quit", message))
	{
		printf("Enter message :\n");
		gets(message);
		
		// Encryption process
		// Number of 16-bytes iterartions needed for the AES process
		int num_encryptions = (int) ceil((double)strlen(message)/16.0);

		// Setting the memory to \0
		memset(data_to_enc, 	'\0', 17);
		memset(message_enc, 	'\0', BUFF_LEN);
		memset(enc_message_aux, '\0', BUFF_LEN);

		// Encrypt for each process of 16-byte
		for (int i = 0; i < num_encryptions; i++)
		{
			memcpy(data_to_enc, message+16*i*sizeof(char), 16*sizeof(char));
			data_to_enc[16] = '\0';
			aux_enc = aes_enc_128bits(data_to_enc, enc_key_str);
			// Check if the decryption failed
			if (aux_enc == NULL){
				return 1;
			}
			memcpy(enc_message_aux+16*i*sizeof(char), aux_enc, 16*sizeof(uint8_t));
			free(aux_enc);
		}

		// Casting the message to chars
		for (int i = 0; i < num_encryptions*16+1; i++)
    	{
        	message_enc[i] = (char)enc_message_aux[i];
    	}

		// Send the message to the server
		if (sendto(socket_id, message_enc, strlen(message_enc) ,0 , (struct sockaddr *) &server_addr, slen) == SOCKET_ERROR) {
			printf("sendto() failed with error code : %d" , WSAGetLastError());
			exit(EXIT_FAILURE);
		}
		
		// Receive a reply and print it
		// Clear the buffer by filling null, it might have previously received data
		memset(buff,'\0', BUFF_LEN);

		// Try to receive some data, this is a blocking call
		if (recvfrom(socket_id, buff, BUFF_LEN, 0, (struct sockaddr *) &server_addr, &slen) == SOCKET_ERROR)
		{
			printf("recvfrom() failed with error code : %d" , WSAGetLastError());
			exit(EXIT_FAILURE);
		}

		printf("Data encrypted: %s\n" , buff);

		// Decrypt the message
		// Number of 16-bytes iterartions needed for the AES process
		int num_decryptions = (int) ceil((double)strlen(buff)/16.0);

		// Setting the memory
		memset(data_to_dec, 	'\0', 17);
		memset(message_dec, 	'\0', BUFF_LEN);
		memset(dec_message_aux, '\0', BUFF_LEN);

		// Decrypt for each process of 16-byte
		for (int i = 0; i < num_decryptions; i++)
		{
			memcpy(data_to_dec, buff+16*i*sizeof(char), 16*sizeof(char));
			data_to_dec[16] = '\0';
			aux_dec = aes_dec_128bits(data_to_dec, enc_key_str);
			// Check if the decryption failed
			if (aux_dec == NULL){
				return 1;
			}
			memcpy(dec_message_aux+16*i*sizeof(char), aux_dec, 16*sizeof(uint8_t));
			free(aux_dec);
		}

		// Casting the message to chars
		for (int i = 0; i < num_decryptions*16+1; i++)
    	{
        	message_dec[i] = (char)dec_message_aux[i];
    	}
		
		// Print the received data
		puts(message_dec);
	}

	// Free the memory
	free(buff);
	free(message);
	free(message_enc);
	free(message_dec);
	free(data_to_enc);
	free(data_to_dec);
	free(enc_message_aux);
	free(dec_message_aux);

	// Close the socket
	closesocket(socket_id);
	WSACleanup();

	return 0;
}

