// Include the libraries
#include "udp_lib.c"
#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <string.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <arpa/inet.h> 
#include <netinet/in.h> 


int main()
{
	struct sockaddr_in server_addr;
	int socket_id, slen;
	char buff[BUFF_LEN];
	char message[BUFF_LEN];
	char server_ip[IP_LEN];
	int port_num;

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
	
	// Create the socket
	if ((socket_id=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == SOCKET_ERROR) {
		printf("socket() failed.");
		exit(EXIT_FAILURE);
	}
	
	// Setup address structure
	memset(&server_addr, '\0', sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(port_num);
	server_addr.sin_addr.S_un.S_addr = inet_addr(server_ip);
	
	// Start the communication
	while(strcmp("exit", buff) & strcmp("quit", buff))
	{
		printf("Enter message :\n");
		gets(message);
		
		// Send the message to the server
		if (sendto(socket_id, message, strlen(message) ,0 , (struct sockaddr *) &server_addr, slen) == SOCKET_ERROR) {
			perror("sendto() failed.");
			exit(EXIT_FAILURE);
		}
		
		// Receive a reply and print it
		// Clear the buffer by filling null, it might have previously received data
		memset(buff, '\0', BUFF_LEN);

		// Try to receive some data, this is a blocking call
		if (recvfrom(socket_id, buff, BUFF_LEN, 0, (struct sockaddr *) &server_addr, &slen) == SOCKET_ERROR)
		{
			perror("recvfrom() failed.");
			exit(EXIT_FAILURE);
		}
		
		// Print the received data
		puts(buff);
	}

	// Close the socket
	closesocket(socket_id);
	WSACleanup();

	return 0;
}

