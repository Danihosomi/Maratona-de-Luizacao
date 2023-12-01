// This, along with -ffunction-sections, ensures _start will be the entrypoint
// of our firmware
int main(void) __attribute__((section(".text.entrypoint")));

#define setBit(number, i) (number |= (1 << i))

int* LED_ADDRESS = (int*)(0b1000 << 28);
int* MATRIX_ADDRESS = (int*)(0b1010 << 28);
int* BUTTON_ADDRESS = (int*)(0b1001 << 28);

struct Input {
  int holding;
  int pressed;
  int released;
};
typedef struct Input Input;

Input read_input(Input*);
void display_matrix(int upper_matrix, int lower_matrix);

int main() {

  Input inputBuffer;
  *LED_ADDRESS = 0;
  int curr_operation = 3;
  int curr_value = 1;

  while (1) {
    Input currentInput = read_input(&inputBuffer);

    if (currentInput.pressed) curr_operation++;
    curr_operation %= 4;

    *LED_ADDRESS = curr_value;

    if (currentInput.pressed && curr_operation < 2) {
      curr_value *= 7;
    }

    if (currentInput.pressed && curr_operation >= 2) {
      curr_value /= 7;
    }
  }

  return 0;
}

void display_cell(int i, int j) {
  int value = 0;

  setBit(value, i);

  for (int k = 0; k < 8; k++) {
    if (k == j) continue;
    setBit(value, (k + 8));
  }

  *MATRIX_ADDRESS = value;
}

// Given upper_matrix bits and lower_matrix bits, display the matrix
void display_matrix(int upper_matrix, int lower_matrix) {
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 8; j++) {
      if (lower_matrix & (1 << ((i << 3) + j))) display_cell(i, j);
      if (upper_matrix & (1 << ((i << 3) + j))) display_cell(i + 4, j);
    }
  }
  *MATRIX_ADDRESS = 0;
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
