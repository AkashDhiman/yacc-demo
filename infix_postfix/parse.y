%{
#include<stdio.h>
#include<string.h>
void yyerror(char *);
int yylex();
char buf[100];
%}
%token ID
%type <s> ID 
%type <s> E

%left'+''-'
%left'*''/'
%union{ 
    char s[100];
}

%%
S:  E {printf("Converted String is %s\n", $1 ); };
E:  E'*'E {
    buf[0]='*'; buf[1]='\0';
    strcat($1,$3);
    strcat($1,buf);
    strcpy($$,$1); 
     }
    
    | E'/'E{
     buf[0]='/'; buf[1]='\0';
    strcat($1,$3);
    strcat($1,buf);
    strcpy($$,$1);   
    }

    |E'+'E{
     buf[0]='+'; buf[1]='\0';
     strcat($1,$3);
    strcat($1,buf);
    strcpy($$,$1);   
    }

    | E'-'E{
     buf[0]='-'; buf[1]='\0';
    strcat($1,$3);
    strcat($1,buf);
    strcpy($$,$1);
    }

    |'('E')' { 
        strcpy($$,$2); 
     }
    |ID  { strcpy($$,$1); 
    }
    ;
%%
void yyerror(char *s){
    printf("ERROR %s .\n",s);
}    
int main(){
return yyparse();
}