#University of Stellenbosch
#Faculty Engineering 
#Department of Electrics and Electronics Engineering
#Skripsie
#Author: Tielman Nieuwoudt
#Date of first revision: 3 Oct 2013

from socket import *
from thread import *
import pickle

##############Testing data received from Matlab###################
# from py4j.java_gateway import JavaGateway

# def requestSchedule():
	# print 'requesting Schedule...'
	# #Connect to the JVM Server
	# try:
		# gateway = JavaGateway()
	# except:
		# print "Error encountered opening JavaGateway"
	# try:
		# matlabcaller = gateway.entry_point.getMatlabCaller()
	# except:
		# print "Error encountered accessing entry point"
	# #Call the Java file that handles the Java/Matlab interface
	# return matlabcaller.requestSchedule()
	
# a = requestSchedule()
# for i, val in enumerate(a):
	# print "Element: ", i, " Value: ", val
	
##################################################################
	
###############Testing pickle and socket interface################
def startServer():
	#Creating socket object
	sock = socket()
	# Defining server address and port
	host = '' #'127.0.0.1' or '' are all the same
	print "Host name: ", host
	#Use port > 1024, below it all are reserved
	port = 52000 
	#Binding socket to a address. bind() takes tuple of host and port.
	sock.bind((host, port))
	#Listening at the address
	sock.listen(5) #5 denotes the number of clients can queue
	 
	def clientthread(conn):
	#infinite loop so that function do not terminate and thread do not end.
		data = conn.recv(1024) # 1024 stands for bytes of data to be received
		print 'Received: ', data	
		conn.send('Hi! I am server') #send only takes string
		while True:
	#Sending message to connected client
	#Receiving from client
			try: 
				data = conn.recv(1024) # 1024 stands for bytes of data to be received
				#Haven't yet got the following to work
				#if data.decode('utf-8') is 'requestSchedule':
				#	print 'Matched'
				#	requestSchedule()
				if data: #If the data var is not empty
					print 'Received from client: ', data
					a = [5, 3, 6, 7, 3]
					write(conn, a)
			except:
				print "Error during clientthread connection, or connection closed"
				break #If there was an error break the loop and thereby end the thread
	 
	while True:
	#Accepting incoming connections
		conn, addr = sock.accept()
	#Creating new thread. Calling clientthread function for this function and passing conn as argument.
		start_new_thread(clientthread,(conn,)) #start new thread takes 1st argument as a function name to be run, second is the tuple of arguments to the function.
	 
	conn.close()
	sock.close()
	
def write(_socket, data):
	print "1"
	f = _socket.makefile('wb', 1024 ) #Buffer size must actually be implemented as variable
	print "2"
	pickle.dump(data, f, pickle.HIGHEST_PROTOCOL)
	print "3"
	f.close()
	
startServer()