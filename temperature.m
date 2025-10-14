function teta = temperature(x,z)
b = 8/3;
q = pi/sqrt(2);
r = 10;
Yo = sqrt(b*(r - 1)); 
Zo = r-1;
teta = Yo*cos(pi*z)*cos(q*x) + Zo*sin(2*pi*z);
end