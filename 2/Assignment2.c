#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include <stdbool.h>


bool isOperator(char ch){
    if (ch == '+' || ch == '-' || ch == '*' || ch == '/' || ch == '>' || ch == '<' || ch == '=')
        return (true);
    return (false);
}

bool isKeyword(char* str) {
    if (!strcmp(str, "if") || !strcmp(str, "else") || !strcmp(str, "while") || !strcmp(str, "do") ||    !strcmp(str, "break") || !strcmp(str, "continue") || !strcmp(str, "int") 
    || !strcmp(str, "double") || !strcmp(str, "float") || !strcmp(str, "return") || !strcmp(str,    "char") || !strcmp(str, "case") || !strcmp(str, "typedef") || !strcmp(str, "switch")
    || !strcmp(str, "void") || !strcmp(str, "struct") || !strcmp(str, "goto") || !strcmp(str, "main"))
        return (true);
    return (false);
}

bool isDelimiter(char ch) {
    if (ch == ' ' || ch == '+' || ch == '-' || ch == '*' || ch == '/' || ch == ',' || ch == ';' || ch == '>' || ch == '<' || ch == '=' || ch == '(' || ch == ')' || ch == '[' || ch == ']' || ch == '{' || ch == '}')
        return (true);
    return (false);
}

bool isIdentifier(char* str){
   if (str[0] == '0' || str[0] == '1' || str[0] == '2' ||
   str[0] == '3' || str[0] == '4' || str[0] == '5' ||
   str[0] == '6' || str[0] == '7' || str[0] == '8' ||
   str[0] == '9' || isDelimiter(str[0]) == true)
    return (false);
   return (true);
}


int main(){
char ch, buffer[15];
FILE *fp;
int i,j=0;
fp = fopen("program.txt","r");
if(fp == NULL){
    printf("error while opening the file\n");
    exit(0);
}
while((ch = fgetc(fp)) != EOF){
    
       if(isOperator(ch))
       printf("%c is operator\n", ch);
        
    
        if(isalnum(ch)){
            buffer[j++] = ch;
        
        }
        else if((ch == ' ' || ch == '\n') && (j != 0)){
            buffer[j] = '\0';
            j = 0;
            if(isKeyword(buffer))
                printf("%s is keyword\n", buffer);
            else if (isIdentifier(buffer)) 
                printf("%s is indentifier\n", buffer);
        }
  
    
}

fclose(fp);
return 0;
}