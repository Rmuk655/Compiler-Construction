#include <stdio.h>

int main(){
	float a = 2.3f;
	double b = 5.7;
	b = b + a;
	a = (float) b * a;
	int c = (int) (b - a);
	if(b < a){
		double d = c / a;
		a = -a;
	}
	return (int) c;
}