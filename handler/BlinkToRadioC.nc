#include <Timer.h>
#include <Msp430Adc12.h>
#include "BlinkToRadio.h"


module BlinkToRadioC{
    uses{
        interface Boot;
        interface Leds;
        interface Timer<TMilli> as Timer0;  
    }    
    uses{
        interface Button;
        interface Read<uint16_t> as StickHor;
        interface Read<uint16_t> as StickVer;
    }
    uses{
        interface Packet;
        interface AMPacket;
        interface AMSend;
        interface SplitControl as AMControl;
    }
}

implementation{

    bool _radioBusy = FALSE;
    message_t _packet;
   
    event void Boot.booted(){
        call AMControl.start();
    }
     event void Button.startDone(){
        call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    event void Timer0.fired(){
        call StickHor.read();
        call StickVer.read();
        call Button.pinvalueA();
	    call Button.pinvalueB();
	    call Button.pinvalueC();
	    call Button.pinvalueD();
	    call Button.pinvalueE();
	    call Button.pinvalueF();
    }
    void SendMsg(uint8_t data){
        if(_radioBusy == FALSE){
            //패킷생성
            BlinkToRadioMsg* msg = call Packet.getPayload(& _packet, sizeof(BlinkToRadioMsg));
            msg->Data = data;
            
            //패킷발송
            if(call AMSend.send(AM_BROADCAST_ADDR, & _packet, sizeof(BlinkToRadioMsg)) == SUCCESS){
                call Leds.led1On();
                _radioBusy = TRUE;
            }
        }
    }
    event void AMSend.sendDone(message_t *msg, error_t error){
        if(msg == &_packet){
            _radioBusy = FALSE;
            call Leds.led1Off();
        }
    }//발송성공

    event void AMControl.startDone(error_t error){
        if(error == SUCCESS){
            call Leds.led0On();
            call Button.start();
        }
        else{
            call AMControl.start();
        }
    }//시작 성공했는지
    event void AMControl.stopDone(error_t error){

    }//중지 성공했는지

	event void StickHor.readDone(error_t result, uint16_t val)
	{
        if(result == SUCCESS)
        {
            if(val < 1000) {
               SendMsg(TURN_LEFT);                
            }
            else if(val > 3000) {
               SendMsg(TURN_RIGHT);
            }
	    }
	}

	event void StickVer.readDone(error_t result, uint16_t val)
	{
	  if(result == SUCCESS)
	    {
            if(val < 1000) {
                SendMsg(GO_STRAIGHT);
            }
            else if(val > 3000) {
                SendMsg(TURN_BACK);
            }
            else{
                SendMsg(STOP);
            }
	    }
	}

	event void Button.pinvalueADone()
	{
		SendMsg(BUTTON_A);
	}

	event void Button.pinvalueBDone()
	{
		SendMsg(BUTTON_B);
	}

	event void Button.pinvalueCDone()
	{
		SendMsg(BUTTON_C);
	}

	event void Button.pinvalueDDone()
	{
		SendMsg(BUTTON_D);
	}

	event void Button.pinvalueEDone()
	{
		SendMsg(BUTTON_E);
	}

	event void Button.pinvalueFDone()
	{
		SendMsg(BUTTON_F);
	}
}