import ply.lex as lex
code=[]
blocks=[]
#--------------------------------------------------------------------------------------
# lexical rules and operations


tokens=('EXP','GOTO','REST','IF','ASSIGN','COND','WASSIGN')

def t_EXP(t):
	r'([A-Za-z])\s=\s+(\w+)\s+([*-+/%=])\s+(\w+)\s*(\d+)?\s*\n?'
	t.value= [t.type]+list(t.lexer.lexmatch.groups()[1:6])
	#print (t.value,t.type)
	global code
	code.append(t.value)	
	return t



def t_COND(t):
	r'([A-Z])\s=\s+(\w+)\s+([<>][=]?|[=][=])\s+(\w+)\s*(\d+)?\s+?\n?'
	t.value= [t.type]+list(t.lexer.lexmatch.groups()[1+6:6+6])
	#print (t.value,t.type)
	global code
	code.append(t.value)	
	return t

def t_ASSIGN(t):
	r'([a-z])\s=\s+(\d+|\w+)\s+?(\d+)?\s*?\n?'
	t.value= [t.type]+list(t.lexer.lexmatch.groups()[1+12:4+12])
	#print(t.lexer.lexmatch.groups())
	x=t.value.pop()
	t.value.append(None)
	t.value.append(None)
	t.value.append(x)
	#print (t.value,t.type)
	global code
	code.append(t.value)	
	return t


def t_WASSIGN(t):
	r'([A-Z])\s=\s+(\d+|\w+)\s+?(\d+)?\s*?\n?'
	t.value= [t.type]+list(t.lexer.lexmatch.groups()[1+16:4+16])
	#print(t.lexer.lexmatch.groups())
	x=t.value.pop()
	t.value.append(None)
	t.value.append(None)
	t.value.append(x)
	#print (t.value,t.type)
	global code
	code.append(t.value)	
	return t



def t_IF(t):
	r'(if)\s+[(]([A-Z])[)]\s+(goto)\s+(\d+)\s+?(\d+)?\s*\n?'
	t.value= [t.type]+list(t.lexer.lexmatch.groups()[1+20:6+20])
	#print (t.value,t.type)
	global code
	code.append(t.value)	
	return t


def t_GOTO(t):
	#r'(goto)\s+(\d+)\s+?(\d+)?\s+?\n?'
	r'(goto)\s+(\d+)\s+?(\d+)?\s*\n?'	
	t.value= [t.type,None,None]+list(t.lexer.lexmatch.groups()[1+26:4+26])
	#print (t.value,t.type)
	global code
	code.append(t.value)	
	return t

def t_REST(t):
	r'.|\n'


#--------------------------------------------------------------------------------------
# Functions (Internal and display)

def disp(cod):
	for i in range(len(cod)):
		for j in cod[i][1:]:
			'''if(j==None):
				print('',end='\t')
			else:
				print(j,end='\t')'''
			print(j,end='\t')
		print('\t\t',i)


def rep(i,j):
	#global code
	#print(i,j,code[i][1],code[j][1])
	for x in range(j,len(code))[::-1]:
		for y in range(1,6):
			if code[x][y]==code[j][1]:
				code[x][y]=code[i][1]
				#print('x:',x)


def dispb():
	print("BLOCKS")
	for i in range(len(blocks)):
		print("\t"*2,'-'*4,i+1,'-'*4)
		disp(blocks[i])
		print()

	print("DONE")

			
#--------------------------------------------------------------------------------------
#Reading Input and Lexically Analysing


f=open('as1.txt','r')
lexer=lex.lex()
x=f.read()
lexer.input(x)
for t in lexer:
	pass


print('-'*10,'Original Code','-'*10)
disp(code)
print('\n\n')

#--------------------------------------------------------------------------------------
#Creating Blocks


def createblocks():
	s=0	
	for i in range(len(code)):
		
		if(code[i][0]=='GOTO' or code[i][0]=='IF'):
			blocks.append(code[s:i+1])
			s=i+1
		elif(not code[i][5]==None):
			blocks.append(code[s:i])
			s=i
	blocks.append(code[s:len(code)])
	global blocks
	blocks=list(filter(lambda x : x,blocks))


createblocks()		#call for block creation

#--------------------------------------------------------------------------------------
# Optimising things and marking 

#rem=[]
d={}

def op(cod):
	rem=[]
	for i in range(len(cod)):
		if(cod[i][0]=='EXP'):
			#print('EXP')
			for j in range(i+1,len(cod)):
				if (cod[j][0]=='EXP'):
					#print('EXP2')
					if((not d.get(cod[j][2],False)) and (not d.get(cod[j][4],False)) and cod[j][2:]==cod[i][2:]):
						rep(i,j)
						rem.append(j)
						d[cod[j][2]]=False
						d[cod[j][4]]=False
						
						
				elif (cod[j][0]=='ASSIGN'):
					 d[cod[j][1]]=True
		
		if(cod[i][0]=='COND'):
			for j in range(i+1,len(cod)):
				if (cod[j][0]=='COND'):
					if((not d.get(cod[j][2],False)) and (not d.get(cod[j][4],False)) and cod[j][2:]==cod[i][2:]):
						rep(i,j)
						rem.append(j)
						d[cod[j][2]]=False
						d[cod[j][4]]=False
						
						
				if (cod[j][0]=='ASSIGN'):
					 d[cod[j][1]]=True
	
		if(cod[i][0]=='WASSIGN'):
			rem.append(i)
			for j in range(i+1,len(cod)):
				for x in range(1,6):
					if(cod[j][x]==cod[i][1]):
						cod[j][x]=cod[i][2]
							
					
	return rem
		
#--------------------------------------------------------------------------------------	
# OPtimiszation caller and Removing Removables



#op(code)
#print(rem)
#for i in list(set(rem))[::-1]:
#	code.pop(i)
def optimiserb():
	global blocks
	for i in range(len(blocks)):
		rem=op(blocks[i])
		#print(rem)
		for j in list(set(rem))[::-1]:
			blocks[i].pop(j)
	#print(blocks)
		 

print('-'*10,'Initial Blocks','-'*10)
dispb()
print('\n\n')

optimiserb()		#call for block optimiser


#--------------------------------------------------------------------------------------
# Generating Final optimised Code

print('-'*9,'Optimised Blocks','-'*9)
dispb()
print('\n\n')

def joinblocks():
	newcode=[]
	for i in blocks:
		for j in i:
			newcode.append(j)
	return newcode

ncode=joinblocks()
print('-'*10,'Optimised Code','-'*10)
disp(ncode)
print('\n\n')


						



