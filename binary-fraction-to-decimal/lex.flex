%{
#include<stdlib.h>
#include "parse.tab.h"
%}

%%
"." { return yytext[0]; }
"0" { yylval.n=0; return ZERO; }
"1" { yylval.n=1; return ONE; }
\n  { return 0; }
.   {;}
%%

int yywrap(){
    return 1;
}