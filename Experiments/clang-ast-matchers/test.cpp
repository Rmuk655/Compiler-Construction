#include <iostream>

void test(){
    int b;
    int a = 10;
    if(a > 10){
        a++;
    }
    else{
        a--;
    }
}

int main(){
    test();
}

// Dump the AST of test() with clang (adjust the path to your clang build):
//   clang -Xclang -ast-dump -Xclang -ast-dump-filter=test -fsyntax-only test.cpp
