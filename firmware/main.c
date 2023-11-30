// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));

#define max(a, b) (a > b) ? a : b
#define abs(a) (a > 0) ? a : -a

// *** DRIVERS Interface ***
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
const int TARGET = (int)1e7;
const int UPDATE_RATE = 1000;

struct Bar {
  int position;
  int size;
  int target;
  int counter;
  int height;
  int isLeft;
};

void clearGrid(int grid[GRID_WIDTH][GRID_WIDTH]);
struct Bar create_new_bar(int size, int target, int height);
void draw_bar(struct Bar, int grid[GRID_WIDTH][GRID_WIDTH]);
void update_bar(struct Bar*, int grid[GRID_WIDTH][GRID_WIDTH]);
int is_inside_bounds(int idx);
struct Bar fixate_bar(struct Bar bar, struct Bar lastBar);

int main() {
  struct Bar bar = create_new_bar(0, TARGET, 0);
  struct Bar lastBar = create_new_bar(0, 0, -1);

  Input inputBuffer = {
    .holding = 0,
    .pressed = 0,
    .released = 0
  };

  int grid[GRID_WIDTH][GRID_WIDTH];
  clearGrid(grid);
  draw_bar(bar, grid);
  
  while(1) {
    update_bar(&bar, grid);
    display_matrix(grid);
    inputBuffer = read_input(&inputBuffer);

    if(inputBuffer.pressed) {
      
      lastBar = fixate_bar(bar, lastBar);
      draw_bar(lastBar, grid);

      if(lastBar.size == 0) break;

      bar = create_new_bar(lastBar.size, lastBar.target - UPDATE_RATE, lastBar.height + 1);
      draw_bar(bar, grid);
    }
  }

  return 0;
}

void clearLine(int i, int grid[GRID_WIDTH][GRID_WIDTH]) {
  for(int j = 0; j < GRID_WIDTH; j++) {
    grid[i][j] = 0;
  }
}

void clearGrid(int grid[GRID_WIDTH][GRID_WIDTH]) {
  for(int i = 0; i < GRID_WIDTH; i++) {
    clearLine(i, grid);
  }
}

struct Bar create_new_bar(int size, int target, int height) {
  return (struct Bar) {
    .position = 0,
    .size = size,
    .target = target,
    .counter = 0,
    .height = height,
    .isLeft = 0,
  };
}

struct Bar fixate_bar(struct Bar bar, struct Bar lastBar) {
  int errorAmount = abs(bar.position-lastBar.position);
  int newSize = max(0, bar.size - errorAmount);

  struct Bar newBar = create_new_bar(newSize, bar.target, bar.height);

  newBar.position = max(bar.position, lastBar.position);
  return newBar;
}

int is_inside_bounds(int idx){
  return idx >= 0 && idx < GRID_WIDTH;
}

void draw_bar(struct Bar bar, int grid[GRID_WIDTH][GRID_WIDTH]) {
  clearLine(bar.height, grid);

  for(int i = bar.position; i < bar.position + bar.size; i++){
    if(is_inside_bounds(i)){
      grid[bar.height][i] = 1;
    }
  }

}

void update_bar(struct Bar* bar, int grid[GRID_WIDTH][GRID_WIDTH]) {
  bar->counter++;
  if(bar->counter < bar->target) return;
  
  bar->counter = 0;
  
  if(bar->isLeft) {
    bar->position--;
    
    if(bar->position == -GRID_WIDTH){ 
      bar->isLeft = 0;
    }
  }
  
  else {
    bar->position++;

    if(bar->position == GRID_WIDTH){
      bar->isLeft = 1;
    }
  } 

  draw_bar(*bar, grid);
}

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
        display_cell(i, j);
        for(int k=0; k < 10; k++);
      }
    }
  }
  *MATRIX_ADDRESS = 0;
}

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
