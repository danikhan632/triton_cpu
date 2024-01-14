#include <stdio.h>
#include <arm_sve.h>
#include <stdlib.h>
#include <time.h>

#ifndef __ARM_FEATURE_SVE
#warning "Make sure to compile for SVE!"
#endif

#define MATRIX_SIZE 900
double get_time() {
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (double)t.tv_sec + (double)t.tv_nsec * 1.0e-9;
}
void matmul_sve(float *A, float *B, float *C,int N) {
    svbool_t pg = svptrue_b32();

for (int i = 0; i < MATRIX_SIZE; ++i) {
        for (int j = 0; j < MATRIX_SIZE; ++j) {
            svfloat32_t sum = svdup_n_f32(0);

            for (int k = 0; k < MATRIX_SIZE; k += svcntw()) {
                svbool_t mask = svwhilelt_b32(k, MATRIX_SIZE);
                svfloat32_t va = svld1(pg, &A[i * MATRIX_SIZE + k]);
                svfloat32_t vb = svld1(pg, &B[k * MATRIX_SIZE + j]);
                sum = svmla_f32_m(mask, sum, va, vb);
            }

            // Corrected usage of svaddv_f32
            C[i * MATRIX_SIZE + j] = svaddv_f32(svwhilelt_b32(0, MATRIX_SIZE), sum);
        }
    }
}
void matmul_cpu(float* A, float* B, float* C, int N) {
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            float sum = 0.0f;
            for (int k = 0; k < N; ++k) {
                sum += A[i * N + k] * B[k * N + j];
            }
            C[i * N + j] = sum;
        }
    }
}
void benchmark(float* A, float* B, float* C, int N, void (*matmul_func)(float*, float*, float*, int)) {
    double start = get_time();
    matmul_func(A, B, C, N);
    double end = get_time();
    printf("Time taken: %f seconds\n", end - start);
}
int main() {
    //float A[MATRIX_SIZE * MATRIX_SIZE], B[MATRIX_SIZE * MATRIX_SIZE], C[MATRIX_SIZE * MATRIX_SIZE];

    // Seed the random number generator
    srand((unsigned int)time(NULL));

    int N = MATRIX_SIZE;  // Matrix size
    float *A = (float*)malloc(N * N * sizeof(float));
    float *B = (float*)malloc(N * N * sizeof(float));
    float *C = (float*)malloc(N * N * sizeof(float));

    // Initialize A and B with random values
    for (int i = 0; i < MATRIX_SIZE * MATRIX_SIZE; ++i) {
        A[i] = (float)rand() / RAND_MAX * 100; // Random float between 0 and 100
        B[i] = (float)rand() / RAND_MAX * 100; // Random float between 0 and 100
    }
    printf("Benchmarking SVE-based matrix multiplication...\n");
    benchmark(A, B, C, N, matmul_sve);

    printf("Benchmarking CPU-based matrix multiplication...\n");
    benchmark(A, B, C, N, matmul_cpu);
    
}
