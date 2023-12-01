// This, along with -ffunction-sections, ensures _start will be the entrypoint
// of our firmware
int main(void) __attribute__((section(".text.entrypoint")));

#define setBit(number, i) (number |= (1 << i))

int* LED_ADDRESS = (int*)(0b1000 << 28);
int* MATRIX_ADDRESS = (int*)(0b1010 << 28);
int* BUTTON_ADDRESS = (int*)(0b1001 << 28);

int letter_r_upper_matrix = 0b00000000011111000100001001000010;
int letter_r_lower_matrix = 0b01111100010010000100010001000010;

int letter_o_upper_matrix = 0b00000000001111000100001001000010;
int letter_o_lower_matrix = 0b01000010010000100100001000111100;

int letter_d_upper_matrix = 0b00000000011111000100001001000010;
int letter_d_lower_matrix = 0b01000010010000100100001001111100;

int letter_l_upper_matrix = 0b00000000010000000100000001000000;
int letter_l_lower_matrix = 0b01000000010000000100000001111110;

int letter_f_upper_matrix = 0b00000000011111100100000001000000;
int letter_f_lower_matrix = 0b01111000010000000100000001000000;

int heart_upper_matrix = 0b00000000011001101111111111111111;
int heart_lower_matrix = 0b11111111011111100011110000011000;

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
  int letter_number = 0;

  while (1) {
    Input currentInput = read_input(&inputBuffer);

    if (currentInput.pressed) letter_number++;
    if (letter_number > 9) letter_number = 0;

    *LED_ADDRESS = letter_number;

    if (letter_number == 0) {
      display_matrix(letter_r_upper_matrix, letter_r_lower_matrix);
    }

    if (letter_number == 1) {
      display_matrix(letter_o_upper_matrix, letter_o_lower_matrix);
    }

    if (letter_number == 2) {
      display_matrix(letter_d_upper_matrix, letter_d_lower_matrix);
    }

    if (letter_number == 3) {
      display_matrix(letter_o_upper_matrix, letter_o_lower_matrix);
    }

    if (letter_number == 4) {
      display_matrix(letter_l_upper_matrix, letter_l_lower_matrix);
    }

    if (letter_number == 5) {
      display_matrix(letter_f_upper_matrix, letter_f_lower_matrix);
    }

    if (letter_number == 6) {
      display_matrix(letter_o_upper_matrix, letter_o_lower_matrix);
    }

    if (letter_number == 7) {
      display_matrix(letter_f_upper_matrix, letter_f_lower_matrix);
    }

    if (letter_number == 8) {
      display_matrix(letter_o_upper_matrix, letter_o_lower_matrix);
    }

    if (letter_number == 9) {
      display_matrix(heart_upper_matrix, heart_lower_matrix);
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
