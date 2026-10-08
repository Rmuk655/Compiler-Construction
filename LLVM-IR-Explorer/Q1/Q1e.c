int main(){
	// (i) Unsigned widening (zext)
	unsigned char uc = 200;
	unsigned int ui = uc;

	// (ii) Comparison result used as an int (i1 -> i32, zext)
	int a = 1, b = 2;
	int r = (a < b);

	return 0;
}
