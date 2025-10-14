function u = u_derz(x,z,r,b) %calcule u à partir de la dérivée de psi (dérivée par rapport à z)
Xo = sqrt(b*(r - 1));
q = pi/sqrt(2);
u = Xo*pi*sin(pi*z).*sin(q*x);
end