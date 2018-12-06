generic configuration ButtonAppC(){
    provides interface Button;
}

implementation {
  components HplMsp430GeneralIOC;
  components ButtonC;
  ButtonC.PortA -> HplMsp430GeneralIOC.Port60;
  ButtonC.PortB -> HplMsp430GeneralIOC.Port21;
  ButtonC.PortC -> HplMsp430GeneralIOC.Port61;
  ButtonC.PortD -> HplMsp430GeneralIOC.Port23;
  ButtonC.PortE -> HplMsp430GeneralIOC.Port62;
  ButtonC.PortF -> HplMsp430GeneralIOC.Port26;
  Button = ButtonC.Button;
}
