#include <cstdio>

// do-while loop with a switch inside (vowels = 2 points, spaces = 0, rest = 1)
int wordScore(const char *s) {
    int score = 0;
    int i = 0;
    do {
        switch (s[i]) {
        case 'a': case 'e': case 'i': case 'o': case 'u':
            score += 2;
            break;
        case ' ':
            break;
        default:
            score += 1;
        }
        i++;
    } while (s[i] != '\0');
    return score;
}

int main() {
    printf("%d\n", wordScore("hello world"));
    return 0;
}
