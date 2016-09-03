% This program uses function slasm
%g=1000;L=0.22;M=0.001;B=0.218;gamma1=g/L;gamma2=B/(M*L*L);omega=4;ode = @(t,y) slasm(t,y,gamma1,gamma2);[t,y] = ode45(ode,[0 0.15],[0; omega]);
% M can be measured. L & the initial and final value of time can be determined by looking at the averages. 
% One would then need to vary omega & B systematically. 
%plot(t,L*cos(y(:,1)),'-',t,L*sin(y(:,1)),'--')

% This program uses function slasm
%% load data for COM evolution
load('150629_fixedpoint.mat');
filename='150629_4_4.avi';
datafilename = strcat('AS_', filename(1:10));

%% conversion to cms
if exist('pixel_to_cm', 'var') == 0
video = VideoReader(filename);
image=read(video,80);
imshow(image);
[x,y]=ginput(3);
dist=sqrt((x(1)-x(2))^2+(y(1)-y(2))^2);
pixel_to_cm=0.3/dist;
end
fixedpoint(:,2,:)=abs(fixedpoint(:,2,:)-y(3));
fixedpoint(:,2,:)=fixedpoint(:,2,:)*pixel_to_cm;
fixedpoint(:,1,:)=abs(fixedpoint(:,1,:)-mean(fixedpoint(12,1,:)));
fixedpoint(:,1,:)=fixedpoint(:,1,:)*pixel_to_cm;
mean_fixedpoint_x=mean(fixedpoint(:,1,:),3);
mean_fixedpoint_y=mean(fixedpoint(:,2,:),3);
mean_fixedpoint=[mean_fixedpoint_x,mean_fixedpoint_y];
%% determining period
load('150629_4_4_pro_tip.mat');
z=coordinates(:,2);
[pk,loc]=findpeaks(abs(z-nanmean(z)),'MinPeakHeight',40);
stance_begin=loc;
%% start simulation
%for i=1:(length(stance_begin)-1)
for i=1:1
    period=(stance_begin(i+1)-stance_begin(i))/87;
    %period=round(period,2);
    period=0.37;
    framenumber=[stance_begin(i):stance_begin(i+1)];
    frame=linspace(stance_begin(i),stance_begin(i+1));
    ytemp=mean_fixedpoint(stance_begin(i):stance_begin(i+1),:);
    yexp(:,1)=(interp1(framenumber,ytemp(:,1)',frame));
    yexp(:,2)=(interp1(framenumber,ytemp(:,2)',frame));
    time=linspace(-period/2,period/2);
    time=time';
    
g=1000;
%L=0.22;
M=0.001;
for j=1:200
    L=0.10+0.001*j; % in units of cm
    gamma1=g/L;
for h=1:100
    B=0.15+h*.001;
    gamma2=B/(M*L*L);
    for k=1:100
        omega=0.01+0.01*(k-1);
ode = @(t,y) slasm(t,y,gamma1, gamma2); [t,y] = ode45(ode,[0 0.15],[0; omega]); % y is a 2D vector y(1) is Z and y(2) is x
[tfwd,thetafwd] = ode45(ode,[0 time(end)],[0; omega]); % first square bracket is the time range, second is initial condition
[trev,thetarev] = ode45(ode,[0 time(1)],[0; omega]);
trev=flip(trev); trev=trev(1:end-1);
thetarev=flip(thetarev,1); thetarev=thetarev(1:end-1,:);
tsim=[trev;tfwd];
thetasim=[thetarev;thetafwd];
thetasim_interp(:,1)=interp1(tsim,thetasim(:,1),time);
thetasim_interp(:,2)=interp1(tsim,thetasim(:,2),time);
data.theta=thetasim_interp;
% M can be measured. L & the initial and final value of time can be determined by looking at the averages. 
% One would then need to vary omega & B systematically. 
plot(time,L*cos(thetasim_interp(:,1)),'-',time,L*sin(thetasim_interp(:,1)),'--'); % L cos =y; Lsin=x
plot(t,L*cos(y(:,1)),'-',t,L*sin(y(:,1)),'--')
ysim(:,1)=L*cos(thetasim_interp(:,1));
ysim(:,2)=L*sin(thetasim_interp(:,1));
data.ysim(:,:,h,j,k)=ysim;
data.L(h,j,k)=L;
data.omega(h,j,k)=omega;
 score_x=ysim(:,2)-yexp(:,1);
 score_x=sum(score_x.^2)/length(ysim);
 score_z=ysim(:,1)-yexp(:,2);
 score_z=sum(score_z.^2)/length(ysim);
 data.score(h,j,k)=score_x+score_z;
 
    end
end
end
end
data.yexp=yexp;
data.time=time;
save(datafilename, 'data');