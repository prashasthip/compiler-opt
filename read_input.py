f=open("output.txt",'r')
l=f.readlines()
l=l[4:]
f.close()
f1=open("as.txt",'w')
for i in l:
	f1.write(i)

f1.close()
