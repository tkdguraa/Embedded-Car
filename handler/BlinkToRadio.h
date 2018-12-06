#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H

typedef nx_struct RadioPacket{
    nx_uint8_t Data;
}BlinkToRadioMsg;

enum{
    GO_STRAIGHT = 2,
    TURN_BACK = 3,
    TURN_LEFT = 4,
    TURN_RIGHT = 5,
    STOP = 6,
    AM_RADIO = 9,
    BUTTON_A = 10,
    BUTTON_B = 11,
    BUTTON_C = 12,
    BUTTON_D = 13,
    BUTTON_E = 14,
    BUTTON_F = 15,
    TIMER_PERIOD_MILLI = 100
};
#endif