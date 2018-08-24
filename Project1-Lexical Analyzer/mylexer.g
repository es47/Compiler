lexer grammar mylexer;

options{
		language = Java;
}

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
RPARENTHESIS : '(';
LPARENTHESIS : ')';
RBRACES : '{';
LBRACES : '}';
RBRACKETS : '[';
LBRACKETS : ']';
COMMA : ',';
SIGN : '=';
SHARP : '#';

OPERATER : ('+' | '-' | '*' | '/' | '%'| '>>' | '<<' | '++' | '--' | '+=' | '-=' | '*=' | '/=' | '%=' | '?' | ':' | '?:' | '->');
COMPARISON : ('==' | '!=' | '<' | '<=' | '>' | '>=');
LOGICAL : ('&' | '|' | '^' | '&&' | '||' | '&=' | '|=' | '^=' | '~' | '!'); 

NUMBER : (DIGIT)+;
ID : (LETTER) (LETTER | DIGIT | '_')*;

fragment LETTER : 'a'..'z' | 'A'..'Z';
fragment DIGIT : '0'..'9';

WS : (' '|'\r'|'\t'|'\n')+;
