#include "stdio.h"
#include "stdlib.h"
#include "math.h"

typedef float data_t;
//#define I 256
//#define J 256
//#define K 256
//#define L 256

// I: d_model
// J: num_experts
// K: num_tokens
// L: d_ff
#define I 64
#define J 8
#define K 8
#define L 256
