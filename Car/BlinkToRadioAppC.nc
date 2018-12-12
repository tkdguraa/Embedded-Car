#include <msp430usart.h>
#include "BlinkToRadio.h"

configuration BlinkToRadioAppC{

}

implementation{
    components MainC;
    components LedsC;
    components BlinkToRadioC as App;
    components new AMReceiverC(AM_RADIO);
    components ActiveMessageC;
    components CarC;
    components HplMsp430Usart0C;
    components new Msp430Usart0C() as Msp430Usart0C;
    components new Msp430Uart0C() as Uart;
    components HplMsp430GeneralIOC as GIO;
    
    App.Boot -> MainC;
    App.Leds -> LedsC;
    App.AMControl -> ActiveMessageC;
    App.Receive -> AMReceiverC;
    App.Car -> CarC;
    CarC.P20 -> GIO.Port20;
    CarC.HplMsp430Usart -> HplMsp430Usart0C.HplMsp430Usart;
    CarC.Resource -> Msp430Usart0C.Resource;
    //CarC.Resource -> Uart;
}