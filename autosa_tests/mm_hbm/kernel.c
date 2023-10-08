#include "kernel.h"

int main(int argc, char **argv) {
//  data_t A[I][K], B[K][J], C[I][J], C_golden[I][J]; 
  data_t A[I][K], B[J][K], C[I][J], C_golden[I][J];

  for (int i = 0; i < I; i++) 
    for (int k = 0; k < K; k++) {
      A[i][k] = 1;
    }

  for (int j = 0; j < J; j++)
    for (int k = 0; k < K; k++) {
      B[j][k] = 1;
    }

  for (int j = 0; j < I; j++)
    for (int k = 0; k < J; k++) {
      C[j][k] = 0;
    }

#pragma scop
  for (int i = 0; i < I; i++)
    for (int j = 0; j < J; j++) {
      C[i][j] = 0;
      for (int k = 0; k < K; k++) {
        C[i][j] = C[i][j] + A[i][k] * B[j][k];
      }
    }
#pragma endscop

  for (int i = 0; i < I; i++)
    for (int j = 0; j < J; j++) {
      C_golden[i][j] = 0;
      for (int k = 0; k < K; k++) {
        C_golden[i][j] = C_golden[i][j] + A[i][k] * B[j][k];
      }
    }

  int err = 0;
  for (int i = 0; i < I; i++) {
    for (int j = 0; j < J; j++) {
      if (fabs((float)C_golden[i][j] - (float)C[i][j]) > 0.001){
        err++;
        printf("Error @ C[%d][%d]: %.3f vs %.3f (%.3f)\n",
            i,j,
            (float)C_golden[i][j],
            (float)C[i][j],
            fabs((float)C_golden[i][j] - (float)C[i][j])
        );
      }
    }
  }

  if (err)
    printf("Failed with %d errors! %d Correct\n", err, I*J - err);
  else
    printf("Passed!\n");

  return 0;
}
