%{

#include <stdlib.h>
#include <stdio.h>

enum keywords
{
    INT = 100,
    LONG,
    LONG_LONG,
    SHORT,
    SIGNED,
    UNSIGNED,
    FOR,
    BREAK,
    CONTINUE,
    RETURN,
    CHAR,
    IF,
    ELSE
};

enum operators
{
    DECREMENT = 200,
    INCREMENT,
    PTR_SELECT,
    LOGICAL_AND,
    LOGICAL_OR,
    LS_THAN_EQ,
    GR_THAN_EQ,
    EQ,
    NOT_EQ,
    ASSIGN,
    MINUS,
    PLUS,
    STAR,
    MODULO,
    LS_THAN,
    GR_THAN
};

enum special_symbols
{
    DELIMITER = 300,
    OPEN_BRACES,
    CLOSE_BRACES,
    COMMA,
    OPEN_PAR,
    CLOSE_PAR,
    OPEN_SQ_BRKT,
    CLOSE_SQ_BRKT,
    FW_SLASH
};

enum constants
{
    HEX_CONSTANT = 400,
    DEC_CONSTANT,
    HEADER_FILE,
    STRING
};

enum IDENTIFIER
{
    IDENTIFIER = 500
};

int cmnt_strt = 0;

%}

letter [a-zA-Z]
digit [0-9]
ws  [ \t\r\f\v]+
identifier (_|{letter})({letter}|{digit}|_){0,31}

hex [0-9a-f]
 /* Exclusive states */
%x CMNT
%x PREPROC
num {digit}+(\.{digit}+)?(E[+-]?{digit}+)?

%%
  /* Keywords*/
"int"                             {printf("\t%-30s : %3d                : keyword\n",yytext,INT);}
"long"                            {printf("\t%-30s : %3d                : keyword\n",yytext,LONG);}
"long long"                       {printf("\t%-30s : %3d                : keyword\n",yytext,LONG_LONG);}
"short"                           {printf("\t%-30s : %3d                : keyword\n",yytext,SHORT);}
"signed"                          {printf("\t%-30s : %3d                : keyword\n",yytext,SIGNED);}
"unsigned"                        {printf("\t%-30s : %3d                : keyword\n",yytext,UNSIGNED);}
"for"                             {printf("\t%-30s : %3d                : keyword\n",yytext,FOR);}
"break"                           {printf("\t%-30s : %3d                : keyword\n",yytext,BREAK);}
"continue"                        {printf("\t%-30s : %3d                : keyword\n",yytext,CONTINUE);}
"if"                              {printf("\t%-30s : %3d                : keyword\n",yytext,IF);}
"else"                            {printf("\t%-30s : %3d                : keyword\n",yytext,ELSE);}
"return"                          {printf("\t%-30s : %3d                : keyword\n",yytext,RETURN);}


{identifier}                      {printf("\t%-30s : %3d                : identifier\n", yytext,IDENTIFIER);}
{ws}                              ;
[+\-]?[0][x|X]{hex}+[lLuU]?        {printf("\t%-30s : %3d                : hex\n", yytext,HEX_CONSTANT);}
[+\-]?{digit}+[lLuU]?              {printf("\t%-30s : %3d                : decimal\n", yytext,DEC_CONSTANT);}
"/*"                              {cmnt_strt = yylineno; BEGIN CMNT;}
<CMNT>.|{ws}                      ;
<CMNT>\n                          {yylineno++;}
<CMNT>"*/"                        {BEGIN INITIAL;}
<CMNT>"/*"                        {printf("Line %3d: Nested comments are not valid!\n",yylineno);}
<CMNT><<EOF>>                     {printf("Line %3d: Unterminated comment\n", cmnt_strt); yyterminate();}
^"#include"                       {BEGIN PREPROC;}
<PREPROC>"<"[^<>\n]+">"            {printf("\t%-30s : %3d                : header file\n",yytext,HEADER_FILE);}
<PREPROC>{ws}                       ;
<PREPROC>\"[^"\n]+\"              {printf("\t%-30s : %3d                : header file\n",yytext,HEADER_FILE);}
<PREPROC>\n                       {yylineno++; BEGIN INITIAL;}
<PREPROC>.                        {printf("Line %3d: Illegal header file format \n",yylineno);}
"//".*                            {printf("\t%-30s : %3d                : comment\n", yytext, 599);};
\"[^\"\n]*\"     {
  if(yytext[yyleng-2]=='\\') /* check if it was an escaped quote */
  {
    yyless(yyleng-1);       /* push the quote back if it was escaped */
    yymore();
  }
 }
\"[^\"\n]*$                     {printf("Line %3d: Unterminated string %s\n",yylineno,yytext);}
{digit}+({letter}|_)+	        {printf("Line %3d: Illegal identifier name %s\n",yylineno,yytext);}
\n                              {yylineno++;}
"--"			                {printf("\t%-30s : %3d                : decrement\n",yytext,DECREMENT);}
"++"			                {printf("\t%-30s : %3d                : increment\n",yytext,INCREMENT);}
"->"			                {printf("\t%-30s : %3d                : pointer\n",yytext,PTR_SELECT);}
"&&"			                {printf("\t%-30s : %3d                : and\n",yytext,LOGICAL_AND);}
"||"			                {printf("\t%-30s : %3d                : or\n",yytext,LOGICAL_OR);}
"<="			                {printf("\t%-30s : %3d                : less or equal\n",yytext,LS_THAN_EQ);}
">="			                {printf("\t%-30s : %3d                : greater or equal\n",yytext,GR_THAN_EQ);}
"=="			                {printf("\t%-30s : %3d                : equal\n",yytext,EQ);}
"!="		                    {printf("\t%-30s : %3d                : not equal\n",yytext,NOT_EQ);}
";"			                    {printf("\t%-30s : %3d                : delimiter\n",yytext,DELIMITER);}
"{"                             {printf("\t%-30s : %3d                : open braces\n",yytext,OPEN_BRACES);}
"}"                             {printf("\t%-30s : %3d                : close braces\n",yytext,CLOSE_BRACES);}
","			                    {printf("\t%-30s : %3d                : comma\n",yytext,COMMA);}
"="			                    {printf("\t%-30s : %3d                : assignment\n",yytext,ASSIGN);}
"("			                    {printf("\t%-30s : %3d                : open paranthesis\n",yytext,OPEN_PAR);}
")"			                    {printf("\t%-30s : %3d                : close paranthesis\n",yytext,CLOSE_PAR);}
"["                             {printf("\t%-30s : %3d                : open squre\n",yytext,OPEN_SQ_BRKT);}
"]"                             {printf("\t%-30s : %3d                : close squre\n",yytext,CLOSE_SQ_BRKT);}
"-"			                    {printf("\t%-30s : %3d                : minus\n",yytext,MINUS);}
"+"			                    {printf("\t%-30s : %3d                : plus\n",yytext,PLUS);}
"*"			                    {printf("\t%-30s : %3d                : multiply\n",yytext,STAR);}
"/"		                        {printf("\t%-30s : %3d                : fw slash\n",yytext,FW_SLASH);}
"%"			                    {printf("\t%-30s : %3d                : modulo\n",yytext,MODULO);}
"<"			                    {printf("\t%-30s : %3d                : less than\n",yytext,LS_THAN);}
">"			                    {printf("\t%-30s : %3d                : greater than\n",yytext,GR_THAN);}
.                               {printf("Line %3d: Illegal character %s\n",yylineno,yytext);}

%%
int yywrap(){
    return 1;
}


int main() {
    int token;
    yyin=fopen("input.c","r");
    while(token=yylex()){
    }
    return 0; 
}