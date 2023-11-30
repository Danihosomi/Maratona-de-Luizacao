// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

int* LED_ADDRESS = (int*) (0b1000 << 28);
const int LINE_WIDTH = 6;
const int SCALE_FACTOR = 24;

struct Bar {
  int position;
  int size;
  int speed;
};

void draw_bar(struct Bar);
void update_bar(struct Bar*);

int main() {
  struct Bar bar = {
    .position = 0,
    .size = 2,
    .speed = 800
  };

  while(1) {
    draw_bar(bar);
    update_bar(&bar);
  }

  return 0;
}

void draw_bar(struct Bar bar) {
  int unscaledPosition = bar.position >> SCALE_FACTOR;

  int encodedBar = 0;
  for (int i = 0; i < bar.size; i++) {
    encodedBar += 1 << (unscaledPosition + i);
  }
  *LED_ADDRESS = encodedBar;
}

void update_bar(struct Bar* bar) {
  int unscaledPosition = bar->position >> SCALE_FACTOR;

  if (bar->speed > 0 && unscaledPosition >= LINE_WIDTH - bar->size) {
    bar->speed = -bar->speed;
  } else if (bar->speed < 0 && unscaledPosition < bar->size) {
    bar->speed = -bar->speed;
    bar->position = -1;
  }

  bar->position += bar->speed;
}
