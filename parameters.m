clc;
close all;
clear all;

global U a b asck mu_alpha mu_c count tp pwd xddot a0m a1m
global r e_plant epid epiddot epidddot x xdot uintegrate
tp = 1000
pwd = 1000
count = 70000
countn = 100000

%tuning parameters
%MSD
% gamma_kp=18;
% gamma_ki=50;
% gamma_kd=0.0001;

%SLV for adaptive law as in paper
% gamma_kp=35;
% gamma_ki=15;
% gamma_kd=5;

% gamma_kp=0.001;
% gamma_ki=2;
% gamma_kd=15;

% gamma_kp=25;
% gamma_ki=10.5;
% gamma_kd=3;

gamma_kp=500;
gamma_ki=20;
gamma_kd=100;

kpp=5;
kip=10;
kdp=1;
kpi=5;
kii=10;
kdi=1;
kpd=5;
kid=10;
kdd=1;

%paramters for modified adaptive laws
% gamma_kp=500;
% gamma_ki=1;
% gamma_kd=100;

%%%actual model
%second order system
%  Ts1  = 0.5;        % settling time for actual model
%  z1   = 2;     % damping ratio for actual model
%  omega1 = 4/(Ts1*z1);
% a = 2*z1*omega1;
% b = omega1^2;
% num1 = b;
% den1 = [1 a b];

%mass spring damper system
% asck=1%2*cos(2*t);   % 1 N/m
% adpc=0.4%16;   % 0.2 Ns/m
% amass=0.0125 %1 ;%1 kg
% aomega = sqrt(asck/amass)
% az = adpc/(2*sqrt(asck*amass))
% aTs = 4/(aomega*az)
% a = 2*az*aomega;
% b = aomega^2;
% num1 = b/asck;
% den1 = [1 a b];
% figure
% sys_act=tf(num1,den1);
% step(sys_act)

% a=10
% b=25
% num1 = b;
% den1 = [1 a b];

%satellite launch vehicle
u_alpha =[0 0.1 0.8 2.2 2.8 5 5 4.5 2.9 1.6 1]
u_c     =[4.2 5  6.1 6.2 5.5 5.4 5.3 5.8 6.5 7 7.2]

[m1,n1]=size(u_alpha)
x = 0:1:n1;
%Define the query points to be a finer sampling over the range of x.

xq = 1:(1/(countn/10)):11;
%Interpolate the function at the query points and plot the result.

vq1_alpha = interp1(u_alpha,xq);
tvq1_alpha=timeseries(vq1_alpha)
vq2_c = interp1(u_c,xq);
p = 0;
q = -vq1_alpha(200);
num1 = vq2_c(200);
den1 = [1 p q];

figure
sys_act=tf(num1,den1);
step(sys_act);

xe = 1:0.1:101;
ue_alpha = interp1(u_alpha,xe);
ue_c = interp1(u_c,xe);


%reference model
%mass spring damper system
%given settling time and zeta
% Ts  =1 %0.8008;        %Desired settling time for reference model
% z   =0.7%0.1414;     %Desired damping ratio for reference model
% omega = 4/(Ts*z);
% a1m = 2*z*omega;
% a0m = omega^2;
% num2= a0m
% den2 =[1 a1m a0m]
% sys_ref=tf(num2,den2);
% figure
% step(sys_ref)

%satellite launch vehicle
Ts  =1.63 %0.8008;        %Desired settling time for reference model
z   =0.7%0.1414;     %Desired damping ratio for reference model
omega = 4/(Ts*z);
a1m = 2*z*omega;
a0m = omega^2;
a2m = 4;
num2= a0m
den2 =[1 a1m a0m]
sys_ref=tf(num2,den2);

p0m=a0m;
p1m=a1m;
figure
step(sys_ref);
figure
bode(sys_act)
hold on;
bode(sys_ref)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%time step
dt=0.001;
%time
t(1:count)=(0:count-1)*dt;
