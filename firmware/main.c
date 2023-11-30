// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

int* LED_ADDRESS = (int*) (0b1000 << 28);
const int LINE_WIDTH = 6;

struct Bar {
  int position;
  int size;
};

void draw_bar(struct Bar);

int main() {
  int speed = 800;
  int direction = 1;

  struct Bar bar = {
    .position = 0,
    .size = 2
  };

  while(1) {
    int unscaledPostion = bar.position >> 24;

    // int encodedBar = 0;
    // for (int i = 0; i < bar.size; i++) {
    //   encodedBar += 1 << (unscaledPostion + i);
    // }
    // *LED_ADDRESS = encodedBar;
    draw_bar(bar);

    if (direction == 1 && unscaledPostion >= LINE_WIDTH - bar.size) {
      direction = -1;
    } else if (direction == -1 && unscaledPostion < bar.size) {
      direction = 1;
      bar.position = -1;
    }

    if (direction == 1) {
      bar.position += speed;
    } else if (direction == -1) {
      bar.position -= speed;
    }
  }

  return 0;
}

void draw_bar(struct Bar bar) {
  int unscaledPosition = bar.position >> 24;

  int encodedBar = 0;
  for (int i = 0; i < bar.size; i++) {
    encodedBar += 1 << (unscaledPosition + i);
  }
  *LED_ADDRESS = encodedBar;
}
