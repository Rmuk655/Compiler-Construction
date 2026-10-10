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

// /bin/clang -Xclang -ast-dump -Xclang -ast-dump-filter=1 ast dump-filter=test -fsyntax-only '/Labs/AST/test.cpp'
// ./clang -Xclang -ast-dump -Xclang -ast-dump-filter-test -fsyntax-only '/Labs/AST/test.cpp'