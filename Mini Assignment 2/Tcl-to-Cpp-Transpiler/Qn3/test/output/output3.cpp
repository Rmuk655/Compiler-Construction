#include <iostream>

using namespace std;

int main(){
    int n = 7;
    if(n > 5 && n < 10){
        cout << n << "\n";
    }
    else{
        n = 0;
        cout << n << "\n";
    }
    if(n == 3 || n > 100){
        cout << n << "\n";
    }
    else{
        n = n * 2;
        cout << n << "\n";
    }
    float f = 1.500000;
    if(f > 1){
        int m = 2;
        cout << m << "\n";
    }
    return 0;
}
