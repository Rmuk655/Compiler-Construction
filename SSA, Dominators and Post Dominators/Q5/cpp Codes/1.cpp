#include <iostream>
using namespace std;

int basicPointer(int input) {
    int value = 10;
    int *ptr = &value;
    *ptr = *ptr + input;
    return value;
}

int main() {
    cout << basicPointer(5) << endl;
}
