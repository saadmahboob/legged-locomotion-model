function dydt = slgrav(t,y,gamma)
dydt = [y(2); gamma*sin(y(1))];