在 mcore8.cs.ccu.edu.tw 執行

執行方法:

單獨compile指令 : make
execute指令 : make execute
clean指令 : make clean

修改input檔:

在Makefile中，

execute : compile
     java -cp ./antlr-3.5.2-complete.jar:. testLexer input.c

修改input檔檔名。
