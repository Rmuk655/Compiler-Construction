#include <stdio.h>

void f(int n){
    int x = n / 2, y = n / 3, z = x / 4;
    for(int i = 0; i < n; i++){
        printf("Hello World\n");
    }
}

int main()
{
    int n = 10, x = n;
    return 0;
}