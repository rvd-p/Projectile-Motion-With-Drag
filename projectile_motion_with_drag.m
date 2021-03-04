close all; clearvars; clc;

%% Specify projectile/launch parameters

cDrag   = 0.45;
radius  = 2.5/100;
area    = pi * radius^2;
m       = 10/1000;
density = 1.224;
g       = 9.81;
k       = 0.5 * cDrag * density * area;
v0      = 60;
theta0  = deg2rad(45);

%% Specify ODE parameters and solve ODE

tSpan   = 0:0.01:50;
z0      = [0; v0 * cos(theta0); 0; v0 * sin(theta0)];
opt     = odeset('Events', @stop_criterion);
[t, Y]  = ode45(@(t,z) drag_model(t, g, m, k, z), tSpan, z0, opt);

%% Define variables to be animated and do plots

kineticEnergy   = 0.5 * m * (Y(:,2).^2 + Y(:,4).^2);
potentialEnergy = m * g * Y(:,3);
totalEnergy     = kineticEnergy + potentialEnergy;

%%% Energy plots   
%   Kinetic and potential energy
figure('Color', 'white')
subplot(2,2,3)
plot(t, [kineticEnergy, potentialEnergy],'LineWidth', 1.75)
L1(1) = line(t(1), kineticEnergy(1),'Color', 'b', 'Marker', '.', ...
                                                         'MarkerSize', 20);
L1(2) = line(t(1), potentialEnergy(1),'Color', '[0.9 0.5 0.2]','Marker', '.', ...
                                                         'MarkerSize', 20);
xlabel('Time [s]')
ylabel('Energy [J]')
xlim([0 1.1*max(t)])
ylim([0 1.1*max(kineticEnergy)])
grid on
title('Energy Variation')
legend('Kinetic Energy', 'Potential Energy', 'Location', 'best')

% Total energy
subplot(2,2,4)
plot(t, totalEnergy, 'Color','[0.133 0.0071 0.1804]','LineWidth', 1.75)
L2 = line(t(1), totalEnergy(1),'Color', 'k',...
                                           'Marker', '.','MarkerSize', 20);
xlabel('Time [s]')
ylabel('Energy [J]')
xlim([0 1.1*max(t)])
ylim([0 1.1*max(totalEnergy)])
grid on
title('Total Energy Variation')

% Position plot
subplot(2, 2, [1,2])
plot(Y(:,1), Y(:,3),'r', 'LineWidth', 1.75)
L3 = line(Y(1,1), Y(1,3), 'Marker', '.', 'MarkerSize', 25, 'Color', 'r'); 
xlabel('x [m]')
ylabel('y [m]')
xlim([0 1.1*max(Y(:,1))])
ylim([0 1.1*max(Y(:,3))])
grid on
title('Position of Projectile')

common_title = sgtitle(sprintf('Time: %0.2f s', t(1)));  

%% Get frame data and update for animation

position = get(gcf, 'Position');
width    = position(3);
height   = position(4);
animation = zeros(height, width, 1, length(t), 'uint8');

for ii = 1:length(t)
    set(L1(1), 'XData', t(ii), 'YData', kineticEnergy(ii))
    set(L1(2), 'XData', t(ii), 'YData', potentialEnergy(ii))
    set(L2, 'XData', t(ii), 'YData', totalEnergy(ii))
    set(L3, 'XData', Y(ii,1), 'YData', Y(ii,3))
    set(common_title, 'String', sprintf('Time: %0.2f s', t(ii)))

    frames = getframe(gcf);
    if ii == 1
        [animation(:,:,1,ii), colour_map] = rgb2ind(frames.cdata, 512,...
                                                              'dither');
    else
        animation(:,:,1,ii) = rgb2ind(frames.cdata, colour_map, 'dither');
    end
end
