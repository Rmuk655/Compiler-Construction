#include <stdio.h>

int main(){
    int n = 10;
    if(n = 13){
        n++;
    }
    if(n == 10){
        n--;
    }
    for(int i = 10; i = 10; i++){
        n--;
    }
    for(int i = 10; i == 10; i++){
        n--;
    }
    while(n = 10){
        n--;
    }
    while(n == 10){
        n--;
    }
    do{
        n--;
    } while(n = 10);
    do{
        n--;
    } while(n == 10);
    n = (n = 10) ? 1 : 0;
    n = (n == 10) ? 1 : 0;
    return 0;
}