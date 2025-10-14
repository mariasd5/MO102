clear all;
 

%% INITIALISATION DES VARIABLES DU PROBLÈME

Pr = 10;
b = 8/3;
r = 10;
Xo = sqrt(b*(r - 1)); %conditions initiales de X,Y et Z
Yo = sqrt(b*(r - 1)); 
Zo = r-1;
q = pi/sqrt(2);
pas_maillage = 0.025; %mettre une bonne résolution via le pas
x = [-2*pi/q:pas_maillage:2*pi/q]; %résolution du maillage selon x
z = [-1/2:pas_maillage:1/2]; %selon z

dt = 0.01; %pas de discrétisation temporelle pour integrer avec runge kutta yn 
T = 100; % durée totale de "simulation"
t = [0:dt:T]; % dicrétisation du temps
X0 = 5; %conditions initiales du système de Lorentz
Y0 = 0;
Z0 = 13;
yn = [X0;Y0;Z0];
pas = 0.5; 

pas_bifurcation = 1; %le paramètre pas_bifurcation permet de discrétiser l'intervalle [0,30] de r
N = 40; %le nombre des derniers points qu'on garde pour la bifurcation

dt_reconst = 0.0001;    %pas de temps choisi pour la partie de la recontruction des mouvements du fluide
T_reconst = 1;          %idem 



%% DEFINITION DU MAILLAGE + CALCUL DES VITESSES ET DE LA VORTICITÉ

[X,Z] = meshgrid(x,z); %ca definit le maillage : X contient les x de tlm et Z les z de tous les points du maillage
u = u_derz(X,Z,r,b); %on calcule les vitesses (cf fichiers des fonctions u_derz et v_derx)
v = v_derx(X,Z,r,b);
V = [u v];
W = curl(X,Z,u,v); %ça calcule le rotationel de V

%On définit la temperature teta :

teta = Yo*cos(pi*z)*cos(q*x(1)) + Zo*sin(2*pi*z);
for i=2:length(x)
    teta= [teta;Yo*cos(pi*z)*cos(q*x(i))+Zo*sin(2*pi*z)];
end

%% AFFICHAGE DES GRANDEURS

tiledlayout (1,2)

nexttile

pcolor(X,Z,W); %pour W (attention 3 arguments)
shading interp;
c = colorbar;
c.Label.String = "Vorticity(s^-1)";
hold on;
quiver(X,Z,u,v,'k'); %sert à rajouter les flèches
xlabel("x(m)");
ylabel("z(m)");
title("Champ de vorticité dans la couche fluide");

nexttile

pcolor(X,Z,teta');
shading interp;
c = colorbar;
c.Label.String = "Température relative de convection (K)";
hold on;
quiver(X,Z,u,v,'k'); %sert à rajouter les flèches
xlabel("x(m)");
ylabel("z(m)");
title("Écart de température par rapport à la situation de conduction pure ");

%% ÉTUDE DES DYNAMIQUES ENGENDRÉES PAR LE SYSTÈME DE LORENTZ: MISE EN ÉVIDENCE DES DIFFÉRENTS RÉGIMES
r1 = 10;
r2 = 28; %régime chaotique
resultat1 = simulation_lorentz(r1,yn,t,dt);
resultat2 = simulation_lorentz(r2,yn,t,dt);

figure %on trace les resultats recensés dans la matrice res (ie les coordonnées X,Y et Z des yn)
plot(t,resultat1(2,:))  %par souci de lisibilité on ne trace que les coordonnées Y
xlabel("Temps","Fontsize",24);
ylabel("Coordonnées X(t),Y(t),Z(t)","Fontsize",24);
hold on 
plot(t,resultat2(2,:))
%% ÉTUDE DES DYNAMIQUES ENGENDRÉES PAR LE SYSTÈME DE LORENTZ: SENSIBILITÉ AUX CONDITIONS INITIALES

Zk1 = findpeaks(resultat1(3,:));
Zk2 = findpeaks(resultat2(3,:));
figure
scatter(Zk1(1:size(Zk1,2)-1),Zk1(2:size(Zk1,2)))
xlabel("Zk");
ylabel("Zk+1");
hold on 
scatter(Zk2(1:size(Zk2,2)-1),Zk2(2:size(Zk2,2)))


%% DIAGRAMME DE BIFURCATION 

%% CALCUL POUR 0<=r<30
%le paramètre pas permet de discrétiser l'intervalle [0,30] de r

%on construit la liste des abscisses pour 0-30:
abscisses_r1 = zeros(1,N);
for i=pas_bifurcation:pas_bifurcation:30
    abscisses_r1 = cat(2,abscisses_r1, i*ones(1,N));
end

%on construit la liste des ordonnées pour 0-30:
liste = simulation_lorentz(0,yn,t,dt);
ordonnes_x1 = liste(1,size(liste,2)-(N-1):size(liste,2));
for r=pas_bifurcation:pas_bifurcation:30
    liste = simulation_lorentz(r,yn,t,dt);
    ordonnes_x1 = cat(2,ordonnes_x1,liste(1,size(liste,2)-(N-1):size(liste,2)));
end


%La valeur rc à partir de laquelle s'instaure un régime chaotique est rc =
%23

%% CALCUL POUR 30<=r<350

%on construit la liste des abscisses pour 30-350:
abscisses_r2 = zeros(1,N);
for i=(30+pas_bifurcation):pas_bifurcation:350
    abscisses_r2 = cat(2,abscisses_r2, i*ones(1,N));
end

%on construit la liste des ordonnées pour 30-350 piur Zk:
liste = simulation_lorentz(30,yn,t,dt);
Zk = findpeaks(liste(3,:));
ordonnes_x2 = Zk(1,size(Zk,2)-(N-1):size(Zk,2)) -r*ones(1,N); %pour enlever r à chaque Zk (s'affranchir des grandes variations de r)

for r=(30+pas_bifurcation):pas_bifurcation:350
    liste = simulation_lorentz(r,yn,t,dt);
    Zk = findpeaks(liste(3,:));
    ordonnes_x2 = cat(2,ordonnes_x2,Zk(1,size(Zk,2)-(N-1):size(Zk,2))-r*ones(1,N));
end


%% ON TRACE SUR UN MEME GRAPHE LES DEUX CAS:

abscisses_r1=cat(2,abscisses_r1,abscisses_r1);
ordonnes_x1=cat(2,ordonnes_x1,-ordonnes_x1);   %pour tracer le symétrique 
abscisses_r2=cat(2,abscisses_r2,abscisses_r2);
ordonnes_x2=cat(2,ordonnes_x2,-ordonnes_x2);     %pour tracer le symétrique 

figure

scatter(abscisses_r1,ordonnes_x1);
hold on
scatter(abscisses_r2,ordonnes_x2);
xlabel("valeur de r");
ylabel("valeur de X (r<rc) et Zk (r>rc)");
title("Diagramme de bifurcation");


%% RECONSTRUCTION DES MOUVEMENTS AU SEIN DU FLUIDE 

%% MÉTHODE D'INTÉGRATION EULER EXPLICITE (ORDRE 2)
 % on contruit deux listes pour les coordonnées x et z d'une particule de
 % fluide
trajectoire_xe = zeros(1,T_reconst/dt_reconst+1);
trajectoire_ze = zeros(1,T_reconst/dt_reconst+1);

trajectoire_xe (1) = 0.5;   % on initialise
trajectoire_ze (1) = 0;     % idem 

%on applique la méthode d'Euler 
for i = 2 : T_reconst/dt_reconst+1 
    u = u_derz(trajectoire_xe(i-1),trajectoire_ze(i-1),r,b);
    v = v_derx(trajectoire_xe(i-1),trajectoire_ze(i-1),r,b);
    trajectoire_xe(i) = trajectoire_xe(i-1) + dt_reconst*u;
    trajectoire_ze(i) = trajectoire_ze(i-1) + dt_reconst*v;
end 


%% MÉTHODE D'INTÉGRATION RUNGE KUTTA (ORDRE 4)

trajectoire_xrk = zeros(1,T_reconst/dt_reconst+1);
trajectoire_zrk = zeros(1,T_reconst/dt_reconst+1);

yn=[0.5;0];  %condition initiale (besoin d'introduire un vecteur pour appliquer la fonction runge_kutta2)
trajectoire_xrk(1) = yn(1);     %on initialise pour x
trajectoire_zrk(1) = yn(2);     % idem pour z
u = u_derz(yn(1),yn(2),r,b);    % on calcule les vitesses initiales 
v = v_derx(yn(1),yn(2),r,b);

for i = 2 :  T_reconst/dt_reconst+1 
    position = runge_kutta2(yn,dt_reconst,r);
    trajectoire_xrk(i) =  position(1);
    trajectoire_zrk(i) =  position(2);
    yn = position; 
end 


%% ON TRACE 
figure
plot(trajectoire_xe, trajectoire_ze);
title("trajectoire euler de z en fonction de x");  %on constate qu'il y aune erreur car c'est une
%spirale, ce qui n'est pas représentatif d'une convection, qui est une trajectoire fermée

hold on 

plot(trajectoire_xrk, trajectoire_zrk);
title("trajectoire runge kutta de z en fonction de x");




