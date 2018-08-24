int a;
int b;
int c;

int main()
{
	a = 1;
	printf("a = %d\n", a);
	b = 2;
	printf("b = %d\n", b);
	c = -a;
	printf("-a = %d\n", c);
	c = -b;
	printf("-b = %d\n", c);
	a = 1;
	b = 2;
	c = a - b;
	printf("a - b = %d\n", c);
	a = 1;
	b = 2;
	c = b + a;
	printf("a + b = %d\n", c);
	a = 1;
	b = 2;
	c = a * b;
	printf("a * b = %d\n", c);
	a = 1;
	b = 2;
	c = b / a;
	printf("b / a = %d\n", c);
}
