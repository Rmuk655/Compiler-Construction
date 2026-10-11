#include <stdio.h>

int main()
{
    int n = 10, x = n;
    for (int i = 0; i < n; i++)
    {
    }
    do{
        n--;
    }while(n > 5);
    n = x;
    while(n > 5){
        n--;
    }
    return 0;
}