#!/usr/bin/env python
#!/usr/bin/python


def GetLoadProfile(ProfileID,LoadStat,ScheduleStat):
    # Calculate a cumulative load profile
    # ProfileID: ID of the profile
    # LoadStat: Status of the loads to be included
    # ScheduleStat:  Status of the schedules to be included
    # Retrieve the profile timestamps record set for the Profile defined by ProfileID
    Query = '''SELECT profiletimestamps.Timestamp FROM profiletimestamps INNER JOIN profiledata ON profiletimestamps.ID = profiledata.TimestampID WHERE profiledata.ProfileID = %s;''' % (1)
    cur.execute(Query)
    RsTimestamp = cur.fetchall()
    # Define the number of Timestamps
    CountTimestamp = RsTimestamp.__len__()
    # Retrieve the Loads record set for the Profile defined by ProfileID
    Query = '''SELECT ID, Rating, DutyCycle, Designation FROM loads WHERE ProfileID = %d AND Status = %d;''' % (ProfileID,LoadStat)
    cur.execute(Query)
    RsLoads = cur.fetchall()
    # Initialize the Timestamp array
    Timestamp = np.zeros([CountTimestamp],np.dtype('a8'))
    # Initialize the Profile matrix
    Profile = np.zeros([3,CountTimestamp],float)
    # Populate the Profile timestamp values in seconds
    for IndexTimestamp in range(0,CountTimestamp):
        Timestamp[IndexTimestamp] = RsTimestamp[IndexTimestamp][0]
        Profile[0,IndexTimestamp] = format_hhmmss_to_seconds(RsTimestamp[IndexTimestamp][0]) 
    for IndexPeriodStart in range(0,CountTimestamp):
        # Define the period boundaries
        PeriodStart = Profile[0,IndexPeriodStart]
        IndexPeriodEnd = (IndexPeriodStart+1)%CountTimestamp
        PeriodEnd = Profile[0,IndexPeriodEnd]
        for RecLoad in RsLoads:
            #print "Load ID: ", RecLoad[0],"Rating: ", RecLoad[1],"  DutyCycle: ",RecLoad[2],"\n"
            # Define the Load ID
            LoadID = RecLoad[0]
            # Calculate the active power for the load
            ActivePower = RecLoad[1]*RecLoad[2]
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
    return Timestamp,Profile

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

def format_seconds_to_hhmmss(seconds):
    hours = seconds // (60*60)
    seconds %= (60*60)
    minutes = seconds // 60
    seconds %= 60
    return "%02i:%02i:%02i" % (hours, minutes, seconds)

def barplot(XLabels,YData,XTickInt,ax, title, fig):
    # Calculate how many bars there will be
    N = len(YData)    
    # Generate the x-axis number range
    XData = range(N)
    # See note below on the breakdown of this command
    ax.bar(XData, YData, facecolor='#777777', align='center', ecolor='black')
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
    # Create the title, in italics
    ax.set_title(title,fontstyle='italic')
    dispGraph(fig, ax, title)


def dispGraph(fig,ax, title):
    # Adjust the font sizes
    # Create the title, in italics
    plt.title(title, fontsize=18)
    plt.setp(ax.get_xticklabels(), fontsize=12)
    plt.ylabel(ax.get_ylabel(), fontsize=16)
    plt.xlabel(ax.get_xlabel(), fontsize=16)
    plt.setp(ax.get_yticklabels(), fontsize=12)
    # Extremely nice function to auto-rotate the x axis labels.
    # It was made for dates (hence the name) but it works
    # for any long x tick labels
    fig.autofmt_xdate() 
    #Show  graph


##MAIN##
import numpy as np
import matplotlib.pyplot as plt
import sqlite3

conn = sqlite3.connect("test.db")
cur = conn.cursor()
print "Database opened successfully";

# Get the uncontrollable loads profile
ProfileID = 5
LoadStat = True
CycleStat = True
Timestamp,Profile_Uncontrollable = GetLoadProfile(ProfileID,LoadStat,CycleStat)
print "Energy=",Profile_Uncontrollable[1,:],"\n"
print "Demand=",Profile_Uncontrollable[2,:],"\n"

# Get the controllable loads profile
ProfileID = 1
LoadStat = True
CycleStat = True
Timestamp,Profile_Controllable = GetLoadProfile(ProfileID,LoadStat,CycleStat)
print "Energy=",Profile_Controllable[1,:],"\n"
print "Demand=",Profile_Controllable[2,:],"\n"

#Profile_Total holds the correct timestamps and the sum of the energy and demand vectors
# Initialize the Profile matrix
Profile_Total = np.zeros([3,len(Profile_Controllable[0,:])],float)
Profile_Total[1:,:] = Profile_Uncontrollable[1:,:]+Profile_Controllable[1:,:]
Profile_Total[0,:]=Profile_Uncontrollable[0,:]

print "Energy=",Profile_Total[1,:],"\n"
print "Demand=",Profile_Total[2,:],"\n"

#Total Consumption
print "Uncontrollable load consumption: " , sum(Profile_Uncontrollable[1,:])
print "Controllable load consumption: " , sum(Profile_Controllable[1,:])
print "Total Energy consumption: ", sum(Profile_Total[1,:])

#Sketch the three graphs
#Will sketch 3 axes alongside each other, sharing the y scale
XTickInt = 4
fig, ax2 = plt.subplots(1, 1)

#TOU tariffs
tou_tariffs = np.array([])
#barplot(Timestamp, Profile_Uncontrollable[1,:], XTickInt,ax1, 'Energy Consumption Profile - Uncontrollable', fig)
barplot(Timestamp, ,XTickInt,ax2, 'Energy Consumption Profile - Controllable', fig)                      
#barplot(Timestamp, Profile_Total[1,:],XTickInt, ax3, 'Energy Consumption Profile - Total', fig)

#Display the formatted graphs   
plt.show()  

conn.close()
print "Database closed successfully";


