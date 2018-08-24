#include <stdio.h>

typedef enum
{
		All,
		January,
		February,
		March,
		April,
		May
}month;

union Data 
{
		int i;
		float f;
		char str[20];
} data;  

struct student
{
		long int id;
		char name[20];
		const float percentage;
}

int main()
{
		auto int i;
		short double x;
		unsigned float y;
		signed int j;
		for (i = 0; i < 5; i++)
		{
				if (i == 0)
				{
						break;
				}
				else
				{
						continue;
				}
		}
		do
		{
				j++;
				if(j == 3)
						goto stop;
		}
		while(i--);
		printf("hello\n");

stop: printf_s( "Jumped to stop. i = %d\n", i );

	  return 0;
}

static volatile int foo;

void bar (void) 
{
		extern double foo;
		foo = 0;
		while (foo != 255)
		{
				for(register int i = 0; i < 10000000; i++);
		}
}

void abc() 
{
		long int a;
		char c;
		size=sizeof(c);
		switch ( c )  
		{  
				case 'A':  
						capa++;  
						break;  
				case 'a':  
						lettera++;  
						break;  
				default:  
						nota++;  
		}  
}
