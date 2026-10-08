struct S{
	int x;
	int y;
};

class C{
	int x;
	int y;
public:
	void set(){ x = 1; y = 2; }
};

int main(){
	S s;
	s.x = 1;
	C c;
	c.set();
	return 0;
}
