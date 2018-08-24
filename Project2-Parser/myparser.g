grammar myparser;

options{
		language = Java;
}

@members{
		boolean TRACEON = true;
}

program : (title)*(body)*
			{if (TRACEON) 
				System.out.println("program: title body");};

title : SHARP 'include' (' ')FILE WS
				{if (TRACEON)
					System.out.println("title: #include " + $FILE.text);};

body : type (' ') MAIN '('  ')' WS '{' WS (declarations)* (statements)* '}' WS
		{ if(TRACEON)
			System.out.println("body: type  main() {declarations}");}
		| senum WS {if(TRACEON) System.out.println("body: enum");}
		| sunion WS {if(TRACEON) System.out.println("body: union");}
		| sstruct WS {if(TRACEON) System.out.println("body: struct");}
		| function {if(TRACEON) System.out.println("body: fuction");};

senum : TYPEDEF (' ') ENUM '{' WS (edecl)* '}' id ';' {if(TRACEON) System.out.println("enum: typedef enum { enumdeclarations } id;");}
		| ENUM (' ') id '{' WS (edecl)* '}' ';' {if(TRACEON) System.out.println("enum: enum id { enumdeclarations };");};

sunion : UNION (' ') id '{' WS (declarations)* '}' ';' {if(TRACEON) System.out.println("union: union id {declarations};");}
		| TYPEDEF (' ') UNION '{' WS (declarations)* '}' id ';' {if(TRACEON) System.out.println("union: typedef union {declarations} id;");};

sstruct : STRUCT (' ') id '{' WS (declarations)* (sstruct)* WS? '}' ';' {if(TRACEON) System.out.println("struct: struct id {declarations};");}
		| TYPEDEF (' ') STRUCT '{' WS (declarations)* (sstruct)* '}' id ';' {if(TRACEON) System.out.println("struct: typedef struct {declarations} id;");};

function : type (' ') id '(' (fdecl)* ')' WS '{' WS (declarations)* (statements)* '}' WS
			{if(TRACEON) System.out.println("function: type id (function declaration) {declarations}");};


statements : assignment {if(TRACEON) System.out.println("statements: assignment;");}
			| forloop {if(TRACEON) System.out.println("statements: for");}
			| compare (';') WS {if(TRACEON) System.out.println("statements: compare");}
			| whileloop {if(TRACEON) System.out.println("statements: while");}
			| dowhileloop {if(TRACEON) System.out.println("statements: do while");};
			//| if | ifelse | ifelseif | dowhile;

declarations : (type ' ')* id ';' WS {if(TRACEON) System.out.println("declarations: type ID;");}
				| (type ' ')*  assignment {if(TRACEON) System.out.println("declarations: type id assignment;");};

dowhileloop : DO WS '{' WS (declarations)* (statements)* '}' WHILE '(' (compare | num) ')' ';' WS
				{if(TRACEON) System.out.println("dowhile: do {declarations statements} while(compare | num);");};

whileloop : WHILE '(' (compare | num) ')' WS '{' WS (declarations)* (statements)* '}' WS
			{if(TRACEON) System.out.println("while: while(compare | num) {declarations statements}");};

forloop : FOR '(' (assignment)* ';' (compare)* ';' (assignment)* ')' WS '{' WS (declarations)* (statements)* '}' WS
		{if(TRACEON) System.out.println("for: for (assignment; compare; assignment) {declarations statements}");};

compare : value ascom value {if(TRACEON) System.out.println("compare: value compare value");}
			| value ascom value (',') {if(TRACEON) System.out.println("compare: value compare value,");}
			| value ascom arithmetic {if(TRACEON) System.out.println("compare: value compare assignment");}
			| value ascom arithmetic (',') {if(TRACEON) System.out.println("compare: value compare assignment,");};

ascom : COMPARISON {if(TRACEON) System.out.println("assign_compare: " + $COMPARISON.text);};
/* '==' {if(TRACEON) System.out.println("assign_compare: ==");}
		| '!=' {if(TRACEON) System.out.println("assign_compare: !=");}
		| '<' {if(TRACEON) System.out.println("assign_compare: <");}
		| '<=' {if(TRACEON) System.out.println("assign_compare: <=");}
		| '>' {if(TRACEON) System.out.println("assign_compare: >");}
		| '>=' {if(TRACEON) System.out.println("assign_compare: >=");};*/

assignment : id asequ (arithmetic ';' WS)* {if(TRACEON) System.out.println("assignment: id assign_equal arithmetic;");}
				| id asequ arithmetic (',') {if(TRACEON) System.out.println("assignment: id assign_equal arithmetic,");}
				| id asequ arithmetic {if(TRACEON) System.out.println("assignment: id assign_equal arithmetic");};

asequ : '=' {if(TRACEON) System.out.println("asequ: =");}
		| '*=' {if(TRACEON) System.out.println("asequ: *=");}
		| '/=' {if(TRACEON) System.out.println("asequ: /=");}
		| '+=' {if(TRACEON) System.out.println("asequ: +=");}
		| '-=' {if(TRACEON) System.out.println("asequ: -=");}
		| '&=' {if(TRACEON) System.out.println("asequ: &=");}
		| '|=' {if(TRACEON) System.out.println("asequ: |=");}
		| '^='  {if(TRACEON) System.out.println("asequ: ^=");}
		| '>>=' {if(TRACEON) System.out.println("asequ: >>=");}
		| '<<=' {if(TRACEON) System.out.println("asequ: <<=");};

arithmetic : mult 
			('+' mult {if(TRACEON) System.out.println("arithmetic: + mult");}
			| '-' mult {if(TRACEON) System.out.println("arithmetic: - mult");})*
			{if(TRACEON) System.out.println("arithmetic: mult");};

mult : arsign 
		( '*' arsign {if(TRACEON) System.out.println("mult: * sign");}
		| '/' arsign {if(TRACEON) System.out.println("mult: / sign");})* 
		{if(TRACEON) System.out.println("mult: sign");};

arsign : value {if(TRACEON) System.out.println("sign: value");}
		| '-' value {if(TRACEON) System.out.println("sign: -value");};

value : num {if(TRACEON) System.out.println("value: num");}
		| id {if(TRACEON) System.out.println("value: id");}
		| literal {if(TRACEON) System.out.println("value: literal");};

edecl : id ',' WS* {if(TRACEON) System.out.println("edecl: id,");}
		| id WS* {if (TRACEON) System.out.println("edecl: id");};

fdecl : type (' ') id ', ' {if(TRACEON) System.out.println("fdecl: type id , ");}
		| type (' ') id {if(TRACEON) System.out.println("fdecl: type id");};

type : INT {if (TRACEON) System.out.println("type: int");}
		| DOUBLE {if(TRACEON) System.out.println("type: double");}
		| FLOAT {if(TRACEON) System.out.println("type: float");}
		| SHORT {if(TRACEON) System.out.println("type: short");}
		| UNSIGNED {if(TRACEON) System.out.println("type: unsigned");}
		| LONG {if(TRACEON) System.out.println("type: long");}
		| CONST {if(TRACEON) System.out.println("type: const");}
		| CHAR {if(TRACEON) System.out.println("type: char");}
		| AUTO {if(TRACEON) System.out.println("type: auto");}
		| SIGNED{if(TRACEON) System.out.println("type: signed");}
		| VOID {if(TRACEON) System.out.println("type: void");}
		| TYPEDEF {if(TRACEON) System.out.println("type: typedef");}
		| STRUCT {if(TRACEON) System.out.println("type: strcut");}
		| UNION {if(TRACEON) System.out.println("type: union");}
		| STATIC {if(TRACEON) System.out.println("type: static");};

id : ID {if(TRACEON) System.out.println("id: " + $ID.text);}
		| ID '[' NUMBER ']' {if(TRACEON) System.out.println("id[]: " + $ID.text + "[" + $NUMBER.text + "]");};

num : NUMBER {if(TRACEON) System.out.println("num: " + $NUMBER.text);};

literal : LITERAL {if(TRACEON) System.out.println("literal: " + $LITERAL.text);};


MAIN : 'main';
AUTO : 'auto';
DOUBLE : 'double';
INT : 'int';
STRUCT : 'struct';
CONST : 'const';
FLOAT : 'float';
SHORT : 'short';
UNSIGNED : 'unsigned';
BREAK : 'break';
ELSE : 'else';
LONG : 'long';
SWITCH : 'switch';
CONTINUE : 'continue';
FOR : 'for';
SIGNED : 'signed';
VOID : 'void';
CASE : 'case';
ENUM : 'enum';
REGISTER : 'register';
TYPEDEF : 'typedef';
DEFAULT : 'default';
GOTO : 'goto';
SIZEOF : 'sizeof';
VOLATILE : 'volatile';
CHAR : 'char';
EXTERN : 'extern';
RETURN : 'return';
UNION : 'union';
DO : 'do';
IF : 'if';
STATIC : 'static';
WHILE : 'while';

BOOL : '_Bool';
COMPLEX : '_Complex';
IMAGINARY : '_Imaginary';
INLINE : 'inline';
RESTRICT : 'restrict';

ALIGNAS : '_Alignas';
ALIGNOF : '_Alignof';
ATOMIC : '_Atomic';
GENERIC : '_Generic';
NORETURN : '_Noreturn';
STATICASSERT : '_Static_assert';
THREADLOCAL : '_Thread_local';

FILE : ('<') (LETTER | DIGIT)+ ('.h>');
BCOMMENT : ('/*') .* ('*/');
LITERAL : ('"') ~('\r' | '"')* ('"');
CHARLITERAL : ('\'') .* ('\'');
LCOMMENT : ('//') ~('\r' | '\n')*;

DP : '.';
SEMICOLON : ';';
LPARENTHESIS : '(';
RPARENTHESIS : ')';
LBRACES : '{';
RBRACES : '}';
LBRACKETS : '[';
RBRACKETS : ']';
COMMA : ',';
SIGN : '=';
SHARP : '#';

OPERATER : ('+' | '-' | '*' | '/' | '%'| '>>' | '<<' | '++' | '--' | '+=' | '-=' | '*=' | '/=' | '%=' | '?' | ':' | '?:' | '->');
COMPARISON : ('==' | '!=' | '<' | '<=' | '>' | '>=');
LOGICAL : ('&' | '|' | '^' | '&&' | '||' | '&=' | '|=' | '^=' | '~' | '!'); 

NUMBER : (DIGIT)+ |(DIGIT)+ ('.')(DIGIT)+;
ID : (LETTER) (LETTER | DIGIT | '_')*;

fragment LETTER : 'a'..'z' | 'A'..'Z';
fragment DIGIT : '0'..'9';

WS : (  ' ' | '\r' | '\t' | '\n' )*;
