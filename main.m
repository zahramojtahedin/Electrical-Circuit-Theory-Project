


clc

close all

clear all
out="out.txt"
loc=[0 0;0 1;1 1;1 0];

file="info.txt";
cir(file,out,loc);

function cir(file,out,loc)


tab={};

fid = fopen(file);
i=1;
tline = fgetl(fid);
while ischar(tline)
    j=1;
    tline=split(tline,",");
for j=1:size(tline)
tab{i,j}=tline{j};
end
i=i+1;
    tline = fgetl(fid);
end

syms t



vol={};
cs={};
for i=1:size(tab)
    st="v"+string(i);
    st2="i"+string(i);
    eval("syms "+st)
    eval("syms "+st2)
    vol{end+1}=eval(st);
    cs{end+1}=eval(st2);
end
im=[];
for i=1:size(tab)
if tab{i,1}=='v'
vol{i}=eval(tab{i,5});
cs{i}=int(vol{i});
else
    im=[im,cs(i)];
end
end


nod=[];
for i=1:size(tab,1)
    nod=[nod,str2num(tab{i,3})];
nod=[nod,str2num(tab{i,4})];
end


nod=unique(nod);
f=[];
for i=1:size(nod,2)
    st2="f"+string(i);
    eval("syms "+st2);
    st="f"+string(i)+"=";
    
    for j=1:size(tab,1)
        if tab{j,3}==num2str(nod(i))
            st=st+"+"+string(cs{j});
        end
    
        if tab{j,4}==num2str(nod(i))
            st=st+"-"+string(cs{j});
        end
    end
    st=st+"==0";
    eval(st);
    f=[f,eval(st2)];
end
        
  


a=solve(f,im);

for i=1:size(tab)
if tab{i,1}=='v'
else
    cs{i}=eval("a."+string(cs{i}));
end
end



for i=1:size(tab)
if tab{i,1}=='c'
    vol{i}=int(cs{i});
end
end


for i=1:size(tab)
if tab{i,1}=='r'
    vol{i}=(cs{i})*str2num(tab{i,5});
end
end




pow=vol;
for i=1:size(tab)
pow{i}=vol{i}*cs{i};
end








figure(1)
hold on
title("voltage of circle")
for i=1:size(loc,1)
    text(loc(i,1),loc(i,2),"n"+string(i),'color','white');
end

for i=1:size(tab,1)
    st=loc(str2num(tab{i,3})+1,:);
    et=loc(str2num(tab{i,4})+1,:);
    x=[st(1),et(1)];
    y=[st(2),et(2)];
    plot(x,y,'color','red','LineWidth',5)
    text(sum(x)/2,sum(y)/2+0.1,string(tab{i,2}),'color','blue')
    text(sum(x)/2,sum(y)/2-0.1,string(vol{i}),'color','blue')
end
axis([-2 2 -2 2])





figure(2)
hold on
title("element current")
for i=1:size(loc,1)
    text(loc(i,1),loc(i,2),"n"+string(i),'color','white');
end

for i=1:size(tab,1)
    st=loc(str2num(tab{i,3})+1,:);
    et=loc(str2num(tab{i,4})+1,:);
    x=[st(1),et(1)];
    y=[st(2),et(2)];
    plot(x,y,'color','red','LineWidth',5)
    text(sum(x)/2,sum(y)/2+0.1,string(tab{i,2}),'color','blue')
    text(sum(x)/2,sum(y)/2-0.1,string(cs{i}),'color','blue')
end
axis([-2 2 -2 2])





figure(3)
hold on
title("power of circle")
for i=1:size(loc,1)
    text(loc(i,1),loc(i,2),"n"+string(i),'color','white');
end

for i=1:size(tab,1)
    st=loc(str2num(tab{i,3})+1,:);
    et=loc(str2num(tab{i,4})+1,:);
    x=[st(1),et(1)];
    y=[st(2),et(2)];
    plot(x,y,'color','red','LineWidth',5)
    text(sum(x)/2,sum(y)/2+0.1,string(tab{i,2}),'color','blue')
    text(sum(x)/2,sum(y)/2-0.1,string(pow{i}),'color','blue')
end
axis([-2 2 -2 2])



fid = fopen(out,'wt');
for i=1:size(tab,1)
st="<"+string(tab{i,1})+"><"+string(tab{i,2})+"><"+string(vol{i})+"><"+string(cs{i})+"><"+string(pow{i})+">";
    fprintf(fid,st);
    fprintf(fid,'\n');
end
fclose(fid);





end