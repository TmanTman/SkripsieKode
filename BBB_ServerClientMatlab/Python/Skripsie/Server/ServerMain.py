#University of Stellenbosch
#Faculty Engineering 
#Department of Electrics and Electronics Engineering
#Skripsie
#Author: Tielman Nieuwoudt
#Date of first revision: 21 Sept 2013

import ServerDB
import ServerServer

#Test all imports
print 'Hello from ServerMain'
ServerDB.poke()
ServerServer.poke()

#StartServerThread
ServerServer.startServer()
