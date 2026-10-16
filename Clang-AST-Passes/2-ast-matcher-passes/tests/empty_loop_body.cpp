#include <stdio.h>

int main()
{
    int n = 10, x = n;
    for (int i = 0; i < n; i++)
    {
        i++;
        i--;
        i++;
        i--;
    }
    for (int i = 0; i < n; i++)
    {

    }
    do{
        x--;
        x++;
    }while(n > 5);
    do{

    }while(n > 5);
    n = x;
    while(n > 5){

    }
    while(n > 5){
        x++;
    }
    return 0;
}