// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

int* const LED_ADDRESS = (int*) (0b1000 << 28);
const int* const BUTTON_ADDRESS = (int*) (0b1001 << 28);

struct Input {
  int holding;
  int pressed;
  int released;
};
typedef struct Input Input;

Input read_input(Input*);
int read_button();
void display_led(int);

int main() {
  Input inputBuffer;
  int i = 0;

  while (1) {
    Input currentInput = read_input(&inputBuffer);

    if (currentInput.pressed) i++;

    display_led(i);
  }

  return 0;
}

Input read_input(Input* inputBuffer) {
  Input input = {
    .holding = 0,
    .pressed = 0,
    .released = 0
  };
  input.holding = read_button();

  if (input.holding != inputBuffer->holding) {
    input.pressed = input.holding == 1;
    input.released = input.holding == 0;
  }
  *inputBuffer = input;

  return input;
}

int read_button() {
  return *BUTTON_ADDRESS;
}

void display_led(int value) {
  *LED_ADDRESS = value;
}
