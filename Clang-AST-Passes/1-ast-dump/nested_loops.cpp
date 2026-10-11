#include <stdio.h>

void f(int n){
    for(int i = 0; i < n; i++){
        printf("Hello World\n");
    }
}

int main(){
    int n = 10;
    for(int i = 0; i < n; i++){
        for(int i = 0; i < n; i++){
            printf("Hello World\n");
        }
    }
    f(n);
    return 0;
}