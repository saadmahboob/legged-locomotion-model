function dydt = slasm(t,y,gamma1,gamma2)
dydt = [y(2); gamma1*sin(y(1))-gamma2*y(1)];