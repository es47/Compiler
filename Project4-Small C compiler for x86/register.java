import java.util.Stack;

public class register {
	private Stack<Integer> registerStack=new Stack<Integer>();
	
	/* Registers rax, rbx, rcx, rdx, rsi, rdi, and
	 * r8~r15 are general registers */
	public register(int low,int high)
	{
		int a;
		
		/* set integer registers (available), r0~r10 */
		for (a=high; a>=low; a--)
			registerStack.push(a);		
	}
	
	public int get()
	{
		int a;
		a = registerStack.pop();
		//System.out.println("pop a:" + a);
		return a;
	}
	
	public void set(int s)
	{
		//System.out.println("set a:" + s);
		registerStack.push(s);
	}

	public void fillUp()
	{
		int a;

		for (a = 7 - registerStack.size(); a >= 0; a--)
		{
				//System.out.println("a: " + a);
				registerStack.push(a);
		}
	}

	public String getreal(int s)
	{
		String str = new String();

		switch(s)
		{
				//case 0:
					//str = "rdi";
					//break;
				case 0:
					str = "rsi";
					break;
				case 1:
					str = "rdx";
					break;
				case 2:
					str = "rcx";
					break;
				case 3:
					str = "r8";
					break;
				case 4:
					str = "r9";
					break;
				case 5:
					str = "rax";
					break;
				case 6:
					str = "r10";
					break;
				case 7:
					str = "r11";
				default :
		}

		return str;
	}
}
