%{
#include "parse.tab.h"
#include <string.h>
%}

%%
[a-z]+ {strcpy(yylval.s,yytext); return ID;}
"*"|"/"|"+"|"-"|"^"|"("|")" {return yytext[0];}
"\n" {return 0;}
. {}
%%
int yywrap(){
    return 1;
}
