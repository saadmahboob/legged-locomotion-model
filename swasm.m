function dydt = swasm(t,y,gb,gamma,Qb,Bb)
% y(1)= psi, & y(3) = q, or the length of the leg.
 dydt = [y(2); gb*sin(y(1))-Bb*y(1); y(4); 6*gb*cos(y(5))+4*y(3)*y(6)*y(6)-12*gamma*(y(3)-Qb)-6*cos(y(5)-y(1))*y(2)*y(2); y(6);3*sin(y(5)-y(1))*y(2)*y(2)-3*gb*sin(y(5))-4*y(4)*y(6)];
