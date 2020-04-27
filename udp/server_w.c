// Include the libraries
#include "udp_lib.c"
#include <stdio.h>
#include <winsock2.h>
#pragma comment(lib,"ws2_32.lib") //Winsock Library


int main()
{
	struct sockaddr_in server_addr, client_addr;
	int socket_id;
	char buff[BUFF_LEN];
	int slen, recv_len;
	char server_ip[IP_LEN];
	int port_num;
	WSADATA wsa;

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
	printf("\nInitialising Winsock...");
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

	// Start the communication, listening to data
	while(strcmp("exit", buff))
	{
		printf("Waiting for data...");
		fflush(stdout);
		
		//clear the buffer by filling null, it might have previously received data
		memset(buff,'\0', BUFF_LEN);
		
		// Try to receive some data, this is a blocking call
		if ((recv_len = recvfrom(socket_id, buff, BUFF_LEN, 0, (struct sockaddr *) &client_addr, &slen)) == SOCKET_ERROR) {
			printf("recvfrom() failed with error code : %d" , WSAGetLastError());
			exit(EXIT_FAILURE);
		}
		
		// Print details of the client/peer and the data received
		printf("Received packet from %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
		printf("Data: %s\n" , buff);
		
		// Now reply the client with the same data
		if (sendto(socket_id, buff, recv_len, 0, (struct sockaddr*) &client_addr, slen) == SOCKET_ERROR) {
			printf("sendto() failed with error code : %d" , WSAGetLastError());
			exit(EXIT_FAILURE);
		}
	}

	// Close the socket
	closesocket(socket_id);
	WSACleanup();
	
	return 0;
}