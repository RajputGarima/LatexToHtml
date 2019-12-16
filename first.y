%{
#include<stdio.h>
#include<string.h>
#include "ast.h"

FILE *html;
int ingraphics=0, ingraphicx=0, intabularx=0, incaption=0, insubcaption=0, inmultirow=0, inurl=0, inmathtools=0, inamsmath=0, inbalance=0, inenumerate=0, inleft=0; 
int tablecolumn=0;
char table_align[100];
int fig_count=0, tab_count=0, section_count=0, sub_count=0, i=0,j;
char* ch=NULL, *ch1=NULL;
int value = 0;
char *ans;
char *str;
int countf;

struct newnode{
struct treenode **node;
struct newnode *next;
}*front=NULL;

int yylex();
void yyerror(char* s);


struct treenode** push(struct newnode **front, int num){
	struct newnode *tnode = NULL;
	
	if( ( tnode = (struct newnode*)malloc( sizeof(struct newnode) ) ) == NULL ) {
		return NULL;
	}
	struct treenode **tn;
	
		if( ( tn = (struct treenode**)malloc( num * sizeof(struct treenode*) ) ) == NULL ) {
			return NULL;
		}
	tnode->node= tn;
	tnode->next=*front;
	*front=tnode;
	return (*front)->node;
}

struct fig_array{
	char* name;
	int counter; 
}arr[500];

%}

%union{

char* arr;
struct treenode * asnode;

}
%type <asnode> statement doctype pretype maiin doclabel package imagetag cap fig_label incgraphics graphic_option
%type <asnode> sectiontype subsection left leftbracepower leftbrace maths lcr 
%type <asnode> tabular table_label caption_option table item content textword
%start statement 

 
%token  DOCUMENTCLASS
%token  BEGINDOC 
%token  ENDDOC ACMART
%token TITLE SECTION LBRACE RBRACE ARTICLE LETTER PROC SUBSECTION DOUBLEBS PARA LSQR 
%token USEPKG GRAPHICS GRAPHICX TABULARX CAPTION SUBCAPTION MULTIROW URL MATHTOOLS AMSMATH BALANCE INCGRAPHICS RSQR
%token BEGINFIG ENDFIG FIGCAPTION LABEL BOLD ITALIC UNDERLINE BEGINENUM ITEM ENDENUM ENUMERATE BEGINTABLE ENDTABLE REF
%token BEGINTABULAR ENDTABULAR AMPERSAND LEFT RIGHT CENTER VBAR DOLLAR SUMMATION FRACTION INTEGRATION SQRT UNDERSCORE POWER 
%token <arr> WORD GREEK

%%

statement: 	doctype pretype BEGINDOC content maiin ENDDOC
		
		{$$ = addnode('N',"statement",NULL,-1,returnChild( push(&front,7),6, $1,$2, addnode('T',"BEGINDOC","<body>\n",-1,NULL), $4, $5,  addnode('T',"ENDDOC","</html>\n",-1,NULL) ) );
		printf("level order traverse ------ \n"); dfs($$, html);} 

		;


doctype: 	DOCUMENTCLASS graphic_option LBRACE doclabel RBRACE

		{ $$ = addnode('N',"doctype","<html> <head>\n",-1, returnChild( push(&front,6), 5, addnode('T',"DOCUMENTCLASS",NULL,-1,NULL),$2,addnode('T',"LBRACE",NULL,-1,NULL),
		$4,addnode('T',"RBRACE",NULL,-1,NULL) ) );}

		;


doclabel: 	ARTICLE {$$ = addnode('N',"doclabel",NULL, -1,  returnChild( push(&front, 2),1, addnode('T',"Article",NULL,-1,NULL)  ) ); }
		
		| PROC  {$$ = addnode('N',"doclabel",NULL, -1, returnChild( push(&front, 2),1, addnode('T',"Proc",NULL,-1,NULL)  ) ); }

		| LETTER {$$ = addnode('N',"doclabel",NULL,-1, returnChild( push(&front, 2),1, addnode('T',"Letter",NULL,-1,NULL)  ) ); }

		| ACMART {$$ = addnode('N',"doclabel",NULL,-1, returnChild( push(&front, 2),1, addnode('T',"Acmart",NULL,-1,NULL)  ) );}

		;



pretype: 	USEPKG LBRACE package RBRACE pretype 

		{ $$= addnode( 'N', "pretype",  NULL, -1, returnChild( push(&front, 6), 5, addnode('T',"USEPKG",NULL,-1,NULL), addnode('T',"LBRACE",NULL,-1,NULL), $3, addnode('T',"RBRACE",NULL,-1,NULL),
		$5 ) );}
		
		|TITLE LBRACE textword RBRACE pretype
		
		{$$= addnode('N', "titletype", NULL, -1, returnChild( push(&front, 6),5, addnode('T', "TITLE", "<title>" ,-1,NULL), addnode('T', "LBRACE", NULL ,-1,NULL), $3,
		addnode('T',"RBRACE","</title></head>\n",-1, NULL),$5 ) );}

		| {$$ = addnode('N',"pretype",NULL, -1, returnChild( push(&front, 2),1, addnode('T', "EMPTY", NULL,-1, NULL) ) );}	
	
		;

package: 	GRAPHICS{ingraphics=1;} 

		{$$= addnode('N', "package", NULL, -1, returnChild( push(&front, 2),1, addnode('T', "GRAPHICS", NULL, -1, NULL) ) );}

		|GRAPHICX{ingraphicx=1;} 

		{$$= addnode('N', "package", NULL, -1,returnChild( push(&front, 2),1, addnode('T', "GRAPHICX", NULL,-1, NULL) ) );}

		| TABULARX{intabularx=1;}

		{$$= addnode('N', "package", NULL, -1, returnChild( push(&front, 2),1, addnode('T', "TABULARX", NULL, -1, NULL) ) );}

		| CAPTION{incaption=1;} 

		{$$= addnode('N', "package", NULL, -1, returnChild( push(&front, 2),1, addnode('T', "CAPTION", NULL, -1, NULL) ) );}

		| SUBCAPTION{insubcaption=1;}

		{$$= addnode('N', "package", NULL,-1, returnChild( push(&front, 2),1, addnode('T', "SUBCAPTION", NULL, -1, NULL) ) );}

		| MULTIROW{inmultirow=1;} 

		{$$= addnode('N', "package", NULL, -1, returnChild( push(&front, 2),1, addnode('T', "MULTIROW", NULL, -1,NULL) ) );}

		| URL{inurl=1;} 

		{$$= addnode('N', "package", NULL, -1, returnChild( push(&front, 2),1, addnode('T', "URL", NULL,-1, NULL) ) );}

		| MATHTOOLS{inmathtools=1;} 

		{$$= addnode('N', "package", NULL,-1, returnChild( push(&front, 2),1, addnode('T', "MATHTOOLS", NULL,-1, NULL) ) );}

		| AMSMATH{inamsmath=1;} 

		{$$= addnode('N', "package", NULL,-1, returnChild( push(&front, 2),1, addnode('T', "AMSMATH", NULL,-1, NULL) ) );}

		| BALANCE{inbalance=1;}

		{$$= addnode('N', "package", NULL, -1,returnChild( push(&front, 2),1, addnode('T', "BALANCE", NULL, -1,NULL) ) );}
		
		| ENUMERATE{inenumerate=1;}	
		
		{$$= addnode('N', "package", NULL, -1,returnChild( push(&front, 2),1, addnode('T', "ENUMERATE", NULL, -1,NULL) ) );}
		
		;


imagetag: 	INCGRAPHICS incgraphics imagetag

		{$$= addnode( 'N', "imagetag", NULL, -1, returnChild( push(&front, 4),3, addnode('T',"INCGRAPHICS",NULL,-1, NULL), $2, $3 ) );}

		| FIGCAPTION graphic_option cap imagetag 

		{$$= addnode( 'N', "imagetag", NULL, -1,returnChild( push(&front, 5),4, addnode('T',"FIGCAPTION",NULL,-1,NULL), $2, $3,$4 ) );}

		| LABEL fig_label imagetag

		{$$= addnode( 'N', "imagetag", NULL, -1,returnChild( push(&front, 4),3, addnode('T',"LABEL",NULL,-1,NULL), $2, $3 ) );} 

		| 

		{$$ = addnode('N',"imagetag",NULL, -1, returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL, -1, NULL)));}

		;

cap: 		LBRACE textword RBRACE

		{$$= addnode( 'N', "cap", NULL,-1, returnChild( push(&front, 4),3, addnode('T',"LBRACE","<figcaption>",-1,NULL), $2, addnode('T',"RBRACE","</figcaption>",-1,NULL) ) );}

		;

fig_label: 	LBRACE WORD {arr[i].name=$2; arr[i].counter= fig_count; i++;} RBRACE

		{$$= addnode( 'N', "fig_label", NULL, -1,returnChild( push(&front, 4),3, addnode('T',"LBRACE",NULL,-1, NULL),addnode('T',"WORD",NULL,-1,NULL) , addnode('T',"RBRACE",NULL,-1, NULL) ) );}

		;

maiin:  	sectiontype maiin

		{$$= addnode( 'N', "maiin", NULL, -1,returnChild( push(&front, 3),2, $1, $2 ) );}

		|

		{$$= addnode( 'N', "maiin", "</body>\n", -1,returnChild( push(&front, 2),1, addnode('T', "empty", NULL, -1,NULL) ) );}
		;


incgraphics: 	 graphic_option LBRACE 	WORD  RBRACE

		{$$= addnode( 'N', "incgraphics", checkGraphics(ingraphicx, ingraphics), -1, returnChild( push(&front, 5),4, $1, addnode('T',"LBRACE","<img src ='",-1,NULL), 
		addnode('T',"WORD",$3, -1, NULL),  addnode('T',"RBRACE",".jpeg'>",-1,NULL) ) );} 

		| 

		{$$ = addnode('N',"incgraphics",NULL,-1,returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL,-1, NULL)));}

		; 


graphic_option: LSQR textword RSQR 

		{$$= addnode( 'N', "graphic_option", NULL, -1, returnChild( push(&front, 4),3, addnode('T',"LSQR",NULL,-1, NULL), addnode('T',"WORD",NULL,-1, NULL), addnode('T',"RSQR",NULL,-1, NULL) ));}

		|

		{$$ = addnode('N',"graphic_option",NULL, -1,returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL,-1, NULL)));} 

		; 

sectiontype: 	SECTION {section_count++; sub_count=0;} graphic_option LBRACE textword RBRACE content subsection
		
		{$$= addnode( 'N', "sectiontype", NULL, -1, returnChild( push(&front, 11),10, addnode('T',"SECTION","\n<section>\n",-1,NULL), $3,  addnode('T',"LBRACE","<h2>\n", -1,NULL), 
		addnode('T',"ADDED",NULL,  section_count, NULL),$5, addnode('T',"RBRACE","</h2> \n<div>\n",-1,NULL), $7,addnode('T',"ADDED","</div>\n",-1,NULL), $8 , 
		addnode('T',"ADDED","</section>\n",-1,NULL) ) );}

		;


subsection: 	SUBSECTION {sub_count++;} graphic_option LBRACE textword RBRACE content subsection 

		{$$= addnode('N', "subsection", NULL, -1,returnChild(push(&front, 12),11, addnode('T',"SUBSECTION",NULL,-1,NULL),$3, addnode('T',"LBRACE","<h3>\n",-1,NULL), 
		addnode('T',"ADDED",NULL,  section_count, NULL), addnode('T',"ADDED",".",-1, NULL), addnode('T',"ADDED",NULL,  sub_count--, NULL),$5,addnode('T',"RBRACE","</h3>\n<div>\n",-1,NULL), $7, 
		addnode('T',"ADDED","</div>\n",-1,NULL), $8) );}

		| 

		{$$ = addnode('N',"subsection",NULL,-1,returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL,-1,NULL)));}

		;


textword :  	WORD content 
		
		{$$ = addnode('N',"textword",NULL,-1,returnChild(push(&front,3),2,addnode('T',"WORD",$1,-1,NULL),$2));} 

		| DOUBLEBS content

		{$$ = addnode('N',"textword",NULL,-1,returnChild(push(&front,3),2,addnode('T',"DOUBLEBS","<p>&nbsp; &nbsp;&nbsp;",-1,NULL),$2));} 

		| PARA content

		{$$ = addnode('N',"textword",NULL,-1,returnChild(push(&front,3),2,addnode('T',"PARA", "<br>&nbsp; &nbsp;&nbsp;",-1,NULL),$2));}

		| BOLD LBRACE textword RBRACE content

 		{$$ = addnode('N',"textword",NULL,-1,returnChild(push(&front,6),5,addnode('T',"BOLD", NULL,-1, NULL),addnode('T',"LBRACE","<b>",-1,NULL),$3, addnode('T',"RBRACE","</b>",-1,NULL),$5));}

		| ITALIC LBRACE textword RBRACE content

 		{$$ = addnode('N',"textword",NULL,-1,returnChild(push(&front,6),5,addnode('T',"ITALIC", NULL,-1,NULL),addnode('T',"LBRACE","<i>",-1,NULL),$3, addnode('T',"RBRACE","</i>",-1,NULL),$5));}

		| UNDERLINE LBRACE textword RBRACE content 

		{$$ = addnode('N',"textword",NULL,-1,returnChild(push(&front,6),5,addnode('T',"UNDERLINE", NULL,-1,NULL),addnode('T',"LBRACE","<u>",-1,NULL),$3, addnode('T',"RBRACE","</u>",-1,NULL),$5));}

		| REF LBRACE WORD{ch=$3; j=0; int flag=1; while(1){ ch1= arr[j].name; if(strcmp(ch1,ch) == 0){ flag =0; ans = NULL;value= arr[j].counter; break;} if(j>100) break; j++; } 
		if(flag) {ans="??" ; value =-1;} } RBRACE content
		
		{$$ = addnode('N',"textword",NULL,-1,returnChild(push(&front,6),5,addnode('T',"REF", NULL,-1,NULL),addnode('T',"LBRACE",NULL,-1,NULL),addnode('T',"WORD",ans,value,NULL), 
		addnode('T',"RBRACE",NULL,-1,NULL), $6));}

		| 

		{$$ = addnode('N',"textword",NULL,-1,returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL,-1,NULL) ));} 

		;


content:	INCGRAPHICS{fig_count++; countf = fig_count; }  incgraphics content
		
		{$$ = addnode('N',"content",NULL,-1,returnChild(push(&front,7),6,addnode('T',"INCGRAPHICS",NULL,-1,NULL),addnode('T', "ADDED", "<figcaption>", -1,NULL), 
		addnode('T', "ADDED", "Figure: ", countf --,NULL), addnode('T', "ADDED", "</figcaption>", -1,NULL),$3, $4));} 
		
		| BEGINFIG{fig_count++; countf = fig_count;} graphic_option imagetag ENDFIG content

		{$$ = addnode('N',"content",NULL,-1,returnChild(push(&front,9),8,addnode('T',"BEGINFIG","<figure>\n",-1,NULL),$3,addnode('T', "ADDED", "<figcaption>", -1,NULL),
		 addnode('T', "ADDED", "Figure: ", countf--,NULL), addnode('T', "ADDED", "</figcaption>", -1,NULL),$4,addnode('T',"ENDFIG","</figure>\n",-1,NULL),$6));} 

		| textword

		{$$ = addnode('N',"content",NULL,-1,returnChild(push(&front,2),1,$1));} 

		| BEGINENUM graphic_option item ENDENUM content

		{$$ = addnode('N',"content",NULL,-1,returnChild(push(&front,6),5,addnode('T',"BEGINENUM","<ol type='1'>\n",-1,NULL),$2,$3,addnode('T',"ENDENUM","</ol>\n",-1,NULL),$5));}

		| BEGINTABLE {tab_count++; } graphic_option table ENDTABLE content

		{$$ = addnode('N',"content",NULL,-1,returnChild(push(&front,7),6,addnode('T',"BEGINTABLE","\n<table>",-1,NULL),addnode('T',"ADDED","Table: ",tab_count,NULL),$3,$4, 
		addnode('T',"ENDTABLE","</table>\n",-1,NULL),$6));}

		| DOLLAR maths DOLLAR content

		{$$ = addnode('N',"content",NULL,-1,returnChild(push(&front,5),4,addnode('T',"DOLLAR",NULL,-1,NULL), $2,addnode('T',"DOLLAR",NULL,-1,NULL),$4));}

		|LABEL LBRACE WORD {arr[i].name=$3; arr[i].counter= section_count; i++;} RBRACE content  

		{$$= addnode( 'N', "content", NULL, -1, returnChild(  push(&front, 6),5, addnode('T', "LABEL", NULL, -1,NULL),addnode('T', "LBRACE", NULL, -1,NULL),
		addnode('T', "WORD", NULL, -1,NULL), addnode('T', "RBRACE", NULL, -1,NULL), $6  )  ); }

		;



item : 		ITEM textword item

		{$$ = addnode('N',"item",NULL,-1,returnChild(push(&front,5),4,addnode('T',"ITEM","<li>",-1,NULL),$2,addnode('T',"ADDED","</li>\n",-1,NULL),$3));}

		| 

		{$$ = addnode('N',"item",NULL,-1,returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL,-1,NULL)));} 

		;


table:		FIGCAPTION caption_option table

		{$$ = addnode('N',"table",NULL,-1,returnChild(push(&front,4),3,addnode('T',"FIGCAPTION",NULL,-1,NULL),$2,$3));}

		| BEGINTABULAR graphic_option LBRACE lcr RBRACE tabular table

		{$$ = addnode('N',"table",NULL,-1,returnChild(push(&front,9),8,addnode('T',"BEGINTABLAR",NULL,-1,NULL),$2,addnode('T',"LBRACE",NULL,-1,NULL),$4,
		addnode('T',"RBRACE","\n<tr> \n <td>",-1,NULL),$6, addnode('T', "ADDED", "</td>\n</tr>\n",-1, NULL),$7));} 

		| LABEL table_label table 

		{$$ = addnode('N',"table",NULL,-1,returnChild(push(&front,4),3,addnode('T',"LABEL",NULL,-1,NULL),$2,$3));}

		|

		{$$ = addnode('N',"table",NULL,-1,returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL,-1,NULL)));} 

		;


caption_option:	LBRACE textword RBRACE
		
		{$$ = addnode('N',"caption_option",NULL,-1,returnChild(push(&front,4),3,addnode('T',"LBRACE","\n<caption>",-1,NULL),$2,addnode('T',"RBRACE","</caption>",-1,NULL)));}

		| LSQR WORD RSQR LBRACE textword RBRACE

		{$$ = addnode('N',"caption_option",NULL,-1,returnChild(push(&front,7),6,addnode('T',"LSQR",NULL,-1,NULL), addnode('T',"WORD",NULL,-1,NULL), addnode('T',"SQR",NULL,-1,NULL), 
		addnode('T',"LBRACE","\n<caption>",-1,NULL), $5,addnode('T',"RBRACE","</caption>",-1,NULL)));}		 

		;




table_label :   LBRACE  WORD {arr[i].name=$2; arr[i].counter= tab_count; i++;} RBRACE

		{$$ = addnode('N',"table_label",NULL,-1,returnChild(push(&front,4),3,addnode('T',"LBRACE",NULL,-1,NULL),addnode('T',"WORD",NULL,-1,NULL),addnode('T',"RBRACE",NULL,-1,NULL)));}

		;



tabular: 	WORD tabular

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,3),2,addnode('T',"WORD",$1,-1,NULL),$2));}	

		| BOLD LBRACE tabular RBRACE tabular 

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,6),5,addnode('T',"BOLD",NULL,-1,NULL),addnode('T',"LBRACE","<b>",-1,NULL),$3,addnode('T',"RBRACE","</b> ",-1,NULL),$5));}

		| PARA tabular

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,3),2,addnode('T',"PARA",NULL,-1,NULL),$2));}

		| ITALIC LBRACE tabular RBRACE tabular

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,6),5,addnode('T',"ITALIC",NULL,-1,NULL),addnode('T',"LBRACE","<i>",-1,NULL),$3,addnode('T',"RBRACE","</i> ",-1,NULL),$5));}

		| UNDERLINE LBRACE tabular RBRACE tabular

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,6),5,addnode('T',"UNDERLINE",NULL,-1,NULL),addnode('T',"LBRACE","<u>",-1,NULL),$3,addnode('T',"RBRACE","</u> ",-1,NULL),$5));}

		| INCGRAPHICS incgraphics tabular

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,4),3,addnode('T',"INCGRAPHICS",NULL,-1,NULL),$2,$3));}

		| AMPERSAND tabular

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,3),2,addnode('T',"AMPERSAND"," </td> \n <td>",-1,NULL),$2));}

		| DOUBLEBS tabular 

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,3),2,addnode('T',"DOUBLEBS","</td> \n </tr> \n <tr> \n <td>",-1,NULL),$2));}

		| ENDTABULAR

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,2),1,addnode('T',"ENDTABULAR",NULL,-1,NULL)));}

		| DOLLAR maths DOLLAR tabular

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,5),4,addnode('T',"DOLLAR",NULL,-1,NULL),$2,addnode('T',"DOLLAR",NULL,-1,NULL),$4));}

		|

		{$$ = addnode('N',"tabular",NULL,-1,returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL,-1,NULL)));} 

		;



lcr: 		LEFT lcr 
		
		{$$ = addnode('N',"lcr",NULL,-1,returnChild(push(&front,3),2,addnode('T',"LEFT",NULL,-1,NULL),$2));}

		| RIGHT lcr

		{$$ = addnode('N',"lcr",NULL,-1,returnChild(push(&front,3),2,addnode('T',"RIGHT",NULL,-1,NULL),$2));}

		| CENTER lcr

		{$$ = addnode('N',"lcr",NULL,-1,returnChild(push(&front,3),2,addnode('T',"CENTER",NULL,-1,NULL),$2));}

		| VBAR lcr

		{$$ = addnode('N',"lcr",NULL,-1,returnChild(push(&front,3),2,addnode('T',"VBAR",NULL,-1,NULL),$2));} 

		| 

		{$$ = addnode('N',"lcr",NULL,-1,returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL,-1,NULL)));}

		;



maths:		FRACTION LBRACE maths RBRACE LBRACE maths RBRACE maths
		
		{$$ = addnode('N',"maths",NULL,-1,returnChild(push(&front,9),8,addnode('T',"FRACTION",NULL,-1,NULL),addnode('T',"LBRACE","\n(", -1,NULL),$3, addnode('T',"RBRACE",") &frasl; (",-1,NULL), 
		addnode('T',"LBRACE",NULL,-1,NULL),$6,addnode('T',"RBRACE",")\n",-1,NULL),$8));}

		| SQRT left  maths

		{$$ = addnode('N',"maths",NULL,-1,returnChild(push(&front,4),3,addnode('T',"SQRT","&radic;",-1,NULL),$2,$3));}

		| SUMMATION maths

		{$$ = addnode('N',"maths",NULL,-1,returnChild(push(&front,3),2,addnode('T',"SUMMATION","&sum; ",-1,NULL),$2));}

		| INTEGRATION maths

		{$$ = addnode('N',"maths",NULL,-1,returnChild(push(&front,3),2,addnode('T',"INTEGRATION","&int; ",-1,NULL),$2));}

		| UNDERSCORE leftbrace maths

		{$$ = addnode('N',"maths",NULL,-1,returnChild(push(&front,4),3,addnode('T',"UNDERSCORE","<sub> ",-1,NULL),$2,$3));}

		| POWER leftbracepower  maths

		{$$ = addnode('N',"maths",NULL,-1,returnChild(push(&front,4),3,addnode('T',"power","<sup> ",-1,NULL),$2,$3));}

		| WORD maths

		{$$ = addnode('N',"maths",NULL,-1,returnChild(push(&front,3),2,addnode('T',"WORD",$1,-1,NULL),$2));}

		| GREEK maths

		{$$ = addnode('N',"maths",NULL,-1,returnChild(push(&front,3),2,addnode('T',"GREEK",$1,-1,NULL),$2));}

		|

		{$$ = addnode('N',"maths",NULL,-1,returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL,-1,NULL)));}

		;





leftbrace: 	LBRACE maths RBRACE

		{$$ = addnode('N',"leftbrace",NULL,-1,returnChild(push(&front,4),3,addnode('T',"LBRACE",NULL,-1,NULL),$2, addnode('T',"RBRACE","</sub>",-1,NULL)));}

		| WORD

		{$$ = addnode('N',"leftbracepower",NULL,-1,returnChild(push(&front,2),1,addnode('T',"WORD",strcat($1,"</sub>"),-1,NULL)));}

		;




leftbracepower:	LBRACE maths RBRACE

		{$$ = addnode('N',"leftbracepower",NULL,-1,returnChild(push(&front,4),3,addnode('T',"LBRACE",NULL,-1,NULL),$2, addnode('T',"RBRACE","</sup>",-1,NULL)));}

		| WORD

		{$$ = addnode('N',"leftbracepower",NULL,-1,returnChild(push(&front,2),1,addnode('T',"WORD",strcat($1,"</sup>"),-1,NULL)));}

		;



		
left:		LBRACE maths RBRACE 

		{$$ = addnode('N',"left",NULL,-1,returnChild(push(&front,4),3,addnode('T',"LBRACE","(",-1,NULL),$2, addnode('T',"RBRACE",")",-1,NULL)));}

		| {$$ = addnode('N',"left",NULL,-1,returnChild(push(&front,2),1,addnode('T',"EMPTY",NULL,-1,NULL)));}

		;





%%


int main(int argc, char* argv[]){
	char fname[100];
	strcpy(fname, argv[1]);
	html= fopen(fname, "w+");
	return yyparse();
}

void yyerror (char *msg) {
	fprintf(html, "%s\n",msg);
}
