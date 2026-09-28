#include <iostream>

using namespace std;

int main(){
    int x = 10;
    float y = 2.020000;
    float z = x + y / 2;
    cout << z << "\n";
    if(z > 40){
        cout << z << "\n";
    }
    while(x < 20){
        x = x + 1;
        cout << x << "\n";
    }
    return 0;
}
