#include "BlinkToRadio.h"
#include <msp430usart.h>

module BlinkToRadioC{
    uses{
        interface Boot;
        interface Leds;
    }
    
    uses{
        interface Receive;
        interface AMPacket;
        interface SplitControl as AMControl;
    }
    uses interface Car;
}

implementation{

    event void Boot.booted(){
        call Leds.led0On();
        call AMControl.start();
    }
    event void AMControl.startDone(error_t error){
        call Leds.led1On();
        call Leds.led2On();
        call Car.start();
    }
    event void AMControl.stopDone(error_t error){

    }
    event message_t * Receive.receive(message_t *msg,void *payload, uint8_t len){
        if(len == sizeof(BlinkToRadioMsg)){
            BlinkToRadioMsg* incomingPacket = ( BlinkToRadioMsg*) payload;//payload는 내가 받을 패킷
            uint8_t data = incomingPacket->Data;
            
            if(data == GO_STRAIGHT){
                call Leds.set(1);
                call Car.forward();
            }
            else if(data == TURN_LEFT){
                call Leds.set(2);
                call Car.left();
            }
            else if(data == TURN_RIGHT){
                call Leds.set(3);
                call Car.right();
            }
            else if(data == TURN_BACK){
                call Leds.set(4);
                call Car.back();
            }
            else if(data == STOP){
                call Leds.set(0);
                call Car.stop();
            }
            else if(data == BUTTON_A){
                call Leds.set(2);
                call Car.angle_up();
            }
            else if(data == BUTTON_B){
                call Leds.set(6);
                call Car.angle_down();
            }
            else if(data == BUTTON_C){
                call Leds.set(5);//Button OK
                //call Car.stop();
                call Car.angle_up();
            }
            else if(data == BUTTON_E){
              // call Leds.set(2);
            }
            else if(data == BUTTON_F){
               // call Leds.set(2);
            }
        }
        return msg;
    }
}