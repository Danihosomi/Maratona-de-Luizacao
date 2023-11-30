// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

#define setBit(number, i) (number |= (1 << i)) 

int* LED_ADDRESS = (int*) (0b1000 << 28);
int* MATRIX_ADDRESS = (int*) (0b1010 << 28);

void display_led(int);
void display_matrix(int matrix[8][8]);

// const int LINE_WIDTH = 6;
// const int SCALE_FACTOR = 24;

// struct Bar {
//   int position;
//   int size;
//   int speed;
// };

// void draw_bar(struct Bar);
// void update_bar(struct Bar*);

int main() {
  // struct Bar bar = {
  //   .position = 0,
  //   .size = 2,
  //   .speed = 800
  // };

  // while(1) {
  //   draw_bar(bar);
  //   update_bar(&bar);
  // }

  int matrix[8][8];

  *LED_ADDRESS = 4;

  for(int i=0;i<8;i++) {
    for(int j=0;j<8;j++) {
      matrix[i][j] = ((i+j) % 2) ? 1 : 0;
    }
  }

  while(1) {
    displayMatrix(matrix);
  }
  
  return 0;
}

// void draw_bar(struct Bar bar) {
//   int unscaledPosition = bar.position >> SCALE_FACTOR;

//   int encodedBar = 0;
//   for (int i = 0; i < bar.size; i++) {
//     encodedBar += 1 << (unscaledPosition + i);
//   }
//   *LED_ADDRESS = encodedBar;
// }

// void update_bar(struct Bar* bar) {
//   int unscaledPosition = bar->position >> SCALE_FACTOR;

//   if (bar->speed > 0 && unscaledPosition >= LINE_WIDTH - bar->size) {
//     bar->speed = -bar->speed;
//   } else if (bar->speed < 0 && unscaledPosition < bar->size) {
//     bar->speed = -bar->speed;
//     bar->position = -1;
//   }

//   bar->position += bar->speed;
// }

// *** DRIVERS ***
void display_led(int number) {
  *LED_ADDRESS = number;
}

void display_cell(int i, int j) {
  int value = 0;

  setBit(value, i);

  for(int k=0; k < 8; k++) {
    if(k == j) continue;
    setBit(value, k + 8);
  }

  *MATRIX_ADDRESS = value;
}

void display_matrix(int matrix[8][8]) {
  for(int i = 0; i < 8; i++) {
    for(int j = 0; j < 8; j++) {
      if(matrix[i][j]) {
        displayCell(i, j);
        for(int k=0; k < 10; k++);
      }
    }
  }
  *MATRIX_ADDRESS = 0;
}
