%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h>

  float factorial(int n)
{
  int c;
  float result = 1;
 
  for (c = 1; c <= n; c++)
    result = result * c;
 
  return result;
}

%}


%union
{
  double num;
}
%token <num>NUM PIVAL

%left ADD SUB 

%left MUL DIV MOD POW OBR CBR

%token SIN COS TAN LOG FACTORIAL OR XOR AND LEFTSHIFT RIGHTSHIFT SQRT

%type <num>input expr addexpr subexpr mulexpr divexpr modexpr powexpr trigexpr numexpr and logicaland or1 shift
%%

input     : expr {printf("%g\n", $1);}
          ;

expr      : logicaland
          ;
logicaland: or1
        | logicaland OR or1 { $$ = (int) $1 || (int) $3; }
        ;
or1     : and
        | or1 XOR and { $$ = (int) $1 ^ (int) $3; }
        ;
and       : shift
          | and AND shift { $$ = (int) $1 & (int) $3; }
          ;
shift:   addexpr
        | shift LEFTSHIFT addexpr { $$ = (int) $1 << (int) $3; }
        | shift RIGHTSHIFT addexpr { $$ = (int) $1 >>(int) $3; }
        ;
addexpr   : subexpr
          | addexpr ADD subexpr   {$$ = $1+$3;}
          ;

subexpr   : mulexpr
          | subexpr SUB mulexpr   {$$ = $1-$3;}
          ;

mulexpr   : divexpr
          | mulexpr MUL divexpr   {$$ = $1*$3;}
          ;

divexpr   : modexpr
          | divexpr DIV modexpr   {
                                    if($3==0){
                                      printf("\nError!!! Division by zero\n");
                                    }else{
                                      $$ = $1/$3;
                                    }
                                  }
          ;

modexpr   : powexpr
          | modexpr MOD powexpr   {$$ = fmod($1,$3);}
          ;

powexpr   : trigexpr
          | powexpr POW trigexpr   {$$ = pow($1,$3);}
          ;

trigexpr  : numexpr
          | SIN OBR numexpr CBR     {$$ = sin($3);}
          | COS OBR numexpr CBR     {$$ = cos($3);}
          | TAN OBR numexpr CBR     {$$ = tan($3);}
          | LOG OBR numexpr CBR     {$$ = log($3);}
          | FACTORIAL OBR numexpr CBR     {$$ = factorial((int)$3);}
          | SQRT OBR expr CBR { $$ = sqrt($3) ; }
          ;

numexpr   : OBR expr CBR          {$$ = $2;}
          | PIVAL { $$ = M_PI; }
          | NUM
          ;
%%

void main()
{
  do{
    printf("\n:> ");
    yyparse();

  }while(1);
}

void yyerror()
{
  printf("\nEntered arithmetic expression is Invalid\n\n");
}