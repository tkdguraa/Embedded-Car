#include "BlinkToRadio.h"
#include <msp430usart.h>
#include <Timer.h>
#include <stdio.h>
#include <string.h>

module BlinkToRadioC{
    uses{
        interface Boot;
        interface Leds;
        interface Timer<TMilli>;
    }
    
    uses{
        interface Receive;
        interface AMPacket;
        interface SplitControl as AMControl;
    }
    uses interface Car;
    uses interface Read<uint16_t> as TempRead;
    uses interface Read<uint16_t> as LightRead;
}

implementation{
    
    uint16_t centiGrade;
    uint16_t luminance;

    event void Boot.booted(){
        call Leds.led0On();
        call Leds.led2On();
        call AMControl.start();
        call Timer.startPeriodic(1000);
        call Car.start();
    }
    event void AMControl.startDone(error_t error){
        
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

    event void Timer.fired(){
        if(call TempRead.read() == SUCCESS){
            call Leds.led2Toggle();
        }
        else{
            call Leds.led0Toggle();
        }
        if(call LightRead.read() == SUCCESS){
            call Leds.led2Toggle();
        }
        else{
            call Leds.led0Toggle();
        }
    }

    event void TempRead.readDone(error_t result, uint16_t val){
       if(result == SUCCESS){      
            centiGrade = (-39.60 + 0.01 * val);  
            printf("Termperature: %d\n",centiGrade);
            call Leds.led1On();
            call Leds.led2On();
            if(centiGrade > 10)
                call Car.forward();
       }
       else{
            printf("Error reading\n");
            centiGrade = (-39.60 + 0.01*val);  
            printf("Termperature: %d\n",val);
            call Leds.led0Off();
            call Leds.led1On();
            call Leds.led2Off();
       }
    }
    event void LightRead.readDone(error_t result, uint16_t val){
        if(result == SUCCESS){
        //    luminance = (2.5*(val/4096.0)*6250.0);
            printf("Light: %d\n",val);
            if(val > 100){
                call Car.forward();  
            }
            else{
                call Car.stop();
            }
        }
        else{
            printf("Error reading\n");
            call Leds.led0Off();
            call Leds.led1Off();
            call Leds.led2Off();
        }
    }

}