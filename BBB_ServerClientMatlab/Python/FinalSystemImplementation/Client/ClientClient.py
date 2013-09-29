#University of Stellenbosch
#Faculty Engineering 
#Department of Electrics and Electronics Engineering
#Skripsie
#Author: Tielman Nieuwoudt
#Date of first revision: 22 Sept 2013

def poke():
	print "Hello from ClientClient"
	return
	
def connectToServer():
	from socket import *
 
	host = 'localhost' # '127.0.0.1' can also be used
	port = 52000
	 
	sock = socket()
	#Connecting to socket
	sock.connect((host, port)) #Connect takes tuple of host and port
	sock.send('HI! I am client.')
	data = sock.recv(1024)
	print 'Received: ', data
	#Infinite loop to keep client running.
	while True:
		sock.send(raw_input('Send to Server: '))
		data = sock.recv(1024)
		print data

	sock.close()
	