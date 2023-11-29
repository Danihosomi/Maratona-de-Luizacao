// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

#define setBit(number, i) (number |= (1 << i)) 

int* LED_ADDRESS = (int*) (0b1000 << 28);
int* MATRIX_ADDRESS = (int*) (0b1010 << 28);

void display_led(int);
void displayMatrix(int matrix[8][8]);

int main() {
  int matrix[8][8];

  *LED_ADDRESS = 4;

  for(int i=0;i<8;i++) {
    for(int j=0;j<8;j++) {
      matrix[i][j] = ((i+j) % 2) ? 1 : 0;
    }
  }

  int x=0;
  while(x<10) {
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        if(matrix[i][j]) {
          int value = 0;

          setBit(value, i);

          for(int k=0; k < 8; k++) {
            if(k == j) continue;
            setBit(value, k + 8);
          }

          *MATRIX_ADDRESS = value;
          for(int k=0; k < 10; k++);
        }
      }
    }
    *MATRIX_ADDRESS = 0;
  }

  // while(x<10) {
  //   displayMatrix(matrix);
  // }

  return 0;
}

// *** DRIVERS ***
// void display_led(int number) {
//   *LED_ADDRESS = number;
// }

// void displayCell(int i, int j) {
//   int value = 0;

//   setBit(value, i);

//   for(int k=0; k < 8; k++) {
//     if(k == j) continue;
//     setBit(value, k + 8);
//   }

//   *MATRIX_ADDRESS = value;
// }

// void displayMatrix(int matrix[8][8]) {
//   for(int i = 0; i < 8; i++) {
//     for(int j = 0; j < 8; j++) {
//       if(matrix[i][j]) {
//         displayCell(i, j);
//         for(int k=0; k < 10; k++);
//       }
//     }
//   }
//   *MATRIX_ADDRESS = 0;
// }

void _start() {
  // __asm__("lui sp, 0xfffff");
  main();
}