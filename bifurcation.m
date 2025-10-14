function diagramme = bifurcation(pas,N)
%le paramètre pas permet de discrétiser l'intervalle [0,30] de r
pas = 1;
N = 40; %le nombre des derniers points qu'on garde

%on construit la liste des abscisses pour 0-30:
abscisses_r1 = zeros(1,N);
for i=pas:pas:30
    abscisses_r1 = cat(2,abscisses_r1, i*ones(1,N));
end

%on construit la liste des ordonnées pour 0-30:
liste = simulation(0);
ordonnes_x1 = liste(1,size(liste,2)-(N-1):size(liste,2));
for r=pas:pas:30
    liste = simulation(r);
    ordonnes_x1 = cat(2,ordonnes_x1,liste(1,size(liste,2)-(N-1):size(liste,2)));
end


%La valeur rc à partir de laquelle s'instaure un régime chaotique est rc =
%23

%on construit la liste des abscisses pour 30-350:
abscisses_r2 = zeros(1,N);
for i=(30+pas):pas:350
    abscisses_r2 = cat(2,abscisses_r2, i*ones(1,N));
end

%on construit la liste des ordonnées pour 30-350 piur Zk:
liste = simulation(30);
Zk = findpeaks(liste(3,:));
ordonnes_x2 = Zk(1,size(Zk,2)-(N-1):size(Zk,2)) -r*ones(1,N); %pour enlever r à chaque Zk (s'affranchir des grandes variations de r)

for r=(30+pas):pas:350
    liste = simulation(r);
    Zk = findpeaks(liste(3,:));
    ordonnes_x2 = cat(2,ordonnes_x2,Zk(1,size(Zk,2)-(N-1):size(Zk,2))-r*ones(1,N));
end

%on trace de 0 à 30 et de 30 à 350 sur un même graphe :

abscisses_r1=cat(2,abscisses_r1,abscisses_r1);
ordonnes_x1=cat(2,ordonnes_x1,-ordonnes_x1);
abscisses_r2=cat(2,abscisses_r2,abscisses_r2);
ordonnes_x2=cat(2,ordonnes_x2,-ordonnes_x2);

scatter(abscisses_r1,ordonnes_x1);
hold on
scatter(abscisses_r2,ordonnes_x2);
xlabel("valeur de r");
ylabel("valeur de X (r<rc) et Zk (r>rc)");
title("Diagramme de bifurcation");


