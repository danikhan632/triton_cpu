#include <stdfloat>
#include <ctime>
#include <iostream>


using namespace std;

#if __STDCPP_FLOAT16_T__ != 1
    #error "16-bit standard float type required"
#endif

#if __STDCPP_BFLOAT16_T__ != 1
    #error "16-bit bfloat type required"
#endif


int main()
{
    float16_t f = 0.1f16;
    bfloat16_t bf = 0.1bf16;

    
    long n = 40000;

    int start_s=clock();



    for (long i = 0; i < n; i++) {
        float16_t t = f * f * f * f;
        float16_t r = t;
    }

    int stop_s=clock();

    cout << "time: "<< (stop_s-start_s)/double(CLOCKS_PER_SEC)*1000 <<" to calculate in float16" << endl;

    start_s=clock();



    for (long i = 0; i < n; i++) {
        bfloat16_t tb = bf * bf * bf * bf;
        bfloat16_t rb = tb;
    }

    stop_s=clock();

    cout << "time: "<< (stop_s-start_s)/double(CLOCKS_PER_SEC)*1000 <<" to calculate in bfloat16" << endl;


    return 0;


}