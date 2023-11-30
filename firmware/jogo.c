#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

int jogo[505][505], score, lenghtBarra = 8, lBarra=8, H = 1, dir=1, vel = 1;

void clearScreen(){
  const char *CLEAR_SCREEN_ANSI = "\e[1;1H\e[2J";
  write(STDOUT_FILENO, CLEAR_SCREEN_ANSI, 12);
}

void printMatriz(){
    int ALTURA = ((H-1)/8);
    clearScreen();

    if(H%8==1 && H!=1){
        for(int i=H+6;i>=H-1;i--){
            if(i==H){            
                for(int j=0;j<24;j++) jogo[i][j] = 0;
                for(int j=lBarra;j<lenghtBarra+lBarra;j++) jogo[i][j] = 1;
            }   
            for(int j=8;j<=15;j++) printf("%d ", jogo[i][j]);
            printf("\n");
        }
    }

    else{
        for(int i=8*ALTURA+8;i>=8*ALTURA+1;i--){
            if(i==H){            
                for(int j=0;j<24;j++) jogo[i][j] = 0;
                for(int j=lBarra;j<lenghtBarra+lBarra;j++) jogo[i][j] = 1;
            }   
            for(int j=8;j<=15;j++) printf("%d ", jogo[i][j]);
            printf("\n");
        }
    }

    fflush(stdout);
}

void wait(int speed){
   usleep(100000*speed);
}

int main(){
    for(int i=8;i<=15;i++) jogo[0][i] = 1;

    while(1){
        printMatriz();
        wait(vel);

        if(_kbhit()){
            char c = _getch();
            int nLenght = 0;

            for(int i=0;i<=24;i++) jogo[H][i] = 0;
            for(int i=lBarra;i<lBarra+lenghtBarra;i++){ 
                if(jogo[H-1][i]==1) jogo[H][i] = 1, nLenght++;
            }

            lenghtBarra = nLenght; H++; dir = 1; lBarra = 8;
            if(lenghtBarra<=0) break;
            score++; 
        }

        else{
            if(dir){
                lBarra++;
                if(lBarra>15) dir = 0;
            }
            else{
                lBarra--;
                if(lBarra+lenghtBarra<=8) dir = 1;
            }
        }

        vel = 5-(score/8);
    }

    printf("Parabens seu score final foi: %d\n", score);

    return 0;
}