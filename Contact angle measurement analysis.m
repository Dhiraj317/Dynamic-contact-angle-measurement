% matlab script for processing data

clear all            % clear all variables

load data.csv     % load data file

sample='Plain glass';%use the appropriate name of your sample
start=1;

% define parameters
rhow=1000;            %kg/m^3 density of water
g=9.8;               % gravity
st=0.0725;  %surafce tension of water and air
width=25.4*1e-3; %Convert mm to m--Enter the width of your substrate
thick=3.17*1e-3; %Convert mm to m--Enter the thickness of your substrate
per= 2*(width+thick); %perimeter of substrate

% awateroilssing matrix of values to studied variables
t= data(start:end,1);
cycle= data(start:end,2);
direc= data(start:end,3);
x=data(start:end,6)*1e-3;         % position in m
f= data(start:end,5)*1e-3;         % force in m
v= data(start:end,7)*1e-3/60;      % speed converted to m/s

N=size(x,1);              % sample size
%removing buoyancy force
fb=rhow*g*width*thick*x;      % buoyancy force=density*gravity*volume
f1=f+fb;                      % remove buoyancy force

va=min(v);
vr=max(v);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute average per cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%change below values for your data analysis
x1a=3e-3;%Advancing starting position
x2a=5e-3;%Advancing ending position
x1r=1e-3;%Receding starting position
x2r=3e-3;%Receding ending position

% zero mean force arrays
fa(1:max(cycle))=0;Na(1:max(cycle))=0;
fr(1:max(cycle))=0;Nr(1:max(cycle))=0;
for i=1:N;


if (direc(i)<0);
    if ( x(i)>x1a) && (x(i)<x2a);
fa(cycle(i))=fa(cycle(i))+f1(i);
Na(cycle(i))=Na(cycle(i))+1;
    end
end

if (direc(i)>0);
     if ( x(i)>x1r) && (x(i)<x2r);
fr(cycle(i))=fr(cycle(i))+f1(i);
Nr(cycle(i))=Nr(cycle(i))+1;
end
end


end

fa=fa./Na;
fr=fr./Nr;

start=10500;
% raw data
hf1=figure(1);
plot(x(start:end),f(start:end),'r-')
xlabel('Immersion depth(mm)')
ylabel('Force(N)')
title('rawdata')
set(gca,'Fontsize',24,'Fontweight','bold','fontname','times new roman')
grid on;
hold on;
saveas(hf1,[sample,'-raw_data.svg'],'svg')



hf2=figure(2);
plot(x(start:end),f1(start:end),'k')
xlabel('Immersion depth(mm)','Fontsize',16)
ylabel('Raw force-Buoyancy','Fontsize',16)
title('Capillary Force(N) vs time','Fontsize',16)
set(gca,'Fontsize',24,'Fontweight','bold','fontname','times new roman')
grid on;
hold on;                    % this allows to overlay plots


line([0 max(x)],[mean(fa) mean(fa)])
line([0 max(x)],[mean(fr) mean(fr)])
saveas(hf2,[sample,'-fb.svg'],'svg')

fmax=st*per;
theta=real(acos((f1)/fmax)*180/pi);

hf3=figure(3);
plot(x(start:end),theta(start:end),'k')
xlabel('Immersion depth (m)','Fontsize',16)
ylabel('contact angle','Fontsize',16)
title('Contact angle vs depth','Fontsize',16)
set(gca,'Fontsize',24,'Fontweight','bold','fontname','times new roman')
grid on;
hold on; 
saveas(hf3,[sample,'-contact angle.svg'],'svg')% this allows to overlay plots


%fa=fa(2:end);
%fr=fr(2:end);

teta=real(acos((fa)/fmax)*180/pi);% Advancing contact angle values
tetr=real(acos((fr)/fmax)*180/pi);% Receding contact angle values
Hysteresis=teta-tetr;


hf4=figure(4);
subplot(3,1,1)
plot(teta,'ok-')
ylabel('\theta_A')
title('insert title')
legend('advancing per cycle')
set(gca,'Fontsize',24,'Fontweight','bold','fontname','times new roman')
subplot(3,1,2)
plot(tetr,'sr-')
ylabel('\theta_R')
title('insert title')
legend('receading per cycle')
set(gca,'Fontsize',24,'Fontweight','bold','fontname','times new roman')
subplot(3,1,3)
plot(Hysteresis,'sg-')
ylabel('Hysteresis')
set(gca,'Fontsize',24,'Fontweight','bold','fontname','times new roman')
legend('hysteresis per cycle')
saveas(hf4,[sample,'-fig4.png'],'png')
%}
