#include <Msp430Adc12.h>
#include <Timer.h>

generic configuration JoyStickAppC(){
    provides interface Read<uint16_t> as StickHor;
    provides interface Read<uint16_t> as StickVer;
}

implementation {
    components JoyStickC;
    components new AdcReadClientC() as info1;
    components new AdcReadClientC() as info2;
    
    info1.AdcConfigure -> JoyStickC.AdcConfigureHorizonal;
    info2.AdcConfigure -> JoyStickC.AdcConfigureVertical;
    StickHor = info1.Read;
    StickVer = info2.Read;
}