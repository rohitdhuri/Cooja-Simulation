configuration SensorRadioAppC
{
}

/* Author- Rohit Mahendra Dhuri */

implementation
{
	//General
	components MainC;
	components LedsC;
	components new TimerMilliC() as Timer0;
	components new TimerMilliC() as Timer1;
	components new TimerMilliC() as Timer2;

	components SensorRadioC as App;

	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer0 -> Timer0;
	App.Timer1 -> Timer1;
	App.Timer2 -> Timer2;

	//Radio comm
	components ActiveMessageC;
	components new AMSenderC(AM_SENSOR_RADIO);
	components new AMReceiverC(AM_SENSOR_RADIO);

	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMSend -> AMSenderC;
	App.AMControl -> ActiveMessageC;
	App.Receive -> AMReceiverC;

	//for writing into serial port
	components SerialPrintfC;

	//Temp Sensor components
	components new SensirionSht11C() as TempSensor;
	
	App.TempRead -> TempSensor.Temperature;

	//Light Sensor components
	components new HamamatsuS10871TsrC() as LightSensor;

	App.LightRead -> LightSensor;

	//Humidity Sensor components
	components new SensirionSht11C() as HumidSensor;
	
	App.HumidRead -> HumidSensor.Humidity;
	

}
