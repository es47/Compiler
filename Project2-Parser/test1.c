#include <stdio.h>
#include <stdlib.h>
#include <sjiel.h>

enum abc{
	a,
	b,
	c
};

typedef enum{
	x,
	y,
	z
}xyz;

union hello{
	int i;
	float f;
	char str[20];
};

typedef union{
		int j;
		float g;
		char ing[50];
}world;

struct Ball{
		char color[10];
		double radius;
};

typedef struct{
		char name;
		int number;

		struct ball{
				char color;
				short double radius;
		};}Student;

int main()
{
	int i;
	char j;
	float a[5];
	short int x;
	long long unsigned int y;
}
