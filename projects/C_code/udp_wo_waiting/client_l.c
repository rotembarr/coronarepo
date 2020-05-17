// Include the libraries
#include "../lib/udp_lib.c"
#include "../lib/aes_ni.c"
#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <string.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <arpa/inet.h> 
#include <netinet/in.h> 
#include <math.h>

// The compilation line is:
// gcc -std=c99 client_l.c -o client -g -O0 -Wall -msse2 -msse -march=native -maes -lm

int main()
{
	struct sockaddr_in server_addr;
	int socket_id;
	unsigned int slen;
	char server_ip[IP_LEN];
	int port_num;

	// This string will hold the key for the AES encryption
	char* enc_key_str = "1111111111111111\0";

	// A variable for the data to get from the user to send to the server
	char* message;
	message = (char*) malloc(BUFF_LEN*sizeof(char));
	memset(message, '\0', BUFF_LEN);

	// This char* will hold the message encrypted
	char* message_enc;
	message_enc = (char*) malloc(BUFF_LEN*sizeof(char));
	memset(message_enc, '\0', BUFF_LEN);

	// The size of server_addr struct
	slen = sizeof(server_addr);

	// Get the ip address of the server
	printf("Please enter the IP server:\n");
	fgets(server_ip, IP_LEN, stdin);
	while(!valid_ip(server_ip)) {
		printf("Please enter a valid IP address:\n");
		fgets(server_ip, IP_LEN, stdin);
	}

	// Get the port number (assuming the input is an integer)
	printf("Please enter the port number:\n");
	scanf("%d", &port_num);
	while(port_num < 1024 || port_num > 65535) {
		printf("Please enter a valid port number:\n");
		scanf("%d", &port_num);
	}
	
	// Create the socket
	if ((socket_id=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0) {
		printf("socket() failed.");
		exit(EXIT_FAILURE);
	}
	
	// Setup address structure
	memset(&server_addr, '\0', sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(port_num);
	server_addr.sin_addr.s_addr = inet_addr(server_ip);

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
	
	// Start the communication
	while(strcmp("exit\n", message) & strcmp("quit\n", message) & strcmp("exit\0", message) & strcmp("quit\0", message))
	{
		printf("Enter message :\n");
		fgets(message, BUFF_LEN, stdin);

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
		if (sendto(socket_id, message_enc, strlen(message_enc) ,0 , (struct sockaddr *) &server_addr, slen) < 0) {
			perror("sendto() failed.");
			exit(EXIT_FAILURE);
		}
		
	}

	// Free the memory
	free(message);
	free(message_enc);
	free(data_to_enc);
	free(enc_message_aux);

	// Close the socket
	close(socket_id);

	return 0;
}

