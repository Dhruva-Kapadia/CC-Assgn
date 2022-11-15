%{
  #include<stdio.h>
  #include "y.tab.h"
%}

num     [0-9]+\.?|[0-9]*\.[0-9]+

%%

{num}	  { yylval.num=atof(yytext);return NUM; }

"+"     return ADD;
"-"     return SUB;
"*"     return MUL;
"/"     return DIV;
"<<"    return LEFTSHIFT;
">>"    return RIGHTSHIFT;

"%"     return MOD;
"^"     return POW;
"("     return OBR;
")"     return CBR;

pi      return PIVAL;

sin     return SIN;
cos     return COS;
tan     return TAN;
log     return LOG;
factorial return FACTORIAL;
sqrt    return SQRT;

and     return AND;
xor     return XOR;
or      return OR;

[\t]    ;
[\n]    return 0;
.       return yytext[0];

%%

int yywrap()
{
 return 1;
}