/* COBOL calculator using Bison
   Program created by Kollin Labowski for use in CS 410
   Submitted December 9, 2021
*/

%{
  #include <stdio.h>

  int A = 0, B = 0, C = 0, D = 0, E = 0;

  int yylex (void);
  void yyerror (char const *);
%}


%define api.value.type {int}
%token VAR1
%token VAR2
%token VAR3
%token VAR4
%token VAR5
%token ADD
%token TO
%token SUBTRACT
%token FROM
%token GIVING
%token PRINT
%token NUMBER
%token EXIT
%left '+' '-'
%left ADD SUBTRACT TO FROM

%% 

/* See the below grammar for the COBOL assignment statements 
   This grammar is based on the grammar written in LabowskiGrammar.txt */

input:
  %empty
| input equation
;


equation:
  '\n'
| expression GIVING VAR1 '\n'     { A = $1; /*printf ("A = %d\n\n", (int) $1);*/ } //The print statements are commented out as they are not needed for the example program,
| VAR1 '=' expression              { A = $3; /*printf ("A = %d\n\n", (int) $3);*/ }//However they are still there in case the program is to be changed in the future
| expression GIVING VAR2 '\n'     { B = $1; /*printf ("B = %d\n\n", (int) $1);*/ }
| VAR2 '=' expression              { B = $3;/* printf ("B = %d\n\n", (int) $3);*/ }
| expression GIVING VAR3 '\n'     { C = $1; /*printf ("C = %d\n\n", (int) $1);*/ }
| VAR3 '=' expression              { C = $3; /*printf ("C = %d\n\n", (int) $3);*/ }
| expression GIVING VAR4 '\n'     { D = $1; /*printf ("D = %d\n\n", (int) $1);*/ }
| VAR4 '=' expression              { D = $3; /*printf ("D = %d\n\n", (int) $3);*/ }
| expression GIVING VAR5 '\n'     { E = $1; /*printf ("E = %d\n\n", (int) $1);*/ }
| VAR5 '=' expression              { E = $3; /*printf ("E = %d\n\n", (int) $3);*/ }
| PRINT                           { printf("A = %d, B = %d, C = %d, D = %d, E = %d\n\n", A, B, C, D, E); }
;


expression:
  NUMBER
| VAR1                                  { $$ = A;            }
| VAR2                                  { $$ = B;            }
| VAR3                                  { $$ = C;            }
| VAR4                                  { $$ = D;            }
| VAR5                                  { $$ = E;            }
| expression '+' expression             { $$ = $1 + $3;      }
| expression '-' expression             { $$ = $1 - $3;      }
| ADD expression TO expression          { $$ = $2 + $4;      }
| SUBTRACT expression FROM expression   { $$ = $4 - $2;      }
| '(' expression ')'                    { $$ = $2;           }
;

%%

#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

char* addStr = "ADD";
char* subtractStr = "SUBTRACT";
char* toStr = "TO";
char* fromStr = "FROM";
char* givingStr = "GIVING";
char* printStr = "PRINT";
char* quitStr = "QUIT";

//Function prototype
int isToken(char*);

/*
  Main method, makes a call to yyparse()
*/
int main()
{
  return yyparse();
}

/*
  yyerror is called in the event of an error in parsing
*/
void yyerror (char const *s)
{
  fprintf(stderr, "%s\n", s);
}

/*
  Determine which token an input symbol corresponds to and output it so the grammar can use it
*/
int yylex ()
{
  char readChar;

  scanf("%c", &readChar);
  
  while (readChar == '\t' 
    || readChar == ' ')
    scanf("%c", &readChar);

  if(readChar == 'A')
  {
    if(isToken(addStr))
      return ADD;
    else
      return VAR1;
  }

  else if(readChar == 'B')
    return VAR2;

  else if(readChar == 'C')
    return VAR3;

  else if(readChar == 'D')
    return VAR4;

  else if(readChar == 'E')
    return VAR5;

  else if(readChar == 'S')
  {
    if(isToken(subtractStr))
      return SUBTRACT;
  }

  else if(readChar == 'T')
  {
    if(isToken(toStr))
      return TO;
  }

  else if(readChar == 'F')
  {
    if(isToken(fromStr))
      return FROM;
  }

  else if(readChar == 'G')
  {
    if(isToken(givingStr))
      return GIVING;
  }

  else if(readChar == 'P')
  {
    if(isToken(printStr))
      return PRINT;
  }

  else if (isdigit(readChar))
  {
      ungetc(readChar, stdin);

      if (scanf("%d", &yylval) != 1)
        abort();
      return NUMBER;
  }

  else if (readChar == 'Q')
  {
    if(isToken(quitStr))
      return YYEOF;
  }

  return readChar;
}

/*
  A helper function used by yylex() to help with tokenizing the input for the grammar
*/
int isToken(char* verifyStr)
{
    int count = 1;
    char currChar = *(verifyStr + count);
    int correctSyntax = 1;
    while(currChar != '\0')
    {
      char readChar;
      scanf("%c", &readChar);

      if(readChar == '\n')
      {
        ungetc(readChar, stdin);
        return 0;
      }

       else if(currChar != readChar)
        return 0;

      count++;
      currChar = *(verifyStr + count);
    }

    return 1;
}

//End of file