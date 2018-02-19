clear all
close all

m2ft = 3.28084;
ft2m = 1/m2ft;
% table = readtable('traj.csv');
filename = 'traj.csv';
try
    traj_out = csvread(filename);    
catch
    traj_out = csvread(filename,1,0);
end
    
% if(isstring(table(,0)))
%     traj_out = csvread('traj.csv',1,0);
% else
%     traj_out = csvread('traj.csv');
% end

%Read file




% Retreive values
left_x     = traj_out(:,1);%*m2ft;
left_y     = traj_out(:,2);%*m2ft;
right_x    = traj_out(:,3);%*m2ft;
right_y    = traj_out(:,4);%*m2ft;
left_pos   = traj_out(:,5);%*m2ft;
right_pos  = traj_out(:,6);%;%*m2ft;
left_vel   = traj_out(:,7);%*m2ft;
right_vel  = traj_out(:,8);%*m2ft;
left_acc   = traj_out(:,9);%*m2ft;
right_acc  = traj_out(:,10);%*m2ft;
left_jerk  = traj_out(:,11);%*m2ft;
right_jerk = traj_out(:,12);%*m2ft;
left_dt    = traj_out(:,13);%*m2ft;
right_dt   = traj_out(:,14);%*m2ft;
left_t     = traj_out(:,15);%zeros(size(left_dt));
right_t    = traj_out(:,16);%zeros(size(right_dt));
angle_deg  = traj_out(:,17);



%Get time vector
% for(i=[2:length(left_dt)])
%     left_t(i) = left_t(i-1) + left_dt(i);
%     right_t(i) = right_t(i-1) + right_dt(i);
% end

%draw back and front of robot at the beginning and end of the trajectory
robotWidth  = ((33+5)/12)*ft2m; %m
robotLength = ((28+5)/12)*ft2m; %m

if(right_pos(end) < 0 && left_pos(end) < 0)
    directionText = 'BACKWARD';
    robotEndMult  = -1;
else
    directionText = 'FORWARD';
    robotEndMult  = 1;
end

left_x0  = left_x(1)   -robotEndMult*(robotLength/2 * cosd(angle_deg(1)));
left_y0  = left_y(1)   -robotEndMult*(robotLength/2 * sind(angle_deg(1)));
right_x0 = right_x(1)  -robotEndMult*(robotLength/2 * cosd(angle_deg(1)));
right_y0 = right_y(1)  -robotEndMult*(robotLength/2 * sind(angle_deg(1)));
left_xf  = left_x(end) +robotEndMult*(robotLength/2 * cosd(angle_deg(end)));
left_yf  = left_y(end) +robotEndMult*(robotLength/2 * sind(angle_deg(end)));
right_xf = right_x(end)+robotEndMult*(robotLength/2 * cosd(angle_deg(end)));
right_yf = right_y(end)+robotEndMult*(robotLength/2 * sind(angle_deg(end)));


h1=figure();
plot([left_x0 left_x' left_xf],[left_y0 left_y' left_yf])
hold on
plot([right_x0 right_x' right_xf],[right_y0 right_y' right_yf])
%diagonal corners
plot(ft2m.*[0 2+(11.0/12)], ft2m.*[-11 -13.5])
plot(ft2m.*[0 2+(11.0/12)], ft2m.*[11 13.5])
%scale plates
plot(ft2m.*[25,29,29,25,25], ft2m.*[4.5,4.5,7.5,7.5,4.5])
plot(ft2m.*[25,29,29,25,25], ft2m.*-1*[4.5,4.5,7.5,7.5,4.5])
%platform
plot(ft2m.*[22,26.5,26.5,22,22],ft2m.*[5.5,5.5,-5.5,-5.5,5.5])
%null territory
plot(ft2m.*[24,30,30,24,24],ft2m.*[5.5625,5.5625,13.5,13.5,5.5625])
plot(ft2m.*[24,30,30,24,24],ft2m.*-1*[5.5625,5.5625,13.5,13.5,5.5625])
%switchplates
plot(ft2m.*[12,16,16,12,12], ft2m.*[3,3,6,6,3])
plot(ft2m.*[12,16,16,12,12], ft2m.*-1*[3,3,6,6,3])
plot(ft2m.*[12,16,16,12,12], ft2m.*-1*[-6,-6,6,6,-6])
plot(ft2m.*[16,17+(1.0/12),17+(1.0/12),16,16], ft2m.*[4+(11.0/12),4+(11.0/12),6,6,4+(11.0/12)])
plot(ft2m.*[16,17+(1.0/12),17+(1.0/12),16,16], ft2m.*-1*[4+(11.0/12),4+(11.0/12),6,6,4+(11.0/12)])

%exchange zone
plot(ft2m.*[0,3,3,0,0],ft2m.*[1.25,1.25,5.25,5.25,1.25])

%cube zone
plot(ft2m.*[8.25,12,12,8.25,8.25], ft2m.*[-1.875,-1.875,1.875,1.875,-1.875])
plot(ft2m.*[12-(1+(1.0/12)),12,12,12-(1+(1.0/12)),12-(1+(1.0/12))], ft2m.*[-(6.5/12),-(6.5/12),(6.5/12),(6.5/12),-(6.5/12)])
plot(ft2m.*[12-(1+(1.0/12)),12,12,12-(1+(1.0/12)),12-(1+(1.0/12))], ft2m.*[(6.5/12),(6.5/12),(19.5/12),(19.5/12),(6.5/12)])
plot(ft2m.*[12-(1+(1.0/12)),12,12,12-(1+(1.0/12)),12-(1+(1.0/12))], ft2m.*-1*[(6.5/12),(6.5/12),(19.5/12),(19.5/12),(6.5/12)])
plot(ft2m.*[12-2*(1+(1.0/12)),12-(1+(1.0/12)),12-(1+(1.0/12)),12-2*(1+(1.0/12)),12-2*(1+(1.0/12))],ft2m.*[0,0,13.0/12,13.0/12,0])
plot(ft2m.*[12-2*(1+(1.0/12)),12-(1+(1.0/12)),12-(1+(1.0/12)),12-2*(1+(1.0/12)),12-2*(1+(1.0/12))],ft2m.*[0,0,-13.0/12,-13.0/12,0])
plot(ft2m.*[12-3*(1+(1.0/12)),12-2*(1+(1.0/12)),12-2*(1+(1.0/12)),12-3*(1+(1.0/12)),12-3*(1+(1.0/12))],ft2m.*[-(6.5/12),-(6.5/12),(6.5/12),(6.5/12),-(6.5/12)])

% plot()
xlim(ft2m.*[0 54])
ylim(ft2m.*[-13.5 13.5])
title({"Path on Field", strcat(directionText, " Trajectory")})
ylabel("Alliance station (meters)")
xlabel("(meters)")
legend('left wheel (not bumper edge)', 'right wheel (not bumper edge)')
pbaspect([2 1 1])
movegui(h1,'west')

h2=figure();
subplot(5, 1, 1)
plot(left_t, left_pos); hold on; plot(right_t, right_pos)
ylabel('Position (ft)')
title('Timed info')
legend('left', 'right')
subplot(5, 1, 2)
plot(left_t, left_vel); hold on; plot(right_t, right_vel)
ylabel('Velocity (ft/s)')
subplot(5, 1, 3)
plot(left_t, left_acc); hold on; plot(right_t, right_acc)
ylabel('Acceleration (ft/s/s)')
subplot(5, 1, 4)
plot(left_t, left_jerk); hold on; plot(right_t, right_jerk)
ylabel('Jerk (ft/s/s)')
xlabel('Time (sec)');
movegui(h2,'east')

% h3 = figure();
subplot(5, 1, 5)
plot(left_t, angle_deg)
xlabel('Time (sec)');
ylabel('Angle (deg)')
% movegui(h3,'southwest')