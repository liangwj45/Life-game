/**
 * @file life.cc
 * @author liangwj (liangwj45@mail2.sysu.edu.cn)
 * @brief 生命游戏
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * 生命游戏中，对于任意细胞，规则如下：
 * - 每个细胞有两种状态：存活或死亡，每个细胞与以自身为中心的周围八格细胞产生互动。
 * - 当前细胞为存活状态时，当周围的存活细胞低于2个时（不包含2个），该细胞变成死亡状态。（模拟生命数量稀少）
 * - 当前细胞为存活状态时，当周围有2个或3个存活细胞时，该细胞保持原样。
 * - 当前细胞为存活状态时，当周围有超过3个存活细胞时，该细胞变成死亡状态。（模拟生命数量过多）
 * - 当前细胞为死亡状态时，当周围有3个存活细胞时，该细胞变成存活状态。（模拟繁殖）
 * 可以把最初的细胞结构定义为种子，当所有在种子中的细胞同时被以上规则处理后，可以得到第一代细胞图。
 * 按规则继续处理当前的细胞图，可以得到下一代的细胞图，周而复始。
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * @version 0.1
 * @date 2019-01-02
 *
 * @copyright Copyright (c) 2019
 *
 */
#include <bits/stdc++.h>
using namespace std;
#define forto(i,b,n) for(int(i)=(b);(i)<=(n);++(i))

int max_iters;
const int SIZE=15;
char newboard[SIZE][SIZE];
char board[SIZE][SIZE] = {
   {1,0,0,0,0,0,0,0,0,0,1,0,0,0,0},
   {1,1,0,0,0,0,0,0,0,0,1,1,0,0,0},
   {0,0,0,1,0,0,0,0,0,0,1,0,1,0,0},
   {0,0,1,0,1,0,0,0,0,0,1,0,0,1,0},
   {0,0,0,0,1,0,0,0,0,0,1,0,0,0,1},
   {0,0,0,0,1,1,1,0,0,0,1,0,0,1,0},
   {0,0,0,1,0,0,1,0,0,0,1,0,1,0,0},
   {0,0,1,0,0,0,1,0,0,0,1,1,0,0,0},
   {0,0,1,0,0,0,1,0,0,0,1,0,1,0,0},
   {0,0,1,0,0,0,1,0,0,0,1,0,0,1,0},
   {0,0,1,0,0,0,0,0,0,0,1,0,0,0,1},
   {0,0,1,0,0,0,0,0,0,0,1,0,0,1,0},
   {0,0,1,0,0,0,0,0,0,0,1,0,1,0,0},
   {0,0,1,0,0,0,0,0,0,0,1,1,0,0,0},
   {0,0,1,0,0,0,0,0,0,0,1,0,0,0,0},
};

int neighbours(int i,int j){
   int cnt=0;
   forto(x,-1,1)forto(y,-1,1)
     if(i+x<0||i+x>SIZE-1||j+y<0||j+y>SIZE-1||(x==0&&y==0))continue;
     else cnt+=(board[i+x][j+y]==1);
   return cnt;
}

void copyBackAndShow() {
  int i,j;
  forto(i,0,SIZE-1){
    forto(j,0,SIZE-1){
      board[i][j]=newboard[i][j];
      putchar(board[i][j]==0?'.':'#');
    }
    putchar('\n');
  }
}

int main(void) {
  printf("# Iterations: "),cin>>max_iters;
  forto(n,1,max_iters){
    forto(i,0,SIZE-1){
      forto(j,0,SIZE-1){
        int cnt=neighbours(i,j);
        if(cnt<2)newboard[i][j]=0;
        else if(cnt==2)newboard[i][j]=board[i][j];
        else if(cnt==3)newboard[i][j]=1;
        else newboard[i][j]=0;
      }
    }
    printf("\nAfter Iteration %d\n", n);
    copyBackAndShow();
  }
  return 0;
}
