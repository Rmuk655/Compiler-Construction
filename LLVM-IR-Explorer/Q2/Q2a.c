#include <stdio.h>
#include <stdlib.h>

int main(){
	int arr1[5];
        int *arr2 = (int*) malloc(5 * sizeof(int));
	for(int i = 0; i < 5; i++){
		arr1[i] = i;
	}
	int d = arr1[2];
	for(int i = 0; i < 5; i++){
                arr2[i] = i;
        }
        int e = arr2[2];
	return 0;
}
