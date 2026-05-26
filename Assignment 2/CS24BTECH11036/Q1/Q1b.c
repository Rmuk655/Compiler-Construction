#include <stdio.h>

int main(){
	int a = 2, b = 3;
	// (i) If-Else Condition
	if (a == 2){
		a = 2;
	}
	else{
		a = 2;
	}

	// (ii) Switch Case Condition
	switch(a){
		case 1: a = 2; break;
		case 2: a = 2; break;
		default: a = 2; break;
	}

	// (iii) For loop
	for (int i = a; i < 5; i++){
		a++;
	}
	
	// (iv) While loop
	while (a < 5){
		a++;
	}

	// (v) Do-While loop
	do {
		a++;
	} while ( a < 5);

	return 0;
}
