function n = masssw(t,y)
% y(1)= psi, & y(3) = q, or the length of the leg.
n1 = [1 0 0 0 0 0];
n2 =[0 1 0 0 0 0];
n3 =[0 0 1 0 0 0];
n4=[0 6*sin(y(1)-y(5)) 0 3 0 0];
n5 =[0 0 0 0 1 0];
n6 =[0 -3*cos(y(1)-y(5)) 0 0 0 2*y(3)];
n=[n1;n2;n3;n4;n5;n6];