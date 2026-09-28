#include <iostream>

using namespace std;

int main(){
    int count_1 = 3;
    float avg_val = 2.500000;
    float result_2 = count_1 * avg_val;
    if(result_2 > 5 || count_1 == 0){
        cout << result_2 << "\n";
    }
    else{
    }
    while(count_1 > 0){
        count_1 = count_1 - 1;
    }
    cout << count_1 << "\n";
    if(count_1 == 0){
    }
    else{
        cout << avg_val << "\n";
    }
    return 0;
}
