#include <stdio.h>

int a = 5; // (i) Global Integer

int main(){
	int b = 10; // (ii) A Local Integer
	int c = 3;  // (ii) A Local Integer
	int d = a + b * c; // (iii) A local Integer initialized to a + b * c 
}
