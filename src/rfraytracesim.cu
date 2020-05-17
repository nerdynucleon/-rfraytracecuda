#include <stdio.h>
#include <cuda.h>

__global__ void computeRays() {
    printf("Hello from my kernel\n");
}

int rfraytrace(){
    computeRays<<<1,1>>>();
    cudaDeviceSynchronize();
    printf("Hello  from rfraytrace!\n");
    return 0;
}