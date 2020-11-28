void print(int value) { /* print function */
}

int gcd(int b, int a) {
  if (a == 0)
    return b;
  else
    return gcd(a, b - b / a * a);
}

float fact(float n) {
  if (n < 1) {
    return 1;
  } else {
    return n * fact(n - 1);
  }
}

void main(void) {
  int x;
  int y;
  x = 100;
  y = 50;
  print(gcd(x, y));
  print(fact(10));
}
