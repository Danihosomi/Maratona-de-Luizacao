// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

int* LED_ADDRESS = (int*) (0b1000 << 28);
int* MATRIX_ADDRESS = (int*) (0b1010 << 28);

void display_led(int);
void displayMatrix(int** matrix);

#define setBit(number, i) (number |= (1 << i)) 

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

void displayCell(int i, int j, int** matrix) {
  int value = 0;
  setBit(value, i);
  setBit(value, j + 8);
  *MATRIX_ADDRESS = value;
}

void displayMatrix(int** matrix) {
  for(int i = 0; i < 8; i++) {
    for(int j = 0; j < 8; j++) {
      if(matrix[i][j]) {
        displayCell(i, j, matrix);
      }
    }
  }
  *MATRIX_ADDRESS = 0;
}

void _start() {
  // __asm__("lui sp, 0xfffff");
  main();
}