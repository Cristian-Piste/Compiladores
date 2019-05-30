using namespace std;

#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include "SocketDatagrama.h"
#include "PaqueteDatagrama.h"

#define MAXPARALLELTRHEADS  100
#define SVRPORT             7200
#define MAX_RETRIES         3
#define TIMEOUT_SECONDS     1
#define TIMEOUT_USECONDS    0

vector<uint32_t> foundSvrs;

uint32_t parseIPv4string(const std::string &IPv4){
	unsigned short addr[4];
	if(sscanf(IPv4.c_str(), "%hu.%hu.%hu.%hu", &addr[0], &addr[1], &addr[2], &addr[3])!=4){
		return 0;
	}else{
		return (uint32_t)(addr[3] + addr[2]/0x100 + addr[1]/0x10000ul + addr[0]/0x1000000ul);
	}
}

size_t parseIPv4int(char IPv4str, uint32_t IPv4int){
	size_t lgth;
	lgth = sprintf(IPv4str, "%u.%u.%u.%u", IPv4int>>24 & 0xFF, IPv4int>>16 & 0xFF, IPv4int>>8 & 0xFF, IPv4int & 0xFF);
	return lgth;
}

uint32_t getBroadcastAddr(uint32_t mask, uint32_t net){
	return ((~mask) | net);
}

uint32_t getNextIPv4Addr(uint32_t ip, uint32_t mask, uint32_t net, size_t add){
	uint32_t next = ((ip & mask) | ((ip + add) & ~mask)); 
	if(next==net){
		return getNextIPv4Addr(next, mask, net, 1);
	}else if(next==getBroadcastAddr(mask, net)){
		return getNextIPv4Addr(next, mask, net, 1);
	}else{
		return next;
	}
}

void checkSvrConnection(int a, int b, uint32_t svrAddr, unsigned short svrPort){
	SocketDatagrama socketlocal = new SocketDatagrama();
	int retry = 0, res = 0, buff[2];
	char svrAddrStr[16];
    
	parseIPv4int(svrAddrStr, svrAddr);
	buff[0] = a, buff[1] = b;
	/*begin transmission*/
	PaqueteDatagrama sndPkt(buff, sizeof(int)/2, svrAddrStr, svrPort);
	PaqueteDatagrama recvPkt(sizeof(int));
	while(retry<MAX_RETRIES){
		/*sends packet*/
		socketlocal->send(sndPkt);
		/*waits for server to answer*/
		if(socketlocal->receiveTimeout(recvPkt, TIMEOUT_SECONDS, TIMEOUT_USECONDS)>0 && recvPkt.getPort()==svrPort && svrAddr==parseIPv4string(recvPkt.getAddr())){
			memcpy(&res, recvPkt.getData(), sizeof(int));
			if(res==(a + b)){
				foundSvrs.push_back(parseIPv4string(recvPkt.getAddr()));
			}
			break;
		}
		retry++;
	}
}

int main(int agrc, char argv[]){
	int i, j;
	int data[2] = { 5, 2 };
	uint32_t svrAddr, fin;
	uint32_t net = parseIPv4string(argv[1]), mask = parseIPv4string(argv[2]);
    
	svrAddr = parseIPv4string("10.100.77.0");
	fin = parseIPv4string("10.100.80.0");
	fin = getNextIPv4Addr(fin, mask, net, 1);
	thread th[MAXPARALLELTRHEADS];
	do{
		for(i = 0; i<MAXPARALLELTRHEADS; i++){
			th[i] = thread(checkSvrConnection, data[0], data[1], svrAddr, SVRPORT);
			svrAddr = getNextIPv4Addr(svrAddr, mask, net, 1);
			if(svrAddr==fin){
				i++;
				break;
			}
		}
		for(j = 0; j<i; j++){
			th[j].join();
		}
	}while(svrAddr!=fin);

	for(i = 0; i<foundSvrs.size(); i++){
		char addr[16];
		parseIPv4int(addr, foundSvrs[i]);
		printf("\t%s\n", addr);
	}
	return 0;
}
