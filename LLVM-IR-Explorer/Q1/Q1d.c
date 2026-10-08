#include <stdio.h>

int main(){
	// (i) Assigning Double to an Int (Narrowing)
	int a = 1;
	double b = 2.0;
	a = (int) b;
	
	// (ii) Assigning Int to a Long (Widening)
	int c = 3;
	long d = 4;
	d = (long) c;

	return 0;
}
