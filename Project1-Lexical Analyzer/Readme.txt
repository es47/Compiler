�b mcore8.cs.ccu.edu.tw ����

�����k:

��Wcompile���O : make
execute���O : make execute
clean���O : make clean

�ק�input��:

�bMakefile���A

execute : compile
     java -cp ./antlr-3.5.2-complete.jar:. testLexer input.c

�ק�input���ɦW�C
