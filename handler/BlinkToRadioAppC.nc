#include <Timer.h>

configuration BlinkToRadioAppC {

}

implementation{
    components MainC;
    components BlinkToRadioC as App;
    components LedsC;

    App.Boot -> MainC;
    App.Leds-> LedsC;

    components new TimerMilliC() as Timer0;
    components ButtonC;
    components new JoyStickAppC() as JoyStick;
    components ActiveMessageC;
    components new ButtonAppC() as _Button;
    components new AMSenderC(AM_RADIO);
    components new AMReceiverC(AM_RADIO);

    App.Timer0 -> Timer0;
    App.StickHor -> JoyStick.StickHor;
    App.StickVer -> JoyStick.StickVer;
    App.Button -> _Button;
    App.Packet -> AMSenderC;
    App.AMPacket -> AMSenderC;
    App.AMSend -> AMSenderC;
    App.AMControl -> ActiveMessageC;
    //App.Receive -> AMReceiverC;
}