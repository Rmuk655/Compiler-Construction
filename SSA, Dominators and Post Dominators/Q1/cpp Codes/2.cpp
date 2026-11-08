#include <cstdio>

// for loop that uses both continue and break
int sumOdd(int n, int limit) {
    int sum = 0;
    for (int i = 1; i <= n; i++) {
        if (i % 2 == 0)
            continue;
        sum += i;
        if (sum > limit)
            break;
    }
    return sum;
}

int main() {
    printf("%d %d\n", sumOdd(10, 100), sumOdd(10, 10));
    return 0;
}
