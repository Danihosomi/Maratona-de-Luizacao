// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

#define setBit(number, i) (number |= (1 << i)) 

int* LED_ADDRESS = (int*) (0b1000 << 28);
int* MATRIX_ADDRESS = (int*) (0b1010 << 28);
int matrix[8][8];

void display_led(int);
void displayMatrix(int matrix[8][8]);

int main() {

  while(1) {
    // for (int i = 0; i < 8; i++) {
    //   *LED_ADDRESS = i;
    // }
    *LED_ADDRESS = 5;
    *MATRIX_ADDRESS = 255;
  }

  // for(int i=0;i<8;i++) {
  //   for(int j=0;j<8;j++) {
  //     matrix[i][j] = ((i+j) % 2) ? 1 : 0;
  //   }
  // }

  // while(1) {
  //   displayMatrix(matrix);
  // }

  return 0;
}

// *** DRIVERS ***
void display_led(int number) {
  *LED_ADDRESS = number;
}

void displayCell(int i, int j) {
  int value = 0;
  setBit(value, i);
  setBit(value, j + 8);
  *MATRIX_ADDRESS = value;
}

void displayMatrix(int matrix[8][8]) {
  for(int i = 0; i < 8; i++) {
    for(int j = 0; j < 8; j++) {
      if(matrix[i][j]) {
        displayCell(i, j);
      }
    }
  }
  *MATRIX_ADDRESS = 0;
}

void _start() {
  // __asm__("lui sp, 0xfffff");
  main();
}