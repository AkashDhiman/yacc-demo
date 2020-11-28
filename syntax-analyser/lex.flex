%option noyywrap
%option yylineno
%x COMMENT

%{
  #define LOOKUP 0

  #include "parse.tab.h"
  
  extern char* yytext;

  int state = LOOKUP;
  
  struct symbol_table {
    char name[100];
    int type;
    struct symbol_table *next;
  };
  struct symbol_table *symbol_list;
  
  void add_symbol(int type, char *symbol);
  int find_symbol(char *symbol);
  void print_symbol_table();

  void yyerror(char const *s) {
    fprintf(stderr, "Error at line number %d: %s\n" , yylineno, s);
  }
%}

%%
"if"			  {return IF;}
"else"			{return ELSE;}
"int"			  {state = INT;return INT;}
"float"     {state = FLOAT; return FLOAT;}
"char"      {state = CHAR; return CHAR;}
"double"    {state = DOUBLE; return DOUBLE;}
"return"		{return RETURN;}
"void"			{state = VOID; return VOID;}
"while"			{return WHILE;}
"+"			    {return PLUS;}
"-"			    {return MINUS;}
"*"			    {return MUL;}
"/"			    {return DIV;}
"<"			    {return LOWER;}
"<="			  {return LOWER_OR_EQUAL;}
">"			    {return GREATER;}
">="			  {return GREATER_OR_EQUAL;}
"=="			  {return EQUAL;}
"!="			  {return NOT_EQUAL;}
"="			    {return ASSIGN;}
";"			    {state = LOOKUP; return SEMICOLON;}
","			    {return COMMA;}
"{"			    {return OPEN_BRACE;}
"}"			    {return CLOSE_BRACE;}
"("			    {return OPEN_PARENTHESES;}
")"			    {return CLOSE_PARENTHESES;}
"["			    {return OPEN_SQR_BRACKET;}
"]"			    {return CLOSE_SQR_BRACKET;}
[a-zA-Z]+		{
              if (state != LOOKUP) {
                if (!find_symbol(yytext)) {
                  add_symbol(state, yytext);
                  state = LOOKUP;
                  return ID;
                } else {
                  yyerror("symbol already declared");
                }
              }
              else {
                if (!find_symbol(yytext)) {
                  yyerror("symbol not defined");
                } else {
                  return ID;
                }
              }
            }
[0-9]+			      {return NUM;}
[ \t\n]+		      {;}
"/*"			        {BEGIN(COMMENT);}
<COMMENT>"*/"		  {BEGIN(INITIAL);}
<COMMENT>.		    { }
<COMMENT>\n		    { }
<COMMENT><<EOF>>	{yyerror("unclosed multiline comment"); yyterminate();}
.			            {yyerror("unexpected token");}
%%

void add_symbol(int type, char* symbol) {
  struct symbol_table *sp;
  sp = (struct symbol_table* ) malloc(sizeof(struct symbol_table));
  sp->next = symbol_list;
  strcpy(sp->name, symbol);
  sp->type = type;
  symbol_list = sp;
}

int find_symbol(char* symbol) {
  struct symbol_table *sp = symbol_list;
  for(; sp;sp = sp->next) {
    if (strcmp(sp->name, symbol) == 0) {
      return sp->type;
    }
  }
  return 0;
}

void print_symbol_table() {
  struct symbol_table *sp = symbol_list;
  for(; sp; sp = sp->next) {
    char type[16];
    switch(sp->type) {
      case INT:
      strcpy(type, "int");
      break;
      case FLOAT:
      strcpy(type, "float");
      break;
      case DOUBLE:
      strcpy(type, "double");
      break;
      case CHAR:
      strcpy(type, "char");
      break;
      case VOID:
      strcpy(type, "void");
      break;
      default:
      strcpy(type, "undefined");
    }
    printf("type: %s, name: %s\n", type, sp->name);
  }
}