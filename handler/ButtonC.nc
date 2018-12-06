module ButtonC{
    provides interface Button;
    uses{
        interface HplMsp430GeneralIO as PortA;
        interface HplMsp430GeneralIO as PortB;
        interface HplMsp430GeneralIO as PortC;
        interface HplMsp430GeneralIO as PortD;
        interface HplMsp430GeneralIO as PortE;
        interface HplMsp430GeneralIO as PortF;
    } 
}

implementation{
	command void Button.start(){
		call PortA.clr();
		call PortA.makeInput();

		call PortB.clr();
		call PortB.makeInput();

		call PortC.clr();
		call PortC.makeInput();

		call PortD.clr();
		call PortD.makeInput();

		call PortE.clr();
		call PortE.makeInput();

		call PortF.clr();
		call PortF.makeInput();

		signal Button.startDone();
	}

  command void Button.pinvalueA() {
    if(!call PortA.get()){
	    signal Button.pinvalueADone();
	  }
  }

  command void Button.pinvalueB() {
    if(!call PortB.get()){
	    signal Button.pinvalueBDone();
	  }
  }

  command void Button.pinvalueC() {
    if(!call PortC.get()){
	    signal Button.pinvalueCDone();
	  }
  }

  command void Button.pinvalueD() {
    if(!call PortD.get()){
	    signal Button.pinvalueDDone();
	  }
  }

  command void Button.pinvalueE() {
    if(!call PortE.get()){
	    signal Button.pinvalueEDone();
	  }
  }

  command void Button.pinvalueF() {
    if(!call PortF.get()){
	    signal Button.pinvalueFDone();
	  }
  }
}