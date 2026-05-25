/* This program demonstrates use of parallel ports in the DE0-Nano Basic Computer
 * recopie des bits d'état des switches vers les leds
*/
int main(void)
{
	volatile int * green_LED_ptr	= (int *) 0x84003010;	// green LED address
	volatile int * SW_switch_ptr	= (int *) 0x84003000;	// SW slider switch address

	while(1)
	{
		*((volatile char *) green_LED_ptr) = *((volatile char*)SW_switch_ptr);
	}
}
