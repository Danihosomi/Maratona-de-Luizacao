// This, along with -ffunction-sections, ensures _start will be the entrypoint
// of our firmware
int main(void) __attribute__((section(".text.entrypoint")));

#define setBit(number, i) (number |= (1 << i))

int* LED_ADDRESS = (int*)(0b1000 << 28);
int* MATRIX_ADDRESS = (int*)(0b1010 << 28);
int* BUTTON_ADDRESS = (int*)(0b1001 << 28);

char string[11] = "0123456789";

struct Input {
  int holding;
  int pressed;
  int released;
};
typedef struct Input Input;

Input read_input(Input*);

int main() {

  Input inputBuffer;
  *LED_ADDRESS = 0;
  int curr_index = 0;

  while (1) {
    Input currentInput = read_input(&inputBuffer);

    if (currentInput.pressed) curr_index++;
    curr_index %= 10;

    *LED_ADDRESS = string[curr_index];
  }

  return 0;
}

Input read_input(Input* inputBuffer) {
  Input input = {.holding = 0, .pressed = 0, .released = 0};
  input.holding = *BUTTON_ADDRESS;

  if (input.holding != inputBuffer->holding) {
    input.pressed = input.holding == 1;
    input.released = input.holding == 0;
  }
  *inputBuffer = input;

  return input;
}
