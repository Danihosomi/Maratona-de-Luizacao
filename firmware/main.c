// This, along with -ffunction-sections, ensures _start will be the entrypoint of our firmware
int main (void) __attribute__ ((section (".text.entrypoint")));
#define max(a,b) (a>b) ? a : b
#define abs(a) (a>0) ? a : -a
// DRIVERS Interface
struct Input {
  int holding;
  int pressed;
  int released;
};

typedef struct Input Input;

void display_led(int);
void display_cell(int i, int j);
int read_button();
void display_matrix(int matrix[8][8]);
Input read_input(Input*);

const int LINE_WIDTH = 8;
const int SCALE_FACTOR = 24;
const int TARGET = (int)1e8;

struct Bar {
  int position;
  int size;
  int target;
  int counter;
  int height;
  int isLeft;
};

void draw_bar(struct Bar,int grid[8][8]);
void update_bar(struct Bar*,int grid[8][8]);
int insideBound(int idx);
struct Bar fixate_bar(struct Bar bar,struct Bar lastBar,int grid[8][8]);

int main() {
  struct Bar bar = {
    .position = 0,
    .size = 8,
    .target = TARGET,
    .counter = 0,
    .height = 0,
    .isLeft = 0,
  };

  struct Bar lastBar = {
    .position = 0,
    .size = 8,
    .target = TARGET,
    .counter = 0,
    .height = -1,
    .isLeft = 0,
  };

  Input inputBuffer = {
    .holding = 0,
    .pressed = 0,
    .released = 0
  };

  int grid[8][8];
  for(int i=0;i<8;i++) for(int j=0;j<8;j++) grid[i][j] = 0;
  draw_bar(bar,grid);
  
  while(1) { // aqui o jogo acontece

    display_matrix(grid);
    inputBuffer = read_input(&inputBuffer);

    if(inputBuffer.pressed){
      
      lastBar = fixate_bar(bar,lastBar,grid);

      if(lastBar.size == 0) break; // jogo termina

      bar.position = 0;
      bar.size = lastBar.size;
      bar.target = TARGET;
      bar.counter = 0;
      bar.height = lastBar.height + 1;
      bar.isLeft = 0;
    }

    else{ 
      update_bar(&bar,grid);  
    }
  }

  //display_score();

  return 0;
}

struct Bar fixate_bar(struct Bar bar,struct Bar lastBar,int grid[8][8]){
  struct Bar novaBar = {
    .position = max(bar.position,lastBar.position),
    .size = max(0,bar.size - abs(bar.position-lastBar.position)),
    .target = TARGET,
    .counter = 0,
    .height = bar.height,
    .isLeft = 0,
  };

  draw_bar(novaBar,grid);

  return novaBar;
}


int insideBound(int idx){
  return idx>=0 && idx<LINE_WIDTH;
}

void draw_bar(struct Bar bar,int grid[8][8]) {

  for(int i = 0; i < LINE_WIDTH; i++){
    grid[bar.height][i] = 0;
  }

  for(int i = bar.position; i < bar.position+bar.size; i++){
    if(insideBound(i)){
      grid[bar.height][i] = 1;
    }
  }

}

void update_bar(struct Bar* bar,int grid[8][8]) {
  bar->counter++;
  
  if(bar->counter == bar->target){
    bar->counter = 0;
    
    if(bar->isLeft){
      bar->position--;
      
      if(bar->position == -LINE_WIDTH){ 
        bar->isLeft = 0;
      }
    }
    
    else{
      bar->position++;

      if(bar->position == LINE_WIDTH){
        bar->isLeft = 1;
      }
    } 

    draw_bar(*bar,grid);
  }
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
