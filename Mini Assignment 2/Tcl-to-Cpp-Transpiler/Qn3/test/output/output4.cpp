#include <iostream>

using namespace std;

int main(){
    int i = 0;
    int sum = 0;
    while(i < 5){
        int j = 0;
        while(j < i){
            sum = sum + j;
            j = j + 1;
        }
        if(i > 2){
            cout << sum << "\n";
        }
        i = i + 1;
    }
    cout << sum << "\n";
    return 0;
}
