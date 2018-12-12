#include <msp430usart.h>

module CarC{
    uses{
        interface Resource;
        interface HplMsp430Usart;
        interface HplMsp430GeneralIO as P20;
    }
    provides{
        interface Car;
    }
}

implementation{
    bool busy = FALSE;
    uint16_t origin_angle = 1800;
    uint8_t instruction, transmit_s;
    uint16_t data;
    msp430_uart_union_config_t config1 = {
        {
            utxe: 1,
            urxe: 1,
            ubr: UBR_1MHZ_115200,
            umctl: UMCTL_1MHZ_115200,
            ssel: 0x02,
            pena: 0,
            pev: 0,
            spb: 0,
            clen: 1,
            listen: 0,
            mm: 0,
            ckpl: 0,
            urxse: 0,
            urxeie: 0,
            urxwie: 0,
            utxe: 1,
            urxe: 1
        }
    };
    command void Car.start(){
       busy = TRUE;
       transmit_s = 0;
        //setting original angle;
       instruction = ANGLE_ONE;
       data = 1800;
       call Resource.request();
    }

    command void Car.forward(){
        busy = TRUE;
        instruction = GO_STRAIGHT;
        data = 300;
        call Resource.request();
    }
    command void Car.left(){
        if(busy){
            return;
        }
        busy = TRUE;
        instruction = TURN_LEFT;
        data = 300;
        call Resource.request();
    }
    command void Car.right(){
        if(busy){
            return;
        }
        busy = TRUE;
        instruction = TURN_RIGHT;
        data = 300;
        call Resource.request();
    }
    command void Car.back(){
        if(busy){
            return;
        }
        busy = TRUE;
        instruction = TURN_BACK;
        data = 300;
        call Resource.request();
    }
    command void Car.angle_up(){
        if(busy){
            return;
        }
        busy = TRUE;
        if(origin_angle < ANGLE_MAX){
            origin_angle += 200; 
        }
        instruction = ANGLE_ONE;
        data = origin_angle;
        call Resource.request();
    }
    command void Car.angle_down(){
        if(busy){
            return;
        }
        busy = TRUE;
        if(origin_angle > ANGLE_MIN){
            origin_angle -= 200; 
        }
        instruction = ANGLE_ONE;
        data = origin_angle;
        call Resource.request();
    }
    command void Car.stop(){
        if(busy){
            return;
        }
        busy = TRUE;
        instruction = STOP;
        call Resource.request();
    }
    void transmit_cmd() {
        switch (transmit_s) {
        case 0:
            call HplMsp430Usart.tx(0x01);
            break;
        case 1:
            call HplMsp430Usart.tx(0x02);
            break;
        case 2:
            call HplMsp430Usart.tx(instruction);
            break;
        case 3:
            call HplMsp430Usart.tx((uint8_t)((data >> 8) & 0xff));
            break;
        case 4:
            call HplMsp430Usart.tx((uint8_t)(data & 0xff));
            break;
        case 5:
            call HplMsp430Usart.tx(0xFF);
            break;
        case 6:
            call HplMsp430Usart.tx(0xFF);
            break;
        case 7:
            call HplMsp430Usart.tx(0x00);
            break;
        default:
            break;
        }
        transmit_s++;
        if (transmit_s < 8) {
            while (!(call HplMsp430Usart.isTxEmpty())) {
            }
           transmit_cmd();
        }
        else {
            transmit_s = 0;
            call Resource.release();
        }
    }
    event void Resource.granted(){
		call HplMsp430Usart.setModeUart(&config1);
		call HplMsp430Usart.enableUart();
		atomic U0CTL&=~SYNC;
        transmit_s = 0;
        transmit_cmd();
        busy = FALSE;
	}
}