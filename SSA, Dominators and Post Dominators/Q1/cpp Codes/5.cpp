#include <cstdio>

// nested for loops with an early return from the inner loop
bool hasDuplicate(int a[], int n) {
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            if (a[i] == a[j])
                return true;
        }
    }
    return false;
}

int main() {
    int x[] = {3, 1, 4, 1, 5};
    int y[] = {2, 7, 1, 8};
    printf("%d %d\n", hasDuplicate(x, 5), hasDuplicate(y, 4));
    return 0;
}
