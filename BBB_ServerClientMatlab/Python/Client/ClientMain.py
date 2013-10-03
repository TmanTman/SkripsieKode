#University of Stellenbosch
#Faculty Engineering 
#Department of Electrics and Electronics Engineering
#Skripsie
#Author: Tielman Nieuwoudt
#Date of first revision: 22 Sept 2013

from socket import *
import ClientCron
import pickle

def connectToServer():
 
	host = '146.232.221.181' # '127.0.0.1' can also be used
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
	data = read(sock)						#read returned value
	ClientCron.createCron()								#Create cron job
	print "Wrote Cron job, and also received: ", data	#print returned value

	sock.close()

def read(_socket):
    f = _socket.makefile('rb', 1024 )
    data = pickle.load(f)
    f.close()
    return data	

print "Hello from ClientMain"
connectToServer()

