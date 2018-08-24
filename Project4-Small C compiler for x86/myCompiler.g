grammar myCompiler;

options {
    language = Java;
}

@header {
    // import packages here.
    import java.util.HashMap;
    import java.util.ArrayList;
}

@members {
    boolean TRACEON = false;
    HashMap<String,Integer> symtab = new HashMap<String,Integer>();
    int labelCount = 0;
    int loopCount = 0;
    int outLoop;
    int loopFlag = 0;
    int reLoop;

	  /*
    public enum TypeInfo {
    StringConstant,
    Integer,
		Float,
		Unknown,
		No_Exist,
		Error
    }
    */

    /* attr_type:
       1 => integer,
       2 => float,
       3 => String constant,
       -1 => do not exist,
       -2 => error
     */
     
    List<String> DataCode = new ArrayList<String>();
    List<String> TextCode = new ArrayList<String>();
 
    public static register reg = new register(0, 7);
    
    /*
     * Output prologue.
     */
    void prologue(String id)
    {
   	   TextCode.add("\n\n/* Text section */");
       TextCode.add("\t.section .text");
       TextCode.add("\t.global " + id);
       TextCode.add("\t.type " + id + ",@function");
       TextCode.add(id + ":");
       
       /* Follow x86 calling convention */
       TextCode.add("\t pushq \%rbp");
       TextCode.add("\t movq \%rsp,\%rbp");
       TextCode.add("\t pushq \%rbx"); //callee saved registers.
       TextCode.add("\t pushq \%r12"); //callee saved registers.
       TextCode.add("\t pushq \%r13"); //callee saved registers.
       TextCode.add("\t pushq \%r14"); //callee saved registers.
       TextCode.add("\t pushq \%r15"); //callee saved registers.
       TextCode.add("\t subq $8,\%rsp\n"); // aligned 16-byte boundary.
    }
    
    /*
     * Output epilogue.
     */
    void epilogue()
    {
       /* handle epilogue */
       
       /* Follow x86 calling convention */
       TextCode.add("\n\t addq $8,\%rsp");
       TextCode.add("\t popq \%r15");
       TextCode.add("\t popq \%r14");
       TextCode.add("\t popq \%r13");
       TextCode.add("\t popq \%r12");
       TextCode.add("\t popq \%rbx");
       TextCode.add("\t popq \%rbp");
	   TextCode.add("\t ret");
    }
    
    
    /* Generate a new label */
    String newLabel()
    {
       labelCount ++;
       return (new String("L")) + Integer.toString(labelCount);
    } 

    String newLoop()
    {
    	loopCount++;
    	return (new String("loop")) + Integer.toString(loopCount);
	}

	String getLoop()
	{
		return (new String("loop")) + Integer.toString(loopCount);
	}

	String getOutLoop()
	{
		return (new String("loop")) + Integer.toString(outLoop);
	}

	void setOutLoop(int lloop)
	{
		outLoop = lloop;
		loopFlag = 1;
	}

	int getLoopFlag()
	{
		return loopFlag;
	}

	void setLoopFlag()
	{
		loopFlag = 0;
	}

	void setReLoop(int rloop)
	{
		reLoop = rloop;
	}

	String getReLoop()
	{
		return (new String("loop")) + Integer.toString(reLoop);
	}
    
    public List<String> getDataCode()
    {
       return DataCode;
    }
    
    public List<String> getTextCode()
    {
       return TextCode;
    }
}


program
    : declarations functions
    ;


functions
    : function functions
    |
    ;
				  
function
    : type Identifier '(' ')' '{'
      {
         /* output function prologue */
         prologue($Identifier.text);
      }
      l_declarations statements '}'
      {
	     if (TRACEON)
		     System.out.println("type Identifier () {declarations statements}");
	    
		 /* output function epilogue */	  
	     epilogue();
	  }
	;


/* global declaraction */
declarations
    :
	  type Identifier ';' declarations
      { 
	    if (TRACEON) System.out.println("declarations: type Identifier : declarations");
		if (symtab.containsKey($Identifier.text)) {
		    System.out.println("Type Error: " + 
				                $Identifier.getLine() + 
							    ": Redeclared identifier.");
	    } else {
			/* Add ID and its attr_type into the symbol table. */
			symtab.put($Identifier.text, $type.attr_type);	   
	    }
		
		/* code generation */
		switch($type.attr_type) {
		case 1: /* Type: integer, size=> 4 bytes, alignment=> 4 byte boundary. */
		        DataCode.add("\t .common " + $Identifier.text + ",4,4\n");
				break;
		case 2: /* Type: float, size=> 4 bytes, alignment=> 4 byte boundary. */
		        DataCode.add("\t .common " + $Identifier.text + ",4,4\n");
				break;
		default:
		}
	  }
    | { if (TRACEON) System.out.println("declarations: ");}
    ;


l_declarations
    :
    type Identifier ';' l_declarations
    {
      /* If you want to handle local variables, fix it. */ 
    }
    | 
    ;


type returns [int attr_type]
    : INT   { if (TRACEON) System.out.println("type: INT");  $attr_type=1; }
    | FLOAT { if (TRACEON) System.out.println("type: FLOAT");  $attr_type=2; }
    | VOID
    | CHAR  { if (TRACEON) System.out.println("type: CHAR");  $attr_type = 3; }
    ;

statements: statement statements
    |
    ;
		
statement returns [int attr_type]
    : assign ';'
	| int_arith ';'
	| BREAK ';'
	| CONTINUE ';'
	| IF '(' condition')' loop_statements else_if_statements else_statements 
	{ 
		String loop2 = getOutLoop();
		TextCode.add(loop2 + ":");
		setLoopFlag();
	}
	| WHILE 
	{ 
		String wloop = newLoop();
		TextCode.add(wloop + ":");
		
		String wloopCut = wloop.substring(4, wloop.length());
		setReLoop(Integer.parseInt(wloopCut));
	} 
	'(' condition ')' loop_statements
	{
		String wloop2 = getReLoop();
		TextCode.add("\t jmp " + wloop2);

		String wloop3 = getLoop();
		TextCode.add(wloop3 + ":");
	}
	| DO 
	/*{
		String dloop = newLoop();
		TextCode.add(dloop + ":");

		String dloopCut = dloop.substring(4, dloop.length());
		setReLoop(Integer.parseInt(dloopCut));
	}*/
	loop_statements WHILE '(' condition ')' ';'
	| FOR '(' for_assign ';' 
	{
		String floop = newLoop();
		TextCode.add(floop + ":");
		
		String floopCut = floop.substring(4, floop.length());
		setReLoop(Integer.parseInt(floopCut));
	}
	condition ';' for_assign  ')' loop_statements
	{
		String floop2 = getReLoop();
		TextCode.add("\t jmp " + floop2);

		String floop3 = getLoop();
		TextCode.add(floop3 + ":");
	}
	| SWITCH '(' a = switch_condition ')' '{'b =  switch_statements '}'
	{
		if ($a.attr_type != $b.attr_type)
		{
			System.out.println("Type Error: " + $a.start.getLine() + ": Type mismatch for the switch condition and the case value");
			$attr_type = -2;
		}
	}
    | Identifier func_argument
    {
      /* code generation */
      TextCode.add("\t movq " + "$" + $func_argument.label + ",\%rdi");
      TextCode.add("\t call " + $Identifier.text);
	  reg.fillUp();
    }
    ;
	
assign returns [int attr_type]
	: Identifier '=' arith_expression
	  { 
	    if (symtab.containsKey($Identifier.text)) {
	       $attr_type = symtab.get($Identifier.text);
	    } else {
         /* Add codes to report and handle this error */

	       $attr_type = -2;
	    }
		  
	    if ($attr_type != $arith_expression.attr_type) {
           System.out.println("Type Error: " + 
		                       $arith_expression.start.getLine() +
 		 	                   ": Type mismatch for the two side operands in an assignment statement.");
		      $attr_type = -2;
      }
		
		  /* code generation */
      TextCode.add("\t mov " + "\%" + reg.getreal($arith_expression.reg_num) + "," + $Identifier.text + "(\%rip)");
      reg.set($arith_expression.reg_num);
	  };

int_arith returns [int attr_type, int reg_num]
	: Identifier '++'
	{ 
		if (symtab.containsKey($Identifier.text))
		{
			$attr_type = symtab.get($Identifier.text); 
		}
		else 
		{
			System.out.println("Type Error: " + $Identifier.getLine() + ": Undecleared identifier.");
			$attr_type = -2;
		}
		if ($attr_type != 1)
		{
			System.out.println("Type Error: " + $Identifier.getLine() + ": Type must be integer.");
		}

		  /* code generation */
         $reg_num = reg.get(); /* get an register */
         
         TextCode.add("\t mov " + $Identifier.text + "(\%rip), \%" + reg.getreal($reg_num));
         TextCode.add("\t inc " + "\%" + reg.getreal($reg_num));
      	 TextCode.add("\t mov " + "\%" + reg.getreal($reg_num) + "," + $Identifier.text + "(\%rip)");
      	 
      	 reg.set($reg_num);
	}
	| Identifier '--'
	{ 
		if (symtab.containsKey($Identifier.text))
		{
			$attr_type = symtab.get($Identifier.text); 
		}
		else 
		{
			System.out.println("Type Error: " + $Identifier.getLine() + ": Undecleared identifier.");
			$attr_type = -2;
		}
		if ($attr_type != 1)
		{
			System.out.println("Type Error: " + $Identifier.getLine() + ": Type must be integer.");
		}
		  /* code generation */
         $reg_num = reg.get(); /* get an register */
         
         TextCode.add("\t mov " + $Identifier.text + "(\%rip), \%" + reg.getreal($reg_num));
         TextCode.add("\t dec " + "\%" + reg.getreal($reg_num));
      	 TextCode.add("\t mov " + "\%" + reg.getreal($reg_num) + "," + $Identifier.text + "(\%rip)");
      	 
      	 reg.set($reg_num);
	}
	;

func_argument returns [String label]
    : '(' ')' ';'
      {
        /* handle function calls here. */
      }
    | '(' a = arith_expression 
      {
         /* handle function calls here. */
         if ($a.attr_type == 3) { // handle string type.
            label = newLabel();
            DataCode.add(label + ":");
            DataCode.add("\t .string " + $a.str);
            reg.fillUp();
         }
      }
	        ( ',' arith_expression )*
	    ')' ';' 
    ;

	
arith_expression returns [int attr_type, int reg_num, String str]
	: a = multExpr
	      {
	         $attr_type = $a.attr_type;
	         $reg_num = $a.reg_num;
	         $str = $a.str;
	      }
    ( '+' b = multExpr
	      { 
	        if ($a.attr_type != $b.attr_type) {
			       System.out.println("Type Error: " + 
				                 $a.start.getLine() +
						            ": Type mismatch for the operator + in an expression.");
		         $attr_type = -2;
		      }
		  
		      /* code generation */
          TextCode.add("\t add " + "\%" + reg.getreal($b.reg_num) + ", \%" + reg.getreal($reg_num));
          reg.set($b.reg_num);
        }
	  | '-' c = multExpr
		{ 
  			if ($a.attr_type != $c.attr_type) {
		 		System.out.println("Type Error: " + 
					   		$a.start.getLine() +
						  		": Type mismatch for the operator - in an expression.");
	   			$attr_type = -2;
			}

			/* code generation */
			TextCode.add("\t sub " + "\%" + reg.getreal($c.reg_num) + ", \%" + reg.getreal($reg_num));
			reg.set($c.reg_num);
		}
	  )*
	;

	
multExpr returns [int attr_type, int reg_num, String str]
	: a = signExpr 
	  { 
	     $attr_type = $a.attr_type;
	     $reg_num = $a.reg_num;
	     $str = $a.str;
	  }
      ( '*' b = signExpr
	      { 
	        if ($a.attr_type != $b.attr_type) {
			       System.out.println("Type Error: " + 
				                 $a.start.getLine() +
						            ": Type mismatch for the operator * in an expression.");
		         $attr_type = -2;
		      }
		  
		      /* code generation */
          TextCode.add("\t imul " + "\%" + reg.getreal($b.reg_num) + ", \%" + reg.getreal($reg_num));
          reg.set($b.reg_num);
        }
      | '/' c = signExpr
	      { 
	        if ($a.attr_type != $c.attr_type) {
			       System.out.println("Type Error: " + 
				                 $a.start.getLine() +
						            ": Type mismatch for the operator / in an expression.");
		         $attr_type = -2;
		      }
		  
		      /* code generation */
		  TextCode.add("\t mov " + "\%" + reg.getreal($reg_num) + ", \%rax");
		  TextCode.add("\t mov " + "\%" + reg.getreal($c.reg_num) + ", \%r10");
		  TextCode.add("\t mov $0, \%rdx");
		  TextCode.add("\t mov $0, \%rcx");
		  TextCode.add("\t mov $0, \%rbx");
          TextCode.add("\t idiv " + "\%r10");
          
          reg.set($c.reg_num);
        }
	  )*
	;


signExpr returns [int attr_type, int reg_num, String str]
	: primaryExpr
	  { 
	     $attr_type = $primaryExpr.attr_type;
	     $reg_num = $primaryExpr.reg_num;
	     $str = $primaryExpr.str;
	  }
	| '-' primaryExpr
		{ 
			$attr_type = $primaryExpr.attr_type;
			$reg_num = $primaryExpr.reg_num;
			$str = $primaryExpr.str;
  			if ($primaryExpr.attr_type != 1 & $primaryExpr.attr_type != 2) {
		 		System.out.println("Type Error: " + 
					   		$start.getLine() +
						  		": Type mismatch for the operator - in an expression.");
	   			$attr_type = -2;
			}

			/* code generation */
			TextCode.add("\t neg " + "\%" + reg.getreal($reg_num));
			//reg.set($c.reg_num);
		}
	;


primaryExpr returns [int attr_type, int reg_num, String str]
    : Integer_constant
      { 
         $attr_type = 1;
         $str = null;
         
         /* code generation */
         $reg_num = reg.get();  /* get an register */
         TextCode.add("\t mov " + "\$" + $Integer_constant.text + ", \%" + reg.getreal($reg_num)); 
      }
    | Floating_point_constant 
      { 
         $attr_type = 2; 
         $str = null;

         $reg_num = reg.get();
         TextCode.add("\t mov " + "\$" + $Floating_point_constant.text + ", \%" + reg.getreal($reg_num));
      }
    | STRING_LITERAL { $attr_type = 3; $str = $STRING_LITERAL.text; }
    | Identifier
      {
         $attr_type = symtab.get($Identifier.text);
         $str = null;
         
         /* code generation */
         $reg_num = reg.get(); /* get an register */
         
         TextCode.add("\t mov " + $Identifier.text + "(\%rip), \%" + reg.getreal($reg_num));
      }
	  | '(' arith_expression ')' { $attr_type = $arith_expression.attr_type; }
    ;

for_assign returns [int attr_type]
	: assign for_assign
	| ',' assign for_assign
	|;

condition returns [int attr_type, int reg_num, int ope]
	: a = arith_expression 
	(
		b = compare_expression
		{
			if ($a.attr_type != $b.attr_type)
			{
				System.out.println("Type Error: " + $a.start.getLine() + ": Type mismatch for the operator " + $b.comp + " in an expression.");
				//System.out.println($a.attr_type + "  " + $b.attr_type);
				$attr_type = -2;
			}

			TextCode.add("\t cmp" + " \%" + reg.getreal($a.reg_num) + ", \%" + reg.getreal($b.reg_num));
			
			String loop = newLoop();

			if ($b.comp.equals(">"))
		        TextCode.add("\t jg " + loop);
			else if ($b.comp.equals(">="))
		        TextCode.add("\t jge " + loop);
			else if ($b.comp.equals("<"))
				TextCode.add("\t jl " + loop);
			else if ($b.comp.equals("<="))
				TextCode.add("\t jle " + loop);
			else if ($b.comp.equals("=="))
				TextCode.add("\t jne " + loop);
			else if ($b.comp.equals("!="))
				TextCode.add("\t je " + loop);
		}
		| c = logic_expression
		{
			if ($a.attr_type != $c.attr_type)
			{
				System.out.println("Type Error: " + $a.start.getLine() + ": Type mismatch for the operator " + $c.log + " in an expression.");
				//System.out.println($a.attr_type + "  " + $c.attr_type);
				$attr_type = -2;
			}
			
			/* code generation */
			if ($c.log.equals("&") || $c.log.equals("&&"))
		        TextCode.add("\t and" + " \%" + reg.getreal($a.reg_num) + ", \%" + reg.getreal($c.reg_num));
			else
		        TextCode.add("\t or" + " \%" + reg.getreal($a.reg_num) + ", \%" + reg.getreal($c.reg_num));

			String loop3 = newLoop();
			
			TextCode.add("\t mov $0, \%r11");
			TextCode.add("\t cmp" + " \%" + reg.getreal($c.reg_num) + ", \%r11");
			TextCode.add("\t jg " + loop3);
		}
		|{
				String loop4 = newLoop();
				TextCode.add("\t mov $0, \%r11");
				TextCode.add("\t cmp" + " \%r11, \%" + reg.getreal($a.reg_num));
				TextCode.add("\t jle " + loop4);
		}
	)
	|;

compare_expression returns [int attr_type, String comp, int reg_num, String str]
	: COMPARE a = arith_expression 
	{ 
		$attr_type = $a.attr_type; 
		$comp = $COMPARE.text;
		$reg_num = $a.reg_num;
		$str = $a.str;
	}
	;

logic_expression returns [int attr_type, String log, int reg_num, String str]
	: LOGIC a = arith_expression 
	{
		$attr_type = $a.attr_type;
		$log = $LOGIC.text;
		$reg_num = $a.reg_num;
		$str = $a.str;
	}
	;

loop_statements
	: statement
	| '{' statements '}'
	| ';'
	;

else_if_statements
	: ELSEIF 
	{
		String loop5 = getLoop();
		
		String loop1 = newLoop();
		String loopCut1 = loop1.substring(4, loop1.length());

		setOutLoop(Integer.parseInt(loopCut1));
		TextCode.add("\t jmp " + loop1);
		
		TextCode.add(loop5 + ":");
	}
	'(' condition ')' loop_statements
	{
		String loop6 = getOutLoop();
		TextCode.add("\t jmp " + loop6);
	}
	|;

else_statements
	: ELSE 
	{
		String loop9 = getLoop();
		
		int flag = getLoopFlag();
		if (flag == 0)
		{
			String loop7 = newLoop();
			String loopCut2 = loop7.substring(4, loop7.length());

			setOutLoop(Integer.parseInt(loopCut2));
			TextCode.add("\t jmp " + loop7);
		}
		
		TextCode.add(loop9 + ":");
	}
	loop_statements
	|
	{
		int flag2 = getLoopFlag();
		if (flag2 == 0)
		{
			String loop8 = getLoop();
			String loopCut3 = loop8.substring(4, loop8.length());

			setOutLoop(Integer.parseInt(loopCut3));
		}
	};

switch_condition returns [int attr_type]
	: Identifier
	{ 
		if (symtab.containsKey($Identifier.text))
		{
			$attr_type = symtab.get($Identifier.text); 
		}
		else 
		{
			System.out.println("Type Error: " + $Identifier.getLine() + ": Undecleared identifier.");
			$attr_type = -2;
		}
	}
	| arith_expression { $attr_type = $arith_expression.attr_type;}
	;

switch_statements returns [int attr_type]
	: CASE 
	(Integer_constant {$attr_type = 1;}  
	| Identifier 
		{
			if (symtab.containsKey($Identifier.text))
			{
				$attr_type = symtab.get($Identifier.text); 
			}
			else 
			{
				System.out.println("Type Error: " + $Identifier.getLine() + ": Undecleared identifier.");
				$attr_type = -2;
				return $attr_type;
			}
			if ($attr_type != 3)
			{
				System.out.println("Type Error: " + $Identifier.getLine() + ": case value neither integer nor char.");
			}
	    } 
	) ':' case_statements switch_statements
	| DEFAULT ':' statement 
	|;

case_statements
	: statement BREAK ';'
	| ;
	
/*if_then_statements
	: statement
	| '{' statements '}'
	;*/

	
/* description of the tokens */
FLOAT:'float';
INT:'int';
VOID: 'void';
CHAR: 'char';
IF: 'if';
DOUBLE: 'double';
WHILE: 'while';
DO: 'do';
FOR: 'for';
ELSEIF: 'else if';
ELSE: 'else';
SWITCH: 'switch';
CASE: 'case';
DEFAULT: 'default';
BREAK: 'break';
CONTINUE: 'continue';
INCLUDE: 'include';

COMPARE: '>' | '<' | '>=' | '<=' | '==' | '!=';
LOGIC: '&' | '|' | '&&' | '||';
ASSIGN: '=' | '+=' | '-=' | '*=' | '/=' | '&=' | '|=' | '^=';

Identifier:('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
Integer_constant:'0'..'9'+;
Floating_point_constant:'0'..'9'+ '.' '0'..'9'+;

STRING_LITERAL
    :  '"' ( EscapeSequence | ~('\\'|'"') )* '"'
    ;

fragment
EscapeSequence
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    ;


WS:( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;};
COMMENT:'/*' .* '*/' {$channel=HIDDEN;};
