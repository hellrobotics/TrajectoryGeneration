clear all
close all

m2ft = 3.28084;
ft2m = 1/m2ft;

%Read file
traj_out = csvread('traj.csv');

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

h1=figure();
plot(left_x,left_y)
hold on
plot(right_x,right_y)
xlim([0 54])
ylim([-27 27])
title("Path on Field")
ylabel("Alliance station (feet)")
xlabel("(feet)")
legend('left', 'right')
movegui(h1,'north')

h2=figure();
subplot(4, 1, 1)
plot(left_t, left_pos); hold on; plot(right_t, right_pos)
ylabel('Position (ft)')
title('Timed info')
legend('left', 'right')
subplot(4, 1, 2)
plot(left_t, left_vel); hold on; plot(right_t, right_vel)
ylabel('Velocity (ft/s)')
subplot(4, 1, 3)
plot(left_t, left_acc); hold on; plot(right_t, right_acc)
ylabel('Acceleration (ft/s/s)')
subplot(4, 1, 4)
plot(left_t, left_jerk); hold on; plot(right_t, right_jerk)
ylabel('Jerk (ft/s/s)')
xlabel('Time (sec)');
movegui(h2,'southeast')

h3 = figure();
plot(left_t, angle_deg)
xlabel('Time (sec)');
ylabel('Angle (deg)')
movegui(h3,'southwest')


