// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

int* LED_ADDRESS = (int*) (0b1000 << 28);

void display_led(int);

int main() {
  for (int i = 0; i < 4; i++) {
    *LED_ADDRESS = i;
  }
  return 0;
}

// *** DRIVERS ***
void display_led(int number) {
  *LED_ADDRESS = number;
}

void _start() {
  // __asm__("lui sp, 0xfffff");
  main();
}