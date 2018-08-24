#include <stdio.h>
#include <stdalign.h>
#include <complex.h>
#include <stddef.h>

struct sse_t
{
		  alignas(16) float sse_data[4];
};

noreturn void stop_now(int i) // or _Noreturn void stop_now(int i)
{
		    if (i > 0) exit(i);
}

int main()
{
		_Atomic const int * p1;
		_Bool x  = 1;
		double _Complex y = 5.2;
		double _Imaginary z = 139.89;
		inline int pow2(int);
		int * restrict rptr = (int*) malloc(10*sizeof(int));
		printf("Alignment of char = %zu\n", alignof(char));
		stop_now(2);
		static_assert(2 + 2 == 4, "Whoa dude!");
		_Thread_local a;
}
