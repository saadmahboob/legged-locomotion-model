% This program uses function slasm
%% load data for COM evolution
load('150629_fixedpoint.mat');
filename = '150629_4_4.avi';
datafilename = strcat('G_', filename(1:10));
%% conversion to cms
% to do - incorporate an if loop to ask whether pixel-to-cm exists
if exist('pixel_to_cm', 'var') == 0
video = VideoReader(filename);
image=read(video,80);
imshow(image);
[x,y]=ginput(2);
dist=sqrt((x(1)-x(2))^2+(y(1)-y(2))^2);
pixel_to_cm = 0.3/dist;
end
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
for j=1:150
    L=0.15+0.001*j; % in units of cm
    gamma1=g/L;
    for k=1:100
        omega=0.1+0.1*k;
ode = @(t,y) slgrav(t,y,gamma1); % y is a 2D vector y(1) is Z and y(2) is x
[tfwd,yfwd] = ode45(ode,[0 time(end)],[0; -omega]); % first square bracket is the time range, second is initial condition
[trev,yrev] = ode45(ode,[0 time(1)],[0; -omega]);
trev=flip(trev); trev=trev(1:end-1);
yrev=flip(yrev,1); yrev=yrev(1:end-1,:);
tsim=[trev;tfwd];
ysim=[yrev;yfwd];
ysim_interp(:,1)=interp1(tsim,ysim(:,1),time);
ysim_interp(:,2)=interp1(tsim,ysim(:,2),time);
% M can be measured. L & the initial and final value of time can be determined by looking at the averages. 
% One would then need to vary omega & L systematically. 
plot(time,L*cos(ysim_interp(:,1)),'-',time,L*sin(ysim_interp(:,1)),'--');
plot(time, L);
plot(time, omega);
data.ysim(:,:,j,k)=ysim_interp;
data.L(j,k)=L;
 score_x=ysim_interp(:,2)-yexp(:,1);
 score_x=sum(score_x.^2)/length(ysim_interp);
 score_z=ysim_interp(:,1)-yexp(:,2);
 score_z=sum(score_z.^2)/length(ysim_interp);
 data.score(j,k)=score_x+score_z;
 %display(j);display(k);
    end
end
end
save(datafilename, 'data');
