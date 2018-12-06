#include <Msp430Adc12.h>
module JoyStickC {
  provides interface AdcConfigure<const msp430adc12_channel_config_t*> as AdcConfigureHorizonal;
  provides interface AdcConfigure<const msp430adc12_channel_config_t*> as AdcConfigureVertical;
}
implementation {
    const msp430adc12_channel_config_t horizonal = {
        inch: INPUT_CHANNEL_A6,
        sref: REFERENCE_VREFplus_AVss,
        ref2_5v: REFVOLT_LEVEL_2_5,
        adc12ssel: SHT_SOURCE_ACLK,
        adc12div: SHT_CLOCK_DIV_1,
        sht: SAMPLE_HOLD_4_CYCLES,
        sampcon_ssel: SAMPCON_SOURCE_SMCLK,
        sampcon_id: SAMPCON_CLOCK_DIV_1
    };
    const msp430adc12_channel_config_t vertical = {
        inch: INPUT_CHANNEL_A7,
        sref: REFERENCE_VREFplus_AVss,
        ref2_5v: REFVOLT_LEVEL_2_5,
        adc12ssel: SHT_SOURCE_ACLK,
        adc12div: SHT_CLOCK_DIV_1,
        sht: SAMPLE_HOLD_4_CYCLES,
        sampcon_ssel: SAMPCON_SOURCE_SMCLK,
        sampcon_id: SAMPCON_CLOCK_DIV_1
    };

    async command const msp430adc12_channel_config_t* AdcConfigureHorizonal.getConfiguration(){
        return &horizonal;
    }
    async command const msp430adc12_channel_config_t* AdcConfigureVertical.getConfiguration(){
        return &vertical;
    }
}