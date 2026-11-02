#include <iostream>
using namespace std;

void modify(int *p) {
    *p = *p * 3 + 7;
}

int pointerEscape(int n) {
    int value = n;
    int *ptr = &value;
    modify(ptr);
    return value;
}

int main() {
    cout << pointerEscape(10) << endl;
}
