#include "sys/alt_timestamp.h"
#include "alt_types.h"
#include <stdio.h>

#define ALT_CI_MYXOR_0(n,A,B) __builtin_custom_inii(ALT_CI_MYXOR_0_N+(n&ALT_CI_MYXOR_0_N_MASK),(A),(B))
#define ALT_CI_MYXOR_0_N 0x0
#define ALT_CI_MYXOR_0_N_MASK ((1<<3)-1)


int main(void) {
	unsigned long Ticks_time1[100], Ticks_time2[100], Ticks_time11[100], Ticks_time22[100];

	if (alt_timestamp_start() < 0) {
		printf("No timestamp device available\n");
		return -1;
	}
	
	unsigned long t0 =  alt_timestamp();
	
	int indx = 0;
	int c;
	int a = -1;
	int b = 1;
	
	while(indx<100) {
		Ticks_time1[indx] = alt_timestamp();
		c = ALT_CI_MYXOR_0(0,a,b);
		Ticks_time2[indx++] = alt_timestamp();
	}
	
	indx = 0;
	
	while (indx<100) {
		Ticks_time11[indx] = alt_timestamp();
		c= a ^ b;
		Ticks_time22[indx++] = alt_timestamp();
	}

	unsigned long offset_custom[100], offset_builtin[100];
	
	int i;
	int somme_ticks_custom = 0;
	int somme_ticks_builtin = 0;
	
	for (i = 0 ; i < 100; i ++) {
		int x = Ticks_time2[i] - Ticks_time1[i];
		offset_custom[i] = x;
		somme_ticks_custom += x;
		
		x = Ticks_time22[i] - Ticks_time11[i];
		offset_builtin[i] = x;
		somme_ticks_builtin += x;
	}
	
	float moy_custom = (float)somme_ticks_custom / 100.0f;
	float moy_builtin = (float)somme_ticks_custom / 100.0f;
	printf("temps custom : %.2f \n", moy_custom);
	printf("temps builtin : %.2f \n", moy_builtin);
	return 0;
}