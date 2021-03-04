function[value, isterminal, direction] = stop_criterion(t, z)

% Stop ODE when the projectile hits the ground.

value      = z(3)-0; 
isterminal = 1;
direction  = -1; % To stop after the projectile goes downwards.

end