%{
#include<stdio.h>
void yyerror(char *);
int yylex();
int m1 = 0;
int m2 = 1;
%}

%token ONE
%token ZERO

%union {
    float f;
    int n;
}
%type <f>E
%type <n>A
%type <f>B
%type <n>ONE
%type <n>ZERO

%%
S: E {printf("ans: %f\n", $1);};
E: A {$$=$1;} 
 | A'.'B {
          $$=$1+$3;
          printf("decimal part: %d\n", $1); 
          printf("fractional part: %f\n", $3);
         };

A: {$$ = 0;} 
  | ONE  A { $$ =  (1 << m1 ) | $2; m1++; };
  | ZERO A { $$ = $2; m1++;};
; 
B: {$$ = 0;}
  | B ONE  { $$ = $1 +  1.0/(1 << m2);  m2++;}
  | B ZERO { $$=$1 ; m2++;}
;
%%

void yyerror(char *s){
    printf("ERROR %s .\n", s);
}

int main(){
    return yyparse();
}
