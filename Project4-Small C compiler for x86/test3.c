int a;
int b;
int c;

int main()
{
		a = -1;
		printf("a = %d\n", a);
		if (a > 0)
				printf("a > 0\n");
		else if (a == 0)
				printf("a = 0\n");
		else
				printf("a < 0\n");
		b = 2;
		printf("b = %d\n", b);
		if (b & 2)
				printf("b & 2\n");
		else
				printf("b !& 2\n");
		c = 0;
		printf("c = %d\n", c);
		if (c | 1)
				printf("c | 1\n");
}
