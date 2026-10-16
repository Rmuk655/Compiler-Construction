int f(int x, int& y) {
  return x * x + y * y;
}

int main() {
  int k = 10, sum = 0;
  
  for (int i = 0; i < k; i++) {
    for (int j = 0; j < k; j++) {
      sum += f(i, j);
    }
  }

  int cnt = 0;
  while (sum != 1) {
    if (sum % 2) {
      sum = 3 * sum + 1;
    } else {
      sum /= 2;
    }

    cnt++;
  }

  return cnt;
}