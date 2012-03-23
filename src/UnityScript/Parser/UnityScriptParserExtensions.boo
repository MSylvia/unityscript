namespace UnityScript.Parser

import System.IO
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

partial class UnityScriptParser:
	
	static def ParseReader(reader as TextReader, fileName as string, context as CompilerContext, targetCompileUnit as CompileUnit):
		lexer = UnityScriptLexerFor(reader, fileName)
		if lexer is null:
			return
			
		parser = UnityScriptParser(lexer, CompilerContext: context)
		parser.setFilename(fileName)
		
		try:
			parser.start(targetCompileUnit)
		except x as antlr.TokenStreamRecognitionException:
			parser.reportError(x.recog)
			
	static def ParseExpression(expression as string, fileName as string, context as CompilerContext):
		return ParseExpression(StringReader(expression), fileName, context)
			
	static def ParseExpression(expression as TextReader, fileName as string, context as CompilerContext):
	"""
	if the expression reader is empty returns null.
	
	Otherwise tries to parse an expression reporting errors in the compiler context passed as argument.
	"""
		lexer = UnityScriptLexerFor(expression, fileName)
		if lexer is null:
			return null
			
		parser = UnityScriptParser(lexer, CompilerContext: context)
		parser.setFilename(fileName)
		
		try:
			return parser.expression()
		except x as antlr.TokenStreamRecognitionException:
			parser.reportError(x.recog)
			
	static def UnityScriptLexerFor(reader as TextReader, fileName as string):
		if reader.Peek() == -1:
			return null
			
		lexer = UnityScriptLexer(reader)
		lexer.setFilename(fileName)
		lexer.setTokenCreator(Boo.Lang.Parser.BooToken.BooTokenCreator())
		return lexer
		
		