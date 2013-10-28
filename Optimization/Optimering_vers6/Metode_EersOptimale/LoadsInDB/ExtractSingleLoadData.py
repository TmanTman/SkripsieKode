
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

def format_hhmmss_to_seconds(hhmmss):
    seconds = sum(int(x) * 60 ** i for i,x in enumerate(reversed(hhmmss.split(":"))))
    return seconds

def barplot(XLabels,YData,XTickInt):
    # Create a bar plot with timeline x-axis
    fig = plt.figure()
    ax = fig.add_subplot(1,1,1)
    # Calculate how many bars there will be
    N = len(YData)    
    # Generate the x-axis number range
    XData = range(N)
    # See note below on the breakdown of this command
    #ax.bar(XData, YData, facecolor='#777777', align='center', yerr=err, ecolor='black')
    ax.bar(XData, YData, facecolor='#777777', align='center', ecolor='black')
    # Create the title, in italics
    ax.set_title('Energy Consumption Profile',fontstyle='italic')
    # Create the x label
    ax.set_xlabel('Time [hh:mm:ss]') 
    # Create the y label
    ax.set_ylabel('Energy [kW]') 
    # Create the x-axis ticks (At the center of the bars)
    XTickData = XData[(0)::XTickInt]
    ax.set_xticks(XTickData)
    # Create the x-axis tick labels (Must be the same length)
    XTickLabels = XLabels[(0)::XTickInt]
    ax.set_xticklabels(XTickLabels)
    # Extremely nice function to auto-rotate the x axis labels.
    # It was made for dates (hence the name) but it works
    # for any long x tick labels
    fig.autofmt_xdate() 
    # Adjust the font sizes
    # Create the title, in italics
    plt.title(ax.get_title(), fontsize=14)
    plt.xlabel(ax.get_xlabel(), fontsize=12)
    plt.setp(ax.get_xticklabels(), fontsize=10)
    plt.ylabel(ax.get_ylabel(), fontsize=12)
    plt.setp(ax.get_yticklabels(), fontsize=10)
    # Make the plot visible
    plt.show()

##MAIN##
import numpy as np
import matplotlib.pyplot as plt
import sqlite3

#This should be read in as commandline arguments
LoadID = 2 #1 for Pool pump,4 for geyser
CategoryID = 1 #CORRECT AFTER CONSULTATION WITH PROFESSOR. Think this is suppose to show Uncontrol/Control/Renew etc

conn = sqlite3.connect("test.db")
cur = conn.cursor()
print "Database opened successfully";

# Retrieve the specifications for the specified loads
Query = '''SELECT Rating, DutyCycle FROM loads WHERE ID = %d AND Status = 1;''' % (LoadID)
cur.execute(Query)
#Populate RsLoads with 2 rows: row0 is the rating and row1 is the dutycycle
RsLoads = cur.fetchall()

#ActvePower for the device is Power rating x Duty Cycle
ActivePower = RsLoads[0][0]*RsLoads[0][1]

#Populate a vector with the second values of the timestamps
Query = '''SELECT profiletimestamps.Timestamp FROM profiletimestamps
        INNER JOIN profiledata ON profiletimestamps.ID = profiledata.TimestampID
        WHERE profiledata.ProfileID = %s;''' % (CategoryID) #The 1 indicates which profile category is used.
cur.execute(Query)
RsTimestamp = cur.fetchall()
# Define the number of Timestamps
CountTimestamp = RsTimestamp.__len__()
# Initialize the Timestamp array
Timestamp = np.zeros([CountTimestamp],np.dtype('a8'))
# Initialize the Profile matrix that will hold the loads timestamps, energy and demand values
Profile = np.zeros([3,CountTimestamp],float)
# Populate  both Timestamp vectors
for IndexTimestamp in range(0,CountTimestamp):
    Timestamp[IndexTimestamp] = RsTimestamp[IndexTimestamp][0]
    Profile[0,IndexTimestamp] = format_hhmmss_to_seconds(RsTimestamp[IndexTimestamp][0]) 
    
#Extract the start and end times and calculate the average energy usage per time slot
for IndexPeriodStart in range(0,CountTimestamp):
    # Define the period boundaries
    PeriodStart = Profile[0,IndexPeriodStart]
    IndexPeriodEnd = (IndexPeriodStart+1)%CountTimestamp
    PeriodEnd = Profile[0,IndexPeriodEnd]
    # Retrieve the Load Schedule record set for the Load defined by LoadID
    Query = '''SELECT ID, Start, End FROM loadschedule where LoadID = %d AND Status =  1;''' % (LoadID)
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

#Print the obtained result
print "TimeStamp Energy"   
for i in range(0, CountTimestamp):
    print RsTimestamp[i], " ", Profile[1][i]
print "Total consumption per day: ", sum(Profile[1])
barplot(Timestamp, Profile[1,:],4)
