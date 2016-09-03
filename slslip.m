function dydt = slslip(t,y,g,gamma,Q)
dydt = [y(2); g*sin(y(1))/y(3)-2*y(2)*y(4)/y(3); y(4); -g*cos(y(1))+y(3)*y(2)*y(2)-gamma*(y(3)-Q)];
