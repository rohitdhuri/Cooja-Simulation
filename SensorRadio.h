#ifndef SENSOR_RADIO_H
#define SENSOR_RADIO_H

/* Author- Rohit Mahendra Dhuri */

enum
{
	AM_SENSOR_RADIO = 6
};


typedef nx_struct SensorRadioMsg
{
	nx_uint16_t nodeId;		//Specifies the node
	nx_uint16_t data;		//The actual data value to be transmitted
	nx_uint8_t flag;		//Specifies the type of value (temperature, light or humidity)

} SensorRadioMsg_t;


#endif
