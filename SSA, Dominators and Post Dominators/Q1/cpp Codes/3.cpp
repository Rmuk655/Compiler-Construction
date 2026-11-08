#include <cstdio>

// while loop with a short-circuit (&&) condition and an if-else inside
int collatzSteps(int n) {
    int steps = 0;
    while (n != 1 && steps < 1000) {
        if (n % 2 == 0)
            n = n / 2;
        else
            n = 3 * n + 1;
        steps++;
    }
    return steps;
}

int main() {
    printf("%d %d\n", collatzSteps(6), collatzSteps(27));
    return 0;
}
