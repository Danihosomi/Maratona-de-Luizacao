// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

int* LED_ADDRESS = (int*) (0b1000 << 28);

void test_led(int);

int main() {
  for (int i = 0; i < 3; i++) {
    test_led(i);
  }

  return 0;
}

void test_led(int test) {
    *LED_ADDRESS = test;
}
