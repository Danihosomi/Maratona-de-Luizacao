// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

// DRIVERS Interface
void display_led(int);
void display_matrix(int matrix[8][8]);
Input read_input(Input*);

const int LINE_WIDTH = 8;
const int SCALE_FACTOR = 24;

struct Bar {
  int position;
  int size;
  int speed;
  int height;
};

void draw_bar(struct Bar);
void update_bar(struct Bar*);

int main() {
  struct Bar bar = {
    .position = -8,
    .size = 8,
    .speed = 800,
    .height = 0
  };

  struct Bar lastBar = {
    .position = 0,
    .size = 8,
    .speed = 0,
    .height = -1,
  };

  int grid[8][8];

  while(1) {
    draw_bar(bar);
    update_bar(&bar);
  }
<<<<<<< HEAD

  int grid[8][8];

  while(1) {
    displayMatrix(grid);
  }
=======
>>>>>>> 5bcd82782a57951a993662d76b35ee0672e314ac
  
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

// Address
int* LED_ADDRESS = (int*) (0b1000 << 28);
int* MATRIX_ADDRESS = (int*) (0b1010 << 28);
int* BUTTON_ADDRESS = (int*) (0b1001 << 28);

// LED
void display_led(int number) {
  *LED_ADDRESS = number;
}

// LED Matrix
#define setBit(number, i) (number |= (1 << i))

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

// Button

struct Input {
  int holding;
  int pressed;
  int released;
};

typedef struct Input Input;

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
