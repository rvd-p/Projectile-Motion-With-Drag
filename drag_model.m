function [derivatives] = drag_model(t, g, m, k, z)

derivatives    = zeros(length(z), 1);
derivatives(1) = z(2);
derivatives(2) = -(k / m) * sqrt(z(2)^2 + z(4)^2) * z(2);
derivatives(3) = z(4);
derivatives(4) = ((-k / m) * sqrt(z(2)^2 + z(4)^2) * z(4)) -  g;


end

