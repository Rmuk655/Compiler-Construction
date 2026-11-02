#include <iostream>
using namespace std;

int arrayPointer(int n) {
    int arr[5] = {10, 20, 30, 40, 50};
    int *ptr = arr;
    int sum = 0;

    for (int i = 0; i < n && i < 5; i++)
        sum += *(ptr + i);

    return sum;
}

int main() {
    cout << arrayPointer(4) << endl;
}
