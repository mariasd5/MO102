function resultat = simulation_lorentz(r,yn,t,dt) %génère la matrice res qui contient les coordonnées X Y 
%et Z issues de l'intégration du système de lorentz par runge kutta

taille_t = length(t);
res = zeros(3, taille_t); %res est la matrice qui va stocker les coordonnées des yn calculés avec runge kutta
res(:,1) = yn;

for i=2:taille_t %on remplit le tableau au fur et à mesure par itération
  yn1 = runge_kutta(yn,dt,r);
  res(:,i) = yn1; %initialisation
  yn = yn1;
end 
  
resultat = res;

end
