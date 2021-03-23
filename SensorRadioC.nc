#include<Timer.h>
#include<stdio.h>
#include<string.h>
#include"SensorRadio.h"

/* Author- Rohit Mahendra Dhuri */

module SensorRadioC
{
	//General interfaces
	uses
	{
		interface Boot;
		interface Leds;
		interface Timer<TMilli> as Timer0;
		interface Timer<TMilli> as Timer1;
		interface Timer<TMilli> as Timer2;
	}

	//Radio interfaces
	uses	
	{
		interface Packet;
		interface AMPacket;
		interface AMSend;
		interface SplitControl as AMControl;
		interface Receive; 
	}

	//Sensor read interfaces
	uses
	{
		interface Read<uint16_t> as TempRead;
		interface Read<uint16_t> as HumidRead;
		interface Read<uint16_t> as LightRead;
	}
}

implementation
{
	bool _radioBusy = FALSE;		
	message_t _packet;


	/* This function signature is used to create and send a packet over the radio network */
	void communicate(uint16_t data, uint8_t flag)
	{
		if(_radioBusy == FALSE)
		{
			//creating packet
			SensorRadioMsg_t* msg = call Packet.getPayload(& _packet, sizeof(SensorRadioMsg_t));

			msg -> nodeId = TOS_NODE_ID;
			msg -> data = data;
			msg -> flag = flag;

			//sending packet
			if(msg -> nodeId == 1)
			{
				if(call AMSend.send(AM_BROADCAST_ADDR, & _packet, sizeof(SensorRadioMsg_t)) == SUCCESS )
				{
					_radioBusy = TRUE;
				}
			}	

		}

	}

	/* Starting the radio as soon as teh device boots */
	event void Boot.booted()
	{	/* Starting the radio */
		call AMControl.start();		
	}

	/* Starting the timers after the radio is up running */
	event void AMControl.startDone(error_t error)
	{
		if(error == SUCCESS)
		{
			call Timer0.startPeriodic(1000);
			call Timer1.startPeriodic(2000);
			call Timer2.startPeriodic(4000);

		}
		else
		{
			call AMControl.start();
		}
	}
	
	/* No action */
	event void AMControl.stopDone(error_t error)
	{

	}

	/* Setting the radiobusy variable to false after the packet is sent */
	event void AMSend.sendDone(message_t *msg, error_t error)
	{
		if( msg == &_packet )
		{
			_radioBusy = FALSE;
		}

	}

	/* Reading temperature value and transmitting it */
	event void Timer0.fired()
	{
		if(TOS_NODE_ID == 1)
		{
			if(call TempRead.read() == SUCCESS)
			{	/* Turning on the respective led after sending a packet */
				call Leds.led0Toggle();
			}
		}
	}

	/* Reading light value and transmitting it */
	event void Timer1.fired()
	{
		if(TOS_NODE_ID == 1)
		{
			if(call LightRead.read() == SUCCESS)
			{	/* Turning on the respective led after sending a packet */
				call Leds.led1Toggle();
			}
		}
	}

	/* Reading humidity value and transmitting it */
	event void Timer2.fired()
	{
		if(TOS_NODE_ID == 1)
		{
			if(call HumidRead.read() == SUCCESS)
			{	/* Turning on the respective led after sending a packet */
				call Leds.led2Toggle();
			}
		}
	}

	/* calling the communicate function after reading the sensor value */
	event void TempRead.readDone(error_t result, uint16_t val)
	{
		if(result == SUCCESS)
		{	/* Converting sensor reading to degrees celcius */
			val = ((0.01 * val) - 39.6);
			communicate(val, 0);
		}
		else
		{
			printf("Error reading from temperature sensor");
		}
	}

	/* calling the communicate function after reading the sensor value */
	event void LightRead.readDone(error_t result, uint16_t val)
	{
		if(result == SUCCESS)
		{	/* Converting sensor reading to light value */
			val = (2.5 * (val/4096.0) * 6025.0);
			communicate(val, 1);
		}
		else
		{
			printf("Error reading from light sensor");
		}
	}

	/* calling the communicate function after reading the sensor value */
	event void HumidRead.readDone(error_t result, uint16_t val)
	{
		if(result == SUCCESS)
		{	/* Converting sensor reading to humidity percentage */
			val = (-4 +0.0405*(val))+(-0.0000028*pow(val,2));
			communicate(val, 2);
		}
		else
		{
			printf("Error reading from humidity sensor");
		}
	}

	/* Extracting information from the packet after receiving it */
	event message_t * Receive.receive(message_t *msg, void *payload, uint8_t len)
	{
		if(len == sizeof(SensorRadioMsg_t))
		{
			SensorRadioMsg_t * incomingPacket = (SensorRadioMsg_t*) payload;

			if(incomingPacket-> nodeId == 1)
			{
				
				/* Checking the flag to figure out the type of value in the received packet */
				if(incomingPacket -> flag == 0)
				{
					call Leds.led0Toggle();
					printf("Received temperature reading : %d deg celcius \r\n", incomingPacket->data );
				}				
				if(incomingPacket -> flag == 1)
				{
					call Leds.led1Toggle();
					printf("Received light reading : %d \r\n", incomingPacket->data );
				}				
				if(incomingPacket -> flag == 2)
				{				
					call Leds.led2Toggle();
					printf("Received humidity reading : %d %\r\n", incomingPacket->data );
				}
			}


		}

		return msg;
	}

}










