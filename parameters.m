clc;
close all;
clear all;

global a0m a1m x
countn = 100000

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

sys_act=tf(num1,den1);
xe = 1:0.1:101;
ue_alpha = interp1(u_alpha,xe);
ue_c = interp1(u_c,xe);

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
