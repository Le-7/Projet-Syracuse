#!/bin/bash
main() {
test "$@"      #fonction principale
creation "$@"
}
test(){                          #fonction de test préliminaire
if [ "$1" == "-h" ]; then
 aide                            #on regarde si l'utilisateur a demandé de l'aide (appel a la fonction d'aide)
 exit 0
fi
if [ "$#" -ne 2 ] && ! [ "$1" == "-h" ] ; then
 echo "Le nombre d'arguments est invalide"
 aide                           #on regarde s'il y a bien que 2 arguments
 exit 1
fi
if ! [ "$1" == "-h" ] && ! [[ "$1" =~ ^-?[0-9]+$ ]]; then
 echo "Le premier argument n est pas un entier"
 aide                           #on verifie que les arguments sont bien des entiers
 exit 2
fi
if ! [ "$1" == "-h" ] && ! [[ "$2" =~ ^-?[0-9]+$ ]]; then
 echo "Le second argument n est pas un entier"
 aide
 exit 3
fi
if ! [ "$1" == "-h" ] && [ "$1" -gt "$2" ]; then
 echo "Le premier argument est superieur au second"
 aide                           #si le premier est inférieur au second le programme n'a plus de sens car pas d'intervalle
 exit 4
fi
}

aide(){
echo "******"
echo "*AIDE*"
echo "******"
echo "Veuillez entrer les bornes de vol sous forme de deux entiers compris entre 1 et 4294967295."
echo "Merci de les séparer par un espace." 
echo "N'entrez rien d'autre que des chiffres. Pas de point, pas de virugle ni d'autre caractère."              #fonction d'affichage de l'aide
}

creation(){                     #fonction principale de création des graphiques
gcc Projet.c -o Projet          #on compile le programme en c
mkdir -p resultats              
cd resultats
mkdir -p tmp                    #on crée un dossier temporaire dans le dossier resultats 
cd tmp                          #on se place dedans pour la création des fichiers
x="$1"
y="$2"
echo "Creation des fichiers sources ..."
for (( i=x; i<=y; i++ ))
do ../../Projet "$i" "f$i"                  #boucle de création avec le programme en c
error=$?
if [ "$error" -ne 0 ] ; then  #si une erreur est detectée dans le programme en c on renvoie le code d'erreur
 echo "Probleme dans l'execution du programme en c, code d'erreur = "$error""
 aide
 exit 5
fi
done
touch toto.dat
touch tata.dat
touch titi.dat          #on crée 3 fichiers temporaire pour les différents graphiques
touch synthese-$x-$y.txt  
moy1=0 moy2=0 moy3=0     #declaration des variables pour la synthese
min1=2147483647 min2=2147483647 min3=2147483647     #arbitrairement grande (max d'un int)
max1=0 max2=0 max3=0
for (( i=x; i<=y; i++ ))        #boucle d'eciture dans les 3 fichiers précédents
do 
echo "${i} $(cat 'f'$i'.dat' | tail -1 | grep -Eo '[0-9]{1,}')" >> toto.dat
moy1=$(($(cat 'f'$i'.dat' | tail -1 | grep -Eo '[0-9]{1,}')+$moy1))
if [ $(cat 'f'$i'.dat' | tail -1 | grep -Eo '[0-9]{1,}') -gt $max1 ]; then
 max1=$(cat 'f'$i'.dat' | tail -1 | grep -Eo '[0-9]{1,}')
 #echo "Durée de vol en altitude max = $max1"
elif [ $(cat 'f'$i'.dat' | tail -1 | grep -Eo '[0-9]{1,}') -lt $min1 ]; then
 min1=$(cat 'f'$i'.dat' | tail -1 | grep -Eo '[0-9]{1,}')
 #echo "Durée de vol en altitude min = $min1"
fi
echo "${i} $(cat 'f'$i'.dat' | tail -2 | head -n +1 | grep -Eo '[0-9]{1,}')" >> tata.dat
moy2=$(($(cat 'f'$i'.dat' | tail -2 | head -n +1 | grep -Eo '[0-9]{1,}')+$moy2))
if [ $(cat 'f'$i'.dat' | tail -2 | head -n +1 | grep -Eo '[0-9]{1,}') -gt $max2 ]; then
 max2=$(cat 'f'$i'.dat' | tail -2 | head -n +1 | grep -Eo '[0-9]{1,}')
 #echo "Duree de vol max = $max2"
elif [ $(cat 'f'$i'.dat' | tail -2 | head -n +1 | grep -Eo '[0-9]{1,}') -lt $min2 ]; then
 min2=$(cat 'f'$i'.dat' | tail -2 | head -n +1 | grep -Eo '[0-9]{1,}')
 #echo "Duree de vol min = $min2"
fi
echo "${i} $(cat 'f'$i'.dat' | tail -3 | head -n +1 | grep -Eo '[0-9]{1,}')" >> titi.dat
moy3=$(($(cat 'f'$i'.dat' | tail -3 | head -n +1 | grep -Eo '[0-9]{1,}')+$moy3))
if [ $(cat 'f'$i'.dat' | tail -3 | head -n +1 | grep -Eo '[0-9]{1,}') -gt $max3 ]; then
 max3=$(cat 'f'$i'.dat' | tail -3 | head -n +1 | grep -Eo '[0-9]{1,}')
 #echo "Altitude max max = $max3"
elif [ $(cat 'f'$i'.dat' | tail -3 | head -n +1 | grep -Eo '[0-9]{1,}') -lt $min3 ]; then
 min3=$(cat 'f'$i'.dat' | tail -3 | head -n +1 | grep -Eo '[0-9]{1,}')
 #echo "Altitude max min = $min3"
fi
done
i=$(($y-$x)) 
echo "Durée de vol en altitude minimum = $min1" >> synthese-$x-$y.txt   #on ecrit toutes les informations dans la synthese
echo "Durée de vol en altitude maximum = $max1" >> synthese-$x-$y.txt 
echo "Durée de vol en altitude moyen (arrondi a l'entier superieur) = $(($moy1/$i))" >> synthese-$x-$y.txt 
echo "Durée de vol minimum  = $min2" >> synthese-$x-$y.txt
echo "Durée de vol maximum  = $max2" >> synthese-$x-$y.txt
echo "Durée de vol moyen (arrondi a l'entier superieur) = $(($moy2/$i))" >> synthese-$x-$y.txt 
echo "Altitude max minimum = $min3" >> synthese-$x-$y.txt 
echo "Altitude max maximum = $max3" >> synthese-$x-$y.txt 
echo "Altitude max moyenne (arrondie a l'entier superieur) = $(($moy3/$i))" >> synthese-$x-$y.txt 
cp synthese-$x-$y.txt ../synthese-$x-$y.txt #on ecrase le fichier s'il existe deja (d'ou le cp)
echo "Fichiers sources bien crees"
echo "Creation des graphiques ..." 
#on creer les graphiques grace a gnuplot en fonction des fichiers précedents
gnuplot <<EOF     
    set terminal jpeg 
    set output "../vols$x-$y.jpg"
    set title 'Un en fonction de n'
    set xlabel 'n'
    set ylabel 'Un'
    plot for [t = $x : $y : 1] 'f'.t.'.dat' i 0 u 1:2 with lines title ''
    exit
EOF
   
gnuplot <<EOF
    set terminal jpeg 
    set output "../altmax$x-$y.jpg"
    set title 'Altitude maximum pour chaque U0'
    set xlabel 'U0'
    set ylabel 'Altitude max'
    plot "titi.dat" u 1:2 with lines title ''
    exit
EOF
gnuplot <<EOF
    set terminal jpeg 
    set output "../dureedevol$x-$y.jpg"
    set title 'Durée de vol pour chaque U0'
    set xlabel 'U0'
    set ylabel 'Durée de vol'
    plot "tata.dat" u 1:2 with lines title ''
    exit
EOF
gnuplot <<EOF
    set terminal jpeg 
    set output "../dureevolalt$x-$y.jpg"
    set title 'Durée de vol en altitude pour chaque U0'
    set xlabel 'U0'
    set ylabel 'Durée de vol en altitude'
    plot "toto.dat" u 1:2 with lines title '' 
    exit
EOF
echo "Graphiques bien crees les voici :"
cd ..
display ./vols$x-$y.jpg &     #on affiche les images avec display de imagemagick pour un affichage plus convenable: https://imagemagick.org/index.php
display ./altmax$x-$y.jpg &
display ./dureedevol$x-$y.jpg &
display ./dureevolalt$x-$y.jpg &
xdg-open ./synthese-$x-$y.txt   #pour la synthese en txt xdg-open suffit 
rm -rf tmp  #on supprime le dossier temporaire
cd ..  #on se replace dans le repertoire de base
}
main "$@"  #on appel la fonction main avec la liste de tous les arguments.

