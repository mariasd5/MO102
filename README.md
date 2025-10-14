# MO102 – Étude numérique de la convection de Rayleigh–Bénard

Auteurs : Maria Saad, Marie Chalons  
Langage : MATLAB  
Projet académique – ENSTA Paris

## Objectif

Ce projet a pour objectif de modéliser les phénomènes de convection de Rayleigh–Bénard, qui décrivent les mouvements d’un fluide chauffé par le bas et refroidi par le haut.  
Lorsque la différence de température dépasse une valeur critique, le régime du fluide passe d’une conduction stable à une convection ordonnée, puis à un comportement instationnaire et chaotique.  

Nous cherchons à reproduire numériquement cette transition à l’aide du système de Lorenz, un modèle réduit représentant la dynamique des cellules de convection.

## Contexte physique

Le système de Rayleigh–Bénard correspond à un problème de mécanique des fluides où les effets de flottabilité induits par un gradient de température provoquent l’apparition de structures convectives.  
Lorenz (1963) a proposé une simplification de ce système sous la forme d’un ensemble de trois équations différentielles non linéaires :

$$
\begin{aligned}
\dot{X} &= \sigma (Y - X) \\
\dot{Y} &= rX - Y - XZ \\
\dot{Z} &= XY - bZ
\end{aligned}
$$

avec :

- $ \sigma $ : nombre de Prandtl  
- $ r $ : paramètre de Rayleigh réduit  
- $ b $ : paramètre géométrique


Ce système présente un comportement déterministe mais non prédictible à long terme pour certaines valeurs de \( r \).  
Il constitue l’un des exemples classiques de chaos déterministe.

## Implémentation numérique

L’étude a été réalisée en MATLAB.  
Les équations de Lorenz ont été intégrées numériquement à l’aide de la méthode de Runge–Kutta d’ordre 4.  
Différentes valeurs du paramètre \( r \) et des conditions initiales ont été explorées pour mettre en évidence les transitions de régime et la sensibilité du système.

### Structure du code

| Fichier | Description |
|----------|-------------|
| `projet_final.m` | Script principal regroupant les simulations, les visualisations et le calcul du diagramme de bifurcation. |
| `simulation_lorentz.m` | Intégration temporelle du système de Lorenz. |
| `runge_kutta.m` | Implémentation de la méthode de Runge–Kutta (ordre 4). |
| `runge_kutta2.m` | Variante pour l’étude d’un champ de vitesse à deux composantes. |
| `u_derz.m`, `v_derx.m` | Calcul des composantes de la vitesse dérivées d’une fonction de courant. |
| `temperature.m` | Définition du champ de température. |
| `bifurcation.m` | Génération du diagramme de bifurcation (version à corriger légèrement). |

## Méthodes numériques

- Intégration temporelle : méthode d’Euler d’ordre 2 et méthode de Runge–Kutta d’ordre 4.  
- Analyse qualitative : étude de la stabilité, sensibilité aux conditions initiales et observation des trajectoires.  
- Représentation graphique : tracés 2D et 3D des champs de température, de vorticité et des attracteurs.  
- Diagramme de bifurcation : représentation des valeurs asymptotiques atteintes par le système en fonction de \( r \).

## Résultats

L’étude met en évidence trois régimes principaux :

- Pour \( r < 1 \) : conduction pure (état stable, absence de mouvement).  
- Pour \( 1 < r < 30 \) : convection stationnaire (deux points d’équilibre stables).  
- Pour \( r > 30 \) : convection chaotique (trajectoires apériodiques et sensibilité extrême aux conditions initiales).

Une faible variation des conditions initiales, même de l’ordre de \( 10^{-3} \), conduit à des trajectoires divergentes, illustrant la nature chaotique du système.

## Exemple d’exécution

```matlab
r = 28;                % paramètre de Rayleigh réduit
y0 = [1; 1; 1];        % conditions initiales
dt = 0.01; 
t = 0:dt:50;

res = simulation_lorentz(r, y0, t, dt);

figure
plot3(res(1,:), res(2,:), res(3,:), 'LineWidth', 1)
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
title(sprintf('Attracteur de Lorenz (r = %.2f)', r))
