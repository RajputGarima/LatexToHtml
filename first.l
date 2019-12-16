%{
#include "y.tab.h"
#include<stdio.h>
#include<string.h>
int intag = 0;
int optiontag = 0;
%}

whitespace [ \t]+

word [a-zA-Z0-9=. \t@ () : , ' ! ? " ' ;]+


%%
"\\documentclass" 	{intag = 1 ; printf("%s", yytext);; return(DOCUMENTCLASS);}
"\\begin{document}"	{printf("%s", yytext);; return (BEGINDOC);}
"\\begin{figure}"	{optiontag =1; printf("%s", yytext);; return (BEGINFIG);}
"\\end{figure}"		{printf("%s", yytext);; return (ENDFIG);}
"\\caption"		{intag =1; optiontag =1; printf("%s",yytext);; return (FIGCAPTION);}
"\\usepackage"		{intag =1 ; printf("%s", yytext);; return (USEPKG);}
"\\label"		{printf("%s", yytext);; return (LABEL);}
"\\ref"			{printf("%s", yytext);; return(REF);}
"\\end{document}"	{printf("%s", yytext);; return(ENDDOC);}
"\\section"		{optiontag =1 ; printf("%s", yytext);; return (SECTION);}
"\\subsection"          {optiontag =1 ; printf("%s", yytext);; return(SUBSECTION);}
"\\textbf"		{printf("%s", yytext);; return(BOLD); }
"\\textit"		{printf("%s", yytext);; return(ITALIC); }
"\\underline"		{printf("%s", yytext);; return(UNDERLINE); }
"\\par"			{printf("%s", yytext);; return(PARA);}
"\\begin{enumerate}"	{printf("%s", yytext);; return(BEGINENUM);}
"\\item"		{printf("%s", yytext);; return(ITEM);}
"\\frac"		{printf("%s", yytext);; return(FRACTION);}
"\\sqrt"		{printf("%s", yytext);; return(SQRT);}
"\\sum"			{printf("%s", yytext);; return(SUMMATION);}
"\\int"			{printf("%s", yytext);; return(INTEGRATION);}
"\\end{enumerate}"	{printf("%s", yytext);; return(ENDENUM);}
"\\begin{table}"	{optiontag =1; printf("%s", yytext);; return(BEGINTABLE);}
"\\end{table}"		{printf("%s", yytext);; return(ENDTABLE);}
"\\begin{tabular}"	{optiontag =1; intag=1;printf("%s", yytext);; return(BEGINTABULAR);}
"\\end{tabular}"	{printf("%s", yytext);; return(ENDTABULAR);}
"\\includegraphics"	{optiontag =1; printf("%s", yytext);; return(INCGRAPHICS);}
"\\title"		{printf("%s", yytext);; return(TITLE);}
"\\hline"		{printf("%s", yytext);; }
"acmart"		{printf("%s", yytext);; return(ACMART);}
"article"		{if(intag) {printf("%s", yytext);; return(ARTICLE);} }
"letter"		{if(intag) {printf("%s", yytext);; return(LETTER);} }
"proc"			{if(intag) {printf("%s", yytext);; return(PROC); }}
"graphicx"		{if(intag) {printf("%s", yytext);; return(GRAPHICX);} }
"balance"		{if(intag) {printf("%s", yytext);; return(BALANCE); }}
"url"			{if(intag) {printf("%s", yytext);; return(URL);} }
"amsmath"		{if(intag) {printf("%s", yytext);; return(AMSMATH);} }
"mathtools"		{if(intag) {printf("%s", yytext);; return(MATHTOOLS);} }
"tabularx"		{if(intag) {printf("%s", yytext);; return(TABULARX);} }
"caption"		{if(intag) {printf("%s", yytext);; return(CAPTION);} }
"subcaption"		{if(intag) {printf("%s", yytext);; return(SUBCAPTION);} }
"multirow"		{if(intag) {printf("%s", yytext);; return(MULTIROW);} }
"graphics"		{if(intag) {printf("%s", yytext);; return(GRAPHICS);} }
"enumerate"		{if(intag) {printf("%s", yytext);; return(ENUMERATE);}}
"{"			{optiontag =0; printf("%s", yytext);; return(LBRACE);}
"}"			{intag = 0 ; optiontag =0; printf("%s", yytext);; return(RBRACE);}
"$"			{printf("%s", yytext);;  return(DOLLAR);}
"\\alpha"		{printf("%s", yytext);; yylval.arr=strdup("&alpha;"); return(GREEK);}
"\\beta"		{printf("%s", yytext);; yylval.arr=strdup("&beta;"); return(GREEK);}
"\\gamma"		{printf("%s", yytext);; yylval.arr=strdup("&gamma;"); return(GREEK);}
"\\Gamma"		{printf("%s", yytext);; yylval.arr=strdup("&Gamma;"); return(GREEK);}
"\\delta"		{printf("%s", yytext);; yylval.arr=strdup("&delta;"); return(GREEK);}
"\\Delta"		{printf("%s", yytext);; yylval.arr=strdup("&Delta;"); return(GREEK);}
"\\pi"			{printf("%s", yytext);; yylval.arr=strdup("&pi;"); return(GREEK);}
"\\Pi"			{printf("%s", yytext);; yylval.arr=strdup("&Pi;"); return(GREEK);}
"\\$"			{printf("%s", yytext);; yylval.arr=strdup("$ "); return(WORD);}
"\\#"			{printf("%s", yytext);; yylval.arr=strdup("# "); return(WORD);}
"\\&"			{printf("%s", yytext);; yylval.arr=strdup("& "); return(WORD);}
"\\_"			{printf("%s", yytext);; yylval.arr=strdup("_ "); return(WORD);}
"\\{"			{printf("%s", yytext);; yylval.arr=strdup("{ "); return(WORD);}
"\\}"			{printf("%s", yytext);; yylval.arr=strdup("} "); return(WORD);}
"\\%"			{printf("%s", yytext);; yylval.arr=strdup("% "); return(WORD);}
"*"			{printf("%s", yytext);; yylval.arr=strdup("* "); return(WORD);}
"/"			{printf("%s", yytext);; yylval.arr=strdup("/ "); return(WORD);}
"+"			{printf("%s", yytext);; yylval.arr=strdup("+ "); return(WORD);}
"-"			{printf("%s", yytext);; yylval.arr=strdup("- "); return(WORD);}
"`"			{printf("%s", yytext);; yylval.arr= strdup("'"); return(WORD);}
"["			{if(intag || optiontag) {printf("%s", yytext);;printf("LSQR"); return(LSQR);} else{ printf("%s",yytext);;printf("WORD"); yylval.arr = strdup("[ "); return(WORD);}}
"]"			{if(intag || optiontag){printf("%s", yytext);; optiontag =0; return(RSQR); } else{ printf("%s",yytext);; yylval.arr = strdup("] "); return(WORD);}}
"\\\\"			{printf("%s", yytext);; return(DOUBLEBS);}
"|"			{printf("%s",yytext);; return(VBAR);}
"^"			{printf("%s", yytext);; return(POWER);}
"_"			{printf("%s", yytext);; return(UNDERSCORE);}
"&"			{printf("%s", yytext);; return(AMPERSAND);}
"l"			{if(intag){printf("%s", yytext);; return(LEFT);}}
"c"			{if(intag){printf("%s", yytext);; return(CENTER);}}
"r"			{if(intag){printf("%s", yytext);; return(RIGHT);}}
"~"			{printf("%s", yytext);; yylval.arr=strdup(" &nbsp; "); return(WORD); }
{whitespace}		{printf("%s", yytext);; }
{word}			{printf("%s", yytext);; yylval.arr= strdup(yytext); return(WORD);}

%%

