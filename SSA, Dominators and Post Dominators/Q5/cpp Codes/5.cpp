#include <iostream>
using namespace std;

int heapPointer(int n) {
    int *buffer = new int[n];
    int sum = 0;

    for (int i = 0; i < n; i++) {
        buffer[i] = (i + 1) * 10;
        sum += buffer[i];
    }

    delete[] buffer;
    return sum;
}

int main() {
    cout << heapPointer(5) << endl;
}
