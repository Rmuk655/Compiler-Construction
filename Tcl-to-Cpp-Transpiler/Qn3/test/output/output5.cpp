#include <iostream>

using namespace std;

int main(){
    int n = 5;
    int fact = 1;
    int i = 1;
    while(i < n + 1){
        fact = fact * i;
        i = i + 1;
    }
    cout << fact << "\n";
    float total = 0.500000;
    int k = 0;
    while(k < 4){
        total = total + k * 1.500000;
        k = k + 1;
    }
    cout << total << "\n";
    return 0;
}
