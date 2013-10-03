#University of Stellenbosch
#Faculty Engineering 
#Department of Electrics and Electronics Engineering
#Skripsie
#Author: Tielman Nieuwoudt
#Date of first revision: 3 Oct 2013

from socket import *
import pickle

def connectToServer():
 
	host = '127.0.0.1' # '127.0.0.1' can also be used
	port = 52000
	 
	sock = socket()
	#Connecting to socket
	sock.connect((host, port)) #Connect takes tuple of host and port
	sock.send('HI! I am client.')
	data = sock.recv(1024)
	print 'Received: ', data
	#Infinite loop to keep client running.
#while True:
	sock.send(raw_input('Send to Server: ')) #Send data to server
	data = read(sock)
	print "Received: ", data	#print returned value

	sock.close()

def read(_socket):
    f = _socket.makefile('rb', 1024 )
    data = pickle.load(f)
    f.close()
    return data
	
print "Hello from ClientMain"
connectToServer()
