union Data{
	int i;
	float f;
	char c[8];
};

int main(){
	union Data d;
	d.i = 1;
	d.f = 2.0f;
	return 0;
}
