#!/usr/bin/python

import sqlite3

conn = sqlite3.connect("/Users/vermeuln/Databases/GridOptimiser/test.db")
cur = conn.cursor()
print "Database opened successfully";

# Define the profile set ID
ProfileSetID = 1

# Retrieve the Profiles recordset
Query = '''SELECT ID, Designation FROM profiles WHERE ProfileSetID = %s;''' % (ProfileSetID)
print Query
cur.execute(Query)
RsProfile = cur.fetchall()
for row in RsProfile:
   print "Profile ID: ", row[0],"  Designation: ",row[1],"\n"

# Retrieve the Profiles Timestamp and Data recordset
ArrProfileID = '(1,2,3,4,5,6)'
print ArrProfileID,"\n"
Query = '''SELECT profiledata.ProfileID, profiletimestamps.Timestamp, profiledata.ValInit, profiledata.ValFinal, profiledata.LimitLower, profiledata.LimitUpper, profiledata.Status, profiledata.Weight FROM profiletimestamps INNER JOIN profiledata ON profiletimestamps.ID = profiledata.TimestampID WHERE profiledata.ProfileID IN %s;''' % (ArrProfileID)
print Query
cur.execute(Query)
RsProfileData = cur.fetchall()
for row in RsProfileData:
   print"Profile ID: ", row[0],"  Timestamp: ", row[1],"ValInit: ", row[2],"  ValFinal ",row[3],"  LimitLower:",row[4],"  LimitUpper:",row[5],"  Status:",row[6],"  Weight:",row[7],"\n"

# Save ValFinal results to table profiledata
ProfileID = 1
Query = '''UPDATE profiledata SET ValFinal = %d WHERE ID = %d;''' % (10, ProfileID)
cur.execute(Query)
conn.commit()
print Query

print "Operation done successfully";

conn.close()
print "Database closed successfully";


