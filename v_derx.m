function v = v_derx(x,z,r,b)%calcule v à partir de la dérivée de psi (dérivée par rapport à x)
Xo = sqrt(b*(r - 1)); %ne pas définir à l'ext car la fonction comprend pas ce qui est exterieur à elle
q = pi/sqrt(2);
v = Xo*cos(pi*z).*cos(q*x)*q; %attention à mettre le point pour faire produit non matriciel
end