interface Car
{
	command void transmit_cmd();
    command void start();
	command void angle_up();
	command void angle_down();
	command void left();
	command void right();
	command void forward();
	command void back();
	command void stop();
}