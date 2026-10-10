union Data{
	int i;
	float f;
};

int main(){
	union Data d;
	d.i = 1;
	d.f = 1.5f;
	return 0;
}
