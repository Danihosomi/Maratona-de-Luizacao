// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

int* LED_ADDRESS = (int*) (0b1000 << 28);
const int LINE_WIDTH = 6;

void display_led(int);

int main() {
  int position = 0;
  // int speed = 1;
  int direction = 1;

  while(1) {
    int unscaledPostion = position >> 24;
    *LED_ADDRESS = 1 << unscaledPostion;

    if (direction == 1 && unscaledPostion >= LINE_WIDTH) {
      direction = -1;
    } else if (direction == -1 && unscaledPostion <= 0) {
      direction = 1;
      position = 0;
    }

    if (direction == 1) {
      position = position + 800;
    } else if (direction == -1) {
      position = position - 800;
    }
  }

  return 0;
}