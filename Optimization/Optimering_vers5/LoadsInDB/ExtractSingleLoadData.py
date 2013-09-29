##MAIN##
import numpy as np
import matplotlib.pyplot as plt
import sqlite3

conn = sqlite3.connect("test.db")
cur = conn.cursor()
print "Database opened successfully";

# Retrieve the specifications for the specified loads
Query = '''SELECT Rating, DutyCycle FROM loads WHERE ID = %d AND Status = 1;''' % (1)
cur.execute(Query)
#Populate RsLoads with 2 rows: row0 is the rating and row1 is the dutycycle
RsLoads = cur.fetchall()
#ActvePower for the device is Power rating x Duty Cycle
ActivePower = RsLoads[0]*RsLoads[1]

# Initialize the Profile matrix that will hold the loads timestamps, energy and demand values
Profile = np.zeros([3,CountTimestamp],float)

#Populate a vector with the second values of the timestamps
Query = '''SELECT profiletimestamps.Timestamp FROM profiletimestamps
        INNER JOIN profiledata ON profiletimestamps.ID = profiledata.TimestampID
        WHERE profiledata.ProfileID = %s;''' % (1)
cur.execute(Query)
RsTimestamp = cur.fetchall()
# Define the number of Timestamps
CountTimestamp = RsTimestamp.__len__()
# Initialize the Timestamp array
Timestamp = np.zeros([CountTimestamp],np.dtype('a8'))
# Populate  both Timestamp vectors
for IndexTimestamp in range(0,CountTimestamp):
    Timestamp[IndexTimestamp] = RsTimestamp[IndexTimestamp][0]
    Profile[0,IndexTimestamp] = format_hhmmss_to_seconds(RsTimestamp[IndexTimestamp][0]) 
    
#Extract the start and end times and calculate the average energy usage per time slot
for IndexPeriodStart in range(0,48):
    # Define the period boundaries
    PeriodStart = Profile[0,IndexPeriodStart]
    IndexPeriodEnd = (IndexPeriodStart+1)%CountTimestamp
    PeriodEnd = Profile[0,IndexPeriodEnd]
    # Retrieve the Load Schedule record set for the Load defined by LoadID
    Query = '''SELECT ID, Start, End FROM loadschedule where LoadID = %d AND Status =  %d;''' % (LoadID,ScheduleStat)
    cur.execute(Query)
    RsSchedule = cur.fetchall()
    for RecCycle in RsSchedule:
        #print "Load schedule ID: ", RecCycle[0],"Start: ", RecCycle[1],"  End: ",RecCycle[2],"\n"
        # Define the cycle boundaries in seconds
        ScheduleStart = sum(int(x) * 60 ** i for i,x in enumerate(reversed(RecCycle[1].split(":"))))
        ScheduleEnd = sum(int(x) * 60 ** i for i,x in enumerate(reversed(RecCycle[2].split(":"))))
        # Calculate the avarage demand for the period
        Energy,Demand = GetPeriodEnergy(ActivePower,PeriodStart,PeriodEnd,ScheduleStart,ScheduleEnd)
        # Update the profile
        Profile[1,IndexPeriodStart] = Profile[1,IndexPeriodStart] + Energy
        Profile[2,IndexPeriodStart] = Profile[2,IndexPeriodStart] + Demand

def GetPeriodEnergy(ActivePower,PeriodStart,PeriodEnd,ScheduleStart,ScheduleEnd):
    # Calculate the on time
    Start = max(PeriodStart,ScheduleStart)
    End = min(PeriodEnd,ScheduleEnd)
    # Calculate the duration in hours
    if (Start < End):
        Duration = (End-Start)/3600.0
        Demand = ActivePower
    else:
        Duration = 0
        Demand = 0
    Energy = ActivePower*Duration
    return Energy,Demand
