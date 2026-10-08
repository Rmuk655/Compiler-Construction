int main(){
	float f = 1.5f;
	double d = 2.5;
	d = d + f;          // fpext + fadd
	f = (float) d * f;  // fptrunc + fmul
	int i = (int) d;    // fptosi
	double e = i;       // sitofp
	if (f < d) e = e / 2.0; // fcmp + fdiv
	e = -e;             // fneg
	return (int) e;
}
