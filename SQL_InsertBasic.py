import sqlite3
import sys

DTarg=sys.argv[1]
GridkWarg=str(sys.argv[2])
GridVarg=str(sys.argv[3])
ChargekWarg=str(sys.argv[4])
ChargeAarg=str(sys.argv[5])
L1kWarg=str(sys.argv[6])
L2kWarg=str(sys.argv[7])
L3kWarg=str(sys.argv[8])
L1Aarg=str(sys.argv[9])
L2Aarg=str(sys.argv[10])
L3Aarg=str(sys.argv[11])

#DB columns
#(DT text, GridkW real, GridV real, ChargekW real, ChargeA real, L1kW real, L2kW real, L3kW real, L1A real, L2A real, L3A real)

#DB Name
DB_NAME = "/home/pi/DB/MyEnergiDB"

#Connect or Create DB File
conn = sqlite3.connect(DB_NAME)
curs = conn.cursor()

#Insert
values = (DTarg, GridkWarg, GridVarg, ChargekWarg, ChargeAarg, L1kWarg, L2kWarg, L3kWarg, L1Aarg, L2Aarg, L3Aarg)
sql = ''' insert into basic (DT, GridkW, GridV, ChargekW, ChargeA, L1kW, L2kW, L3kW, L1A, L2A, L3A) values(?,?,?,?,?,?,?,?,?,?,?) '''
curs.execute(sql,values)
conn.commit()

#Close DB
curs.close()
conn.close()