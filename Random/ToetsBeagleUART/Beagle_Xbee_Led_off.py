import serial
from time import sleep

def toggle_led():
	ser.write(chr(0x7E))
	ser.write(chr(0x00))
	ser.write(chr(0x10))
	ser.write(chr(0x17))
	ser.write(chr(0x00))
	ser.write(chr(0x00))
	ser.write(chr(0x00))
	ser.write(chr(0x00))
	ser.write(chr(0x00))
	ser.write(chr(0x00))
	ser.write(chr(0x00))
	ser.write(chr(0xFF))
	ser.write(chr(0xFF))
	ser.write(chr(0xFF))
	ser.write(chr(0xFE))
	ser.write(chr(0x01))
	ser.write('D')
	ser.write('1')
	ser.write(chr(0x04))
#	checksum = 0x17+0xFF+0xFF+0xFF+0xFE+0x02+ord('D')-24+ord('1')-18+value
#	ser.write(chr(0xFF - (checksum and 0xFF)))
	ser.write(chr(0x72))
ser = serial.Serial(port = "/dev/ttyO1", baudrate=9600)
ser.close()
ser.open()
if ser.isOpen():
	print "Serial is open!"
#	light_on = True
#	while (1):
#		print "Toggle"
#		if (light_on):
#			toggle_led(0x05)
#		else:
#			toggle_led(0x04)
#		light_on = not(light_on)
#		sleep(3)
toggle_led()
ser.close()