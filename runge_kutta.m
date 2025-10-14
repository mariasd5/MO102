function yn1 = runge_kutta(yn,h,r) %fonction runge kutta
k1= f(yn,r);
k2 = f(yn + (h/2)*k1,r);
k3 = f(yn + (h/2)*k2,r);
k4 = f(yn + h*k3,r);
yn1 = yn +(h/6)*(k1 +2*k2 +2*k3 + k4);
end

function y = f(vect,r) %renvoie les coordonnées X' Y' Z' (systeme de Lorentz)
Pr = 10;
b = 8/3;
y = [Pr*(vect(2)-vect(1)); -vect(1)*vect(3)+r*vect(1)-vect(2);vect(1)*vect(2)-b*vect(3)]; %renvoie uen colonne
end 