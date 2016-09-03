%This is same as SWASModel, but now with dimensions relevant for the pro
%leg.
B=0.151;% controls angular strain of stance
M=0.001;% mass of body
m=0.00001;% mass of each leg assumed small compared to M
g=980;
L=0.15;% length of stance leg
Q=0.05;% "natural" length of swing leg
k=0.015; % spring const for swing leg
gamma=k/m;Bb=B/(M*L*L);gb=g/L;Qb=Q/L; % derived quantities
omega3=4;qini=0.152971/L;omega1=95; % initial conditions
ode1 = @(t,y) swasm(t,y,gb,gamma,Qb,Bb);
%q = y(3), psi (stance-angle) = y(1) and theta (swing angle)= y(5)
options = odeset('Mass',@masssw);
[t,y] = ode45(ode1,[0 0.029],[0; -omega3; qini; -22/L;0.197396;omega1],options);
plot(t,L*y(:,3),'-')
%plot(t,cos(y(:,1)).*y(:,3),'-',t,y(:,3).*sin(y(:,1)),'--')
%plot(t,cos(y(:,1))*L,'-',t,L*sin(y(:,1)),'--')% plot of stance leg 
%plot(t,L*(cos(y(:,1))-cos(y(:,5)).*y(:,3)),'-',t,L*(-sin(y(:,1))+y(:,3).*sin(y(:,5))),'--')
%plot(L*sin(y(:,1)),cos(y(:,1))*L,'-')
plot(L*(-sin(y(:,1))+y(:,3).*sin(y(:,5))),L*(cos(y(:,1))-cos(y(:,5)).*y(:,3)))


