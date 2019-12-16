# LatexToHtml

This project was a part of the course, Software Systems Laboratory, at IIT-Delhi. <br />
Abstract: Given a LaTeX document, convert it to its equivalent HTML page. <br />

## Tech Stack <br />
Tools: Flex, Bison <br />
Programming Language: C <br />

### Flex(Fast Lexical Analyzer) - first.l <br/>
A tool to generate scanners. Flex was used to identify patterns in LaTeX file using regular expressions and generate tokens out of them.  <br />

### Bison - first.y <br />
A tool to generate parsers which use LALR(1) parsing tables. This file is a collection of production rules, collectively called grammar, that can parse a valid LaTeX file.
It uses tokens outputted by the scanner to match with suitable rule and construct parse tree. <br />

### Project flow: <br />
* sequence of characters read from LaTeX document(identified and tokenised by Flex)
* generated token matched with 1 production from the grammar
* after completing one production rule, a semantic action is taken to construct one node of AST(Abstract Syntax Tree) based on this rule 
* repeat till document is completely read
* generate the HTML code by doing DFS traversal on AST <br />


Each node of the AST is built in such a manner that it carries enough information to perform code generation step at the end. Structure of the node and different functions are defined in **ast.h** file and these functions are being called in the .y file as semantic actions to be taken at the end of each production rule. <br />

### Commands to run: <br />

> flex first.l <br />

> yacc -d -t first.y <br />

> gcc -o latextohtml y.tab.c lex.yy.c -lfl <br />

Then run: <br />
> ./latextohtml outputHTML.html < inputLaTex.tex 
