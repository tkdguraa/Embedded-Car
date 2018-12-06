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
        call Car.start();
    }
    event void AMControl.startDone(error_t error){
        call Leds.led1On();
    }
    event void AMControl.stopDone(error_t error){

    }
    event message_t * Receive.receive(message_t *msg,void *payload, uint8_t len){
        if(len == sizeof(BlinkToRadioMsg)){
            BlinkToRadioMsg* incomingPacket = ( BlinkToRadioMsg*) payload;//payload는 내가 받을 패킷
            uint8_t data = incomingPacket->Data;
            call Leds.set(data);
            if(data == GO_STRAIGHT){
                call Car.forward();
            }
            else if(data == TURN_LEFT){
                call Car.left();
            }
            else if(data == TURN_RIGHT){
                call Car.right();
            }
            else if(data == TURN_BACK){
                call Car.back();
            }
            else if(data == STOP){
                call Car.stop();
            }
            else if(data == BUTTON_A){
                call Car.angle_up();
            }
            else if(data == BUTTON_B){
                call Car.angle_down();
            }
            else if(data == BUTTON_C){
                call Car.stop();
            }
            else if(data == BUTTON_D){
                
            }
            else if(data == BUTTON_E){
                
            }
            else if(data == BUTTON_F){
                
            }
        }
        return msg;
    }
}