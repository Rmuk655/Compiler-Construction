#include <stdio.h>

// struct from Q3_struct.c
struct StructPoint{
	int x;
	int y;
};

// class from Q3_class.cpp
class ClassPoint{
public:
	int x;
	int y;

	// Constructor
	ClassPoint(){
		x = 0;
		y = 0;
	}
};

int main(){
	struct StructPoint sp;
	sp.x = 1;
	sp.y = 2;

	ClassPoint cp;
	return 0;
}
