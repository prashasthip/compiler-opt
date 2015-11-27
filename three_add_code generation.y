%{

  #include<stdio.h>
  #include<string.h>
  #include<stdlib.h>

void ThreeAddressCode();
void triple();
void qudraple();
char AddToTable(char,char, char * ,int);
void check(int);
int isLower(char);
int z=1;
int ind=0;
char temp='A';
int end=0;
int l[];int size=0;    //array containing present loop....size=size of the array

struct incod
  {
	char opd1;
	char opd2;
	char *opr;
	int tru,fals,begin,flag,modify;   //flag=1 if loop starts.....flag=2 if loop endin
  };
%}


%union
{
 char sym;
}


%token <sym> LETTER NUMBER WHILE IF FOR INT UNARY_m UNARY_p 
%type <sym> expr loop AL IL FL FL1 FL2
%left '-''+''('')''='
%left '*''/''%'
%left '<''>''!'

%%

start: statement
       |start statement
       ;


statement: LETTER '=' expr ';' {AddToTable((char)$1,(char)$3,"=",9);}    // 9 to do the assignments
	   |INT LETTER '=' expr ';' {AddToTable((char)$2,(char)$4,"=",9);}
           | INT expr ';'
           |loop
           |IL
           |FL1           
           |INT DEC ';'
           |
           ;

stmt1:	LETTER '=' expr  {AddToTable((char)$1,(char)$3,"=",9);}    // 9 to do the assignments
	|expr
        |
        ;


DEC: LETTER 
     |LETTER ',' DEC
     ; 
	   

AL: '('expr')' {AddToTable('0','0',"0",3);}                //loop condition
     ;


IL: '{'start'}' {$$=AddToTable('0','0',"0",2);}                //body of loop....2 passed at the end of loop
     |IL '{'start'}'
     ;


loop: WHILE AL  {$$=AddToTable('0','0',"0",1);}            //start of loop
      |IF AL {$$=(char)$1;}
      |FOR FL //{$$=AddToTable('0','0','0',3);}
      ;


FL: '('expr1 FL2 //{$$=AddToTable('0','0',"0",10);}
     |'(' FL2 //{$$=AddToTable('0','0',"0",11);}
     ;

FL2: ';'expr  {$$=AddToTable('0','0',"0",4);}
      |';' {$$=AddToTable('0','0',"0",6);}              // 6 to signal empty condition check in for loop
      ;

FL1: ';'stmt1')' {$$=AddToTable('0','0',"0",5);}
     |';' ')'  {$$=AddToTable('0','0',"0",7);}            // 7 to signal empty modification in for loop
     ;

expr1:  LETTER '=' expr		{AddToTable((char)$1,(char)$3,"=",9);}
	|INT LETTER '=' expr	{AddToTable((char)$2,(char)$4,"=",9);}
	|expr
        |INT expr
        ;

expr: expr '+' expr {$$ = AddToTable((char)$1,(char)$3,"+",0);}
      | expr '-' expr {$$ = AddToTable((char)$1,(char)$3,"-",0);}
      | expr '*' expr {$$ = AddToTable((char)$1,(char)$3,"*",0);}
      | expr '%' expr {$$ = AddToTable((char)$1,(char)$3,"%",0);}
      | expr '/' expr {$$ = AddToTable((char)$1,(char)$3,"/",0);}
      | expr '<' expr {$$ = AddToTable((char)$1,(char)$3,"<",0);}
      | expr '>' expr {$$ = AddToTable((char)$1,(char)$3,">",0);}
      | expr '=' expr {$$ = AddToTable((char)$1,(char)$3,"=",0);}   
      | '(' expr ')' {$$ = (char)$2;}
      | expr '<''=' expr {$$ = AddToTable((char)$1,(char)$4,"<=",0);}
      | expr '>''=' expr {$$ = AddToTable((char)$1,(char)$4,">=",0);}
      | expr '=''=' expr {$$ = AddToTable((char)$1,(char)$4,"==",0);}
      | expr '!''=' expr {$$ = AddToTable((char)$1,(char)$4,"!=",0);} 
      | expr UNARY_m {$$ = AddToTable((char)$1,'1',"-",10);} 
      | expr UNARY_p {$$ = AddToTable((char)$1,'1',"+",10);}
      | UNARY_m expr {$$ = AddToTable((char)$1,'1',"-",10);} 
      | UNARY_p expr {$$ = AddToTable((char)$1,'1',"+",10);} 
      | NUMBER {$$ = (char)$1;}
      | LETTER {$$ = (char)$1;}
      |
      ; 
      

%%

yyerror(char *s)
{
  printf("%s",s);
  exit(0);
}

struct incod code[20];

int id=0;

char AddToTable(char opd1,char opd2,char * opr,int loop)
{

code[ind].opd1=opd1;
code[ind].opd2=opd2;
code[ind].opr=opr;
code[ind].flag=loop;
if(loop==1)
{
code[ind].begin=newlabel();
code[ind].tru=newlabel();
code[ind].fals=newlabel();
l[size++]=ind;
}
if(loop==4||loop==6)
{
code[ind].begin=newlabel();
code[ind].tru=newlabel();
code[ind].fals=newlabel();
code[ind].modify=newlabel();
l[size++]=ind;
}

//printf("%c\t%c\t%s",code[ind].opd1,code[ind].opd2,code[ind].opr);
ind++;
if(loop!=9&&loop!=10&&loop!=2){temp++;}
return temp;
}

void ThreeAddressCode()
{
int cnt=0;
temp++;
printf("\n\n\t THREE ADDRESS CODE\n\n");
while(cnt<ind)
{
	

 if(code[cnt].flag!=2)
	{ 
		//if(code[cnt].flag==9)
		//{
			//printf("%c = \t",temp);
			//printf("%c\t",code[cnt].opd2);
		//	printf("%c = \t",code[cnt].opd1);
	//		printf("%c\t",code[cnt].opd2);    // may b temp-1
	//	}
	//else
	//{

	int loop=code[cnt].flag;
	if(loop!=5&&loop!=7&&loop!=2&&loop!=3){
	if(code[cnt].flag!=9&&code[cnt].flag!=10){printf("%c = \t",temp);}
	if(code[cnt].flag==10){printf("%c = \t",code[cnt].opd1);}       

	 if(code[cnt].opd1=='0')
		printf("%c\t",temp-1);
	//else if(code[cnt].flag==9){printf("%c\t",code[cnt].opd2;printf("\n%c}
	else if(isalpha(code[cnt].opd1)){
	if(code[cnt].flag==9)
		{printf("%c ",code[cnt].opd1);}else{printf("%c\t",code[cnt].opd1);}}
	
	
	else 
		{printf("%c\t",code[cnt].opd1);}

	

        if(code[cnt].opr=="0")
		printf(" \t");
	else
		printf("%s\t",code[cnt].opr);
	
	if(code[cnt].opd2=='0')
		printf(" \t");
	else if(isalpha(code[cnt].opd2))
		printf("%c\t",code[cnt].opd2);//
	else if(code[cnt].opd2=='1')
		printf("1\t");
	else 
		{printf("%c\t",code[cnt].opd2);}	}
	if(code[cnt].flag!=9&&code[cnt].flag!=10){temp++;}
	
	if(code[cnt-1].flag==3)                             // print the label at WHILE loop starting ....ie after { cnt-1
		{printf("%d",code[cnt-1].tru);}

	if(code[cnt].flag==5 && code[l[size-1]].flag==4)//both ther // print the label at modification statement and goto after that of FOR loop
		{//printf("%d",code[l[size-1]].modify);
		 printf("\ngoto %d",code[l[size-1]].begin);
		}

	if(code[cnt].flag==7 && code[cnt-1].flag==6)//both nt ther// print the label at modification statement and goto after that of FOR loop
		{////printf("%d",code[l[size-1]].modify);
		 //printf("\ngoto %d",code[l[size-1]].tru);
		}
	
	if(code[cnt].flag==7 && code[cnt-1].flag==4)//nly cond chek// print the label at modification statement and goto after that of FOR loop
		{////printf("%d",code[l[size-1]].modify);
		 //printf("\ngoto %d",code[l[size-1]].begin);
		}
	
	if(code[cnt].flag==5 && code[l[size-1]].flag==6)         // print the label at modification statement and goto after that of FOR loop
		{//printf("%d",code[l[size-1]].modify);
                  if(code[cnt+1].flag==2){
		 printf("\ngoto %d",code[l[size-1]].modify);}else{printf("\ngoto %d",code[l[size-1]].tru);}
		}

	if(code[cnt-1].flag==4||code[cnt-1].flag==6)
	{if(!(code[cnt].flag==7 && (code[cnt-1].flag==4||code[cnt-1].flag==6)))printf("%d",code[l[size-1]].modify);}
	


	if(code[cnt-1].flag==5||code[cnt-1].flag==7)                             // print the label at FOR loop body starting ....
		{printf("%d",code[l[size-1]].tru);}
	

	if(end==1)                             // gives label to statement after loop body
		{printf("%d",code[l[size]].fals);end=0;}		

}


	if(code[cnt].flag==1)                                // printing if and goto .....after while loop conditions and labels
		{ printf("%d\n",code[cnt].begin);
		  printf("if (%c)\tgoto %d",temp-1,code[l[size-1]].tru);
		  printf("\ngoto %d",code[cnt].fals);}

	if(code[cnt].flag==4 && code[cnt+1].flag!=7)  //expr;expr)          // printing if and goto .....after for loop condition 
		{ printf("%d\n",code[cnt].begin);if(code[cnt+3].flag==2){
			printf("if (%c)\tgoto %d",temp-1,code[l[size-1]].modify);
		  printf("\ngoto %d",code[l[size-1]].fals);
		}else{
		  printf("if (%c)\tgoto %d",temp-1,code[l[size-1]].tru);
		  printf("\ngoto %d",code[l[size-1]].fals);}}

	if(code[cnt].flag==6 &&code[cnt+1].flag!=7)   //   ;expr)             // printing if and goto .....after for loop condition 
		{ if(code[cnt+3].flag!=2){printf("%d\n",code[l[size-1]].begin);
		 // printf("if (%c)\tgoto %d",temp-1,code[cnt].tru);
	          printf("\ngoto %d",code[l[size-1]].tru);}}

	if(code[cnt].flag==6 &&code[cnt+1].flag==7)   //   ;    )             // printing if and goto .....after for loop condition 
		{ if(code[cnt+2].flag==2)        //no-body
		{printf("%d\n",code[l[size-1]].begin);
		  //printf("if (%c)\tgoto %d",temp-1,code[cnt].tru);
		  printf("\ngoto %d",code[l[size-1]].begin);
		}
		
		else{printf("%d\n",code[l[size-1]].begin);
		  //printf("if (%c)\tgoto %d",temp-1,code[cnt].tru);
		  printf("\ngoto %d",code[l[size-1]].tru);}}

	if(code[cnt].flag==4 &&code[cnt+1].flag==7)   //expr;   )             // printing if and goto .....after for loop condition 
		{
		if(code[cnt+2].flag==2)
		{printf("%d\n",code[l[size-1]].begin);
		  printf("if (%c)\tgoto %d",temp-1,code[cnt].begin);
		  printf("\ngoto %d",code[l[size-1]].fals);
		} 
		else{
		printf("%d\n",code[l[size-1]].begin);
		  printf("if (%c)\tgoto %d",temp-1,code[cnt].tru);
		  printf("\ngoto %d",code[l[size-1]].fals);}
		}



        

	

//if(code[cnt].flag==2 ){
	



	if(!(code[cnt].flag==2 && (code[cnt-1].flag==5||code[cnt-1].flag==7)))	// body is ther
	{
	
     	if(code[cnt].flag==2 && code[l[size-1]].flag==0)             // wen  while loop body ends ... goto startin of loop
		{printf("goto %d",code[l[size-1]].begin);size--;end=1;}

     	if(code[cnt].flag==2 && code[l[size-1]].modify!=0 && code[l[size-1]+1].flag!=7)//mod ther//wen for loop's body ends ... goto startin of loop
		{printf("goto %d",code[l[size-1]].modify);size--;end=1;}
	
     	if(code[cnt].flag==2 && code[l[size-1]].modify!=0 && code[l[size-1]+1].flag==7)//mod nt ther/ wen for loop's body ends..goto startin of loop
		{if(code[l[size-1]].flag==6){printf("goto %d",code[l[size-1]].tru);size--;end=1;}//cond nt ther
		else{printf("goto %d",code[l[size-1]].begin);size--;end=1;}}

   


	}else                                        // no body
	{
 	if(code[cnt].flag==2){size--;end=1;}
	}	
	printf("\n");
	cnt++;
	
	}
	}






main()
{
 //printf("\nEnter the Expression: ");
char file[10];
//printf("enter the input file name\t");
//scanf("%s",file);
//printf("enter the output file name\t");
//scanf("%s",file1);
extern FILE *yyin,*yyout;
yyin = fopen("in.txt","r"); 
yyout=fopen("output.txt","w");
yyparse();
temp='A';
ThreeAddressCode();
//quadraple();
//triple();
}

yywrap()
{
 return 1;
}

int newlabel()
{
return z++;
}



