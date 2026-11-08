#include <cstdio>

// if / else-if / else ladder with a nested if-else inside the last branch
int classify(int x) {
    int result;
    if (x < 0) {
        result = -1;
    } else if (x == 0) {
        result = 0;
    } else {
        if (x % 2 == 0)
            result = 2;     // positive even
        else
            result = 1;     // positive odd
    }
    return result;
}

int main() {
    printf("%d %d %d %d\n", classify(-5), classify(0), classify(4), classify(7));
    return 0;
}
