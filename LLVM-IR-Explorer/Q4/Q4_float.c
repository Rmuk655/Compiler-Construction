#include <stdio.h>

int main(){
	float a = 2.3f;
	double b = 5.7;
	b = b + a;               // fpext + fadd
	a = (float) b * a;       // fptrunc + fmul
	int c = (int) (b - a);   // fpext + fsub + fptosi
	if(b < a){               // fpext + fcmp
		double d = c / a;    // sitofp + fdiv + fpext
		a = -a;              // fneg
	}
	return (int) c;
}
