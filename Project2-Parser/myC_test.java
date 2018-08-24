import org.antlr.runtime.*;

public class myC_test {
	public static void main(String[] args) throws Exception {

      CharStream input = new ANTLRFileStream(args[0]);
      myCLexer lexer = new myCLexer(input);
      CommonTokenStream tokens = new CommonTokenStream(lexer);
 
      myCParser parser = new myCParser(tokens);
      parser.program();
	}
}
