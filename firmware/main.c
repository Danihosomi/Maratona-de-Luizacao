// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

int* MATRIX_ADDRESS = (int*) (0b1010 << 28);

struct Input {
  int holding;
  int pressed;
  int released;
};
typedef struct Input Input;

void display_led(int);
void display_matrix(int matrix[8][8]);
Input read_input(Input*);

// *** GAME ***
const int GRID_WIDTH = 8;

struct Bar {
  int position;
  int size;
  int height;
  int direction;
};
typedef struct Bar Bar;

void update_bar(struct Bar*);

int main() {
  Input inputBuffer = {
    .holding = 0,
    .pressed = 0,
    .released = 0
  };
  
  Bar lastBar = {
    .position = 0,
    .size = GRID_WIDTH,
    .height = 0,
    .direction = 0
  };
  Bar currentBar = {
    .position = 0,
    .size = 4,
    .height = 0,
    .direction = 1
  };

  for (int i = 0; i < GRID_WIDTH; i++)
    for (int j = 0; j < GRID_WIDTH; j++)
      *(MATRIX_ADDRESS + (i << 3) + j) = 0;

  int period = 40000;
  while(1) {
    for (int i = 0; i < period; i++) {
      Input currentInput = read_input(&inputBuffer);
      if (currentInput.pressed) {
        int delta = 0;
        for (int i = 0; i < GRID_WIDTH; i++) {
          if (i >= currentBar.position && i < currentBar.position + currentBar.size) {
            if (i < lastBar.position || i >= lastBar.position + lastBar.size) {
              *(MATRIX_ADDRESS + (currentBar.height << 3) + i) = 0;
              delta++;
            }
          }
        }
        currentBar.size -= delta;
        lastBar.size = currentBar.size;
        if (currentBar.position > lastBar.position) {
          lastBar.position = currentBar.position;
        }

        currentBar.height++;
        period -= 4000;
        break;
      }
    }
    update_bar(&currentBar);
  }

  return 0;
}

void update_bar(struct Bar* bar) {
  if (bar->position == 0 && bar->direction < 0) {
    bar->direction = 1;
  } else if (bar->position + bar->size == GRID_WIDTH && bar->direction > 0) {
    bar->direction = -1;
  }

  bar->position += bar->direction;

  for (int i = 0; i < GRID_WIDTH; i++) {
    int* address = MATRIX_ADDRESS + (bar->height << 3) + i;
    if (i < bar->position || i >= bar->position + bar->size) {
      *address = 0;
    } else {
      *address = 1;
    }
  }
}



// *** DRIVERS ***
// Address
const int* const BUTTON_ADDRESS = (int*) (0b1001 << 28);

// Button
int read_button() {
  return *BUTTON_ADDRESS;
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