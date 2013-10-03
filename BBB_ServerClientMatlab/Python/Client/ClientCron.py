#University of Stellenbosch
#Faculty Engineering 
#Department of Electrics and Electronics Engineering
#Skripsie
#Author: Tielman Nieuwoudt
#Date of first revision: 2 Oct 2013

#NOT YET COMPLETE - CHECK FOR REMAINING IMPROVEMENTS THAT NEED TO BE MADE

import datetime
from crontab import CronTab

def createCron():
	#Get the current system cron jobs
	cron = CronTab()
	#Get the current time
	now = datetime.datetime.now()
	#Create new con job
	job = cron.new(command=" /usr/bin/python Desktop/FinalSystem/Beagle_Xbee_Led_on.py") #Specify script
	job2 = cron.new(command=" /usr/bin/python Desktop/FinalSystem/Beagle_Xbee_Led_off.py") 
	#THIS FUNCTION SHOULD ACCOUNT FOR WHEN MINUTE = 59#
	job.minute.on(now.minute+1)
	job2.minute.on(now.minute+2)
	job.enable()
	job2.enable()
	cron.write()
	
	