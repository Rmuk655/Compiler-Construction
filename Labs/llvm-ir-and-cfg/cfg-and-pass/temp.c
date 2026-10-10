#include <stdio.h>

int foo(int a)
{
    int c = 3;
    return a - a;
}

int bar()
{
    int b = 10;
    foo(b);
    return b;
}