#include <iostream>
using namespace std;

int conditionalPointer(int condition) {
    int first = 100;
    int second = 200;
    int *ptr;

    if (condition > 0)
        ptr = &first;
    else
        ptr = &second;

    *ptr += 50;
    return first + second;
}

int main() {
    cout << conditionalPointer(1) << endl;
    cout << conditionalPointer(-1) << endl;
}
