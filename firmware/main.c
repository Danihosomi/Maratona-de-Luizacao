// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

int* LED_ADDRESS = (int*) (0b1000 << 28);
const int LINE_WIDTH = 6;

struct Bar {
  int position;
  int size;
};

int main() {
  int speed = 1;
  int direction = 1;

  struct Bar bar = {
    .position = 0,
    .size = 2
  };

  while(1) {
    int unscaledPostion = bar.position >> 0;

    int encodedBar = 0;
    for (int i = 0; i < bar.size; i++) {
      encodedBar += 1 << (unscaledPostion + i);
    }
    *LED_ADDRESS = encodedBar;

    if (direction == 1 && unscaledPostion >= LINE_WIDTH - bar.size) {
      direction = -1;
    } else if (direction == -1 && unscaledPostion <= bar.size - 1) {
      direction = 1;
      bar.position = 0;
    }

    if (direction == 1) {
      bar.position += speed;
    } else if (direction == -1) {
      bar.position -= speed;
    }
  }

  return 0;
}

void draw_bar(int unscaledPosition) {
  *LED_ADDRESS = 1 << unscaledPosition;
}
