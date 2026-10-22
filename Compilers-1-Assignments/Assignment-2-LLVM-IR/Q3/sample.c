#include <stdio.h>

int main(){
	// Copy propagation
	int b = 2;
	int c = b + 1;
	int d = b;
	// Dead code elim
	int a = 2;
	a = 3;
}

