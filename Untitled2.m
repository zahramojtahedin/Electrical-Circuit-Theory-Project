syms a
syms b
syms s
e1= (5+ 4*s)*a - 4*s*b == 10/s
e2= (15+ 4*s)*b - 4*s*a == 20/s
[A,B] = equationsToMatrix([e1, e2], [a,b])
l = linsolve(A,B)
ilaplace(l(1))
ilaplace(l(2))
