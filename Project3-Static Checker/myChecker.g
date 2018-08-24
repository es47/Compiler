grammar myChecker;

@header {
    // import packages here.
    import java.util.HashMap;
}

@members {
    boolean TRACEON = false;
    HashMap<String,Integer> symtab = new HashMap<String,Integer>();

	/*
    public enum TypeInfo {
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
       3 => char,
       -1 => do not exist,
       -2 => error
     */	   
}

program
	: include VOID MAIN '(' ')' '{' declarations statements '}'
     { if (TRACEON) System.out.println("VOID MAIN () {declarations statements}"); }
     | include INT MAIN '(' ')' '{' declarations statements '}'
     {if (TRACEON) System.out.println("INT MAIN() {declarations statements}");}
	;

include
	: ('#' INCLUDE '<' Identifier '.h' '>')*;

declarations
	: type Identifier ';'
     {
	   if (TRACEON) System.out.println($Identifier.getLine() + ": declarations: type Identifier : declarations");

  	   if (symtab.containsKey($Identifier.text)) 
  	   {
		   System.out.println("Type Error: " + 
				              $Identifier.getLine() + 
							  ": Redeclared identifier.");
	   }
	   else 
	   {
		   /* Add ID and its attr_type into the symbol table. */
		   symtab.put($Identifier.text, $type.attr_type);
	   }
	 } declarations
	| { if (TRACEON) System.out.println("declarations: "); }
	;

type returns [int attr_type]
	:INT    { if (TRACEON) System.out.println("type: INT");  $attr_type = 1; }
	| FLOAT { if (TRACEON) System.out.println("type: FLOAT");  $attr_type = 2; }
	| CHAR { if (TRACEON) System.out.println("type: CHAR");  $attr_type = 3; }
	| DOUBLE { if (TRACEON) System.out.println("type: DOUBLE");  $attr_type = 2; }
	;

statements
	:statement statements
	|;

arith_expression returns [int attr_type]
	: a = multExpr { $attr_type = $a.attr_type; } //{System.out.println("a.attr_type: " + $)}
      ( '+' b = multExpr
	    { if ($a.attr_type != $b.attr_type) {
			  System.out.println("Type Error: " + 
				                 $a.start.getLine() +
						         ": Type mismatch for the operator + in an expression.");
		      $attr_type = -2;
		  }
		  //System.out.println("a.attr_type: " + $a.attr_type + "  b.attr_type: " + $b.attr_type);
        }
	  | '-' c = multExpr
	  	{ if ($a.attr_type != $c.attr_type) {
	  		  System.out.println("Type Error: " + $a.start.getLine() + ": Type mismatch for the operator - in an expression.");
	  		  $attr_type = -2;
	  		}
	  	}
	  )*
	;

multExpr returns [int attr_type]
	: a = signExpr { $attr_type = $a.attr_type; } //{System.out.println("a.attr_type: " + $a.attr_type);}
      ( '*' b = signExpr
      	{ 
      		if ($a.attr_type != $b.attr_type)
      		{
      			System.out.println("Type Error: " + $a.start.getLine() + ": Type mismatch for the operator * in an expression.");
      			$attr_type = -2;
			}
		}
      | '/' c = signExpr
      	{
      		if ($a.attr_type != $c.attr_type)
			{
				System.out.println("Type Error: " + $a.start.getLine() + ": Type mismatch for the operator / in an expression.");
				$attr_type = -2;
			}
		}
	  )*
	;

signExpr returns [int attr_type]
	: primaryExpr { $attr_type = $primaryExpr.attr_type; } //{System.out.println("primaryExpr.attr_type: " + $primaryExpr.attr_type);}
	| '-' primaryExpr
	;
		  
primaryExpr returns [int attr_type] 
	: Integer_constant        { $attr_type = 1; }
	| Floating_point_constant { $attr_type = 2; }
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
		}
	}
	| '(' arith_expression ')' { $attr_type = $arith_expression.attr_type; }
    ;

statement returns [int attr_type]
	: assign ';'
	| int_arith ';'
	| BREAK ';'
	| CONTINUE ';'
	| IF '(' condition ')' loop_statements else_if_statements else_statements
	| WHILE '(' condition ')' loop_statements
	| DO loop_statements WHILE '(' condition ')' ';'
	| FOR '(' for_assign ';' condition ';' for_assign  ')' loop_statements
	| SWITCH '(' a = switch_condition ')' '{'b =  switch_statements '}'
	{
		if ($a.attr_type != $b.attr_type)
		{
			System.out.println("Type Error: " + $a.start.getLine() + ": Type mismatch for the switch condition and the case value");
			$attr_type = -2;
		}
	}
	;

assign returns [int attr_type]
	: Identifier ASSIGN arith_expression
	 {
	   if (symtab.containsKey($Identifier.text)) {
		   $attr_type = symtab.get($Identifier.text);
	   } else {
		   /* Add codes to report and handle this error */
		   System.out.println("Type Error: " + $Identifier.getLine() + ": Undecleared identifier.");
		   $attr_type = -2;
		   return $attr_type;
	   }
		
	   if ($attr_type != $arith_expression.attr_type) {
		   System.out.println("Type Error: " + 
							  $arith_expression.start.getLine() +
							  ": Type mismatch for the two silde operands in an assignment statement.");// + $attr_type + "  " + $arith_expression.attr_type);
		   $attr_type = -2;
	   }
	 }
	 | Identifier ASSIGN int_arith
	  {
		if (symtab.containsKey($Identifier.text)) {
			$attr_type = symtab.get($Identifier.text);
		} else {
			/* Add codes to report and handle this error */
			System.out.println("Type Error: " + $Identifier.getLine() + ": Undecleared identifier.");
			$attr_type = -2;
			return $attr_type;
		}
		 
		if ($attr_type != $int_arith.attr_type) {
			System.out.println("Type Error: " + 
							   $int_arith.start.getLine() +
							   ": Type mismatch for the two silde operands in an assignment statement.");// + $attr_type + "  " + $arith_expression.attr_type);
			$attr_type = -2;
		}
	  };

int_arith returns [int attr_type]
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
	}
	;

for_assign returns [int attr_type]
	: assign for_assign
	| ',' assign for_assign
	|;

condition returns [int attr_type]
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
		}
		| c = logic_expression
		{
			if ($a.attr_type != $c.attr_type)
			{
				System.out.println("Type Error: " + $a.start.getLine() + ": Type mismatch for the operator " + $c.log + " in an expression.");
				//System.out.println($a.attr_type + "  " + $c.attr_type);
				$attr_type = -2;
			}
		}
		|
	)
	|;

compare_expression returns [int attr_type, String comp]
	: COMPARE a = arith_expression 
	{ 
		$attr_type = $a.attr_type; 
		$comp = $COMPARE.text;
	}
	;

logic_expression returns [int attr_type, String log]
	: LOGIC a = arith_expression 
	{
		$attr_type = $a.attr_type;
		$log = $LOGIC.text;
	}
	;

loop_statements
	: statement
	| '{' statements '}'
	| ';'
	;

else_if_statements
	: ELSEIF '(' condition ')' loop_statements
	|;

else_statements
	: ELSE loop_statements
	|;

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

		   
/* ====== description of the tokens ====== */
FLOAT:'float';
INT:'int';
MAIN: 'main';
VOID: 'void';
IF: 'if';
CHAR: 'char';
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

Identifier:('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')* ('[' Integer_constant ']')*;
Integer_constant:'0'..'9'+;
Floating_point_constant:'0'..'9'+ '.' '0'..'9'+;

WS:( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;};
COMMENT: ('/*' .* '*/') | ('//' .* '\n') {$channel=HIDDEN;};
