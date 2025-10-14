function yn1 = runge_kutta2(yn,h,r)%fonction runge kutta on change juste la fonction f
k1= f(yn,r);
k2 = f(yn + (h/2)*k1,r);
k3 = f(yn + (h/2)*k2,r);
k4 = f(yn + h*k3,r);
yn1 = yn +(h/6)*(k1 +2*k2 +2*k3 + k4);
end

function vitesse = f(position,r) %renvoie u et v 
b = 8/3;
x = position(1);
z = position(2);
vitesse = [u_derz(x,z,r,b); v_derx(x,z,r,b)];
end 

