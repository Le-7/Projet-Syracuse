#!/bin/bash
main() {
test "$@"
creation "$@"
}

test(){
if [ "$1" == "-h" ]; then
 aide
 exit 0
fi
if [ "$#" -ne 2 ] && ! [ "$1" == "-h" ] ; then
 echo "Le nombre d'arguments est invalide"
 aide
 exit 1
fi
if ! [ "$1" == "-h" ] && ! [[ "$1" =~ ^-?[0-9]+$ ]]; then
 echo "Le premier argument n est pas un entier"
 aide
 exit 2
fi
if ! [ "$1" == "-h" ] && ! [[ "$2" =~ ^-?[0-9]+$ ]]; then
 echo "Le second argument n est pas un entier"
 aide
 exit 3
fi
if ! [ "$1" == "-h" ] && [ "$1" -gt "$2" ]; then
 echo "Le premier argument est superieur au second"
 aide
 exit 4
fi
}

aide(){
echo "Blabla aide"
}

creation(){
gcc Projet.c -o Projet
mkdir -p resultats
cd resultats
mkdir -p tmp
cd tmp
x="$1"
y="$2"
echo "Creation des fichiers sources ..."
for (( i=x; i<=y; i++ ))
do ../../Projet "$i" "f$i"
error=$?
if [ "$error" -ne 0 ] ; then
 echo "Probleme dans l'execution du programme en c, code d'erreur = "$error""
 aide
 exit 5
fi
done
touch toto.dat
touch tata.dat
touch titi.dat
touch synthese-$x-$y.txt  
moy1=0 moy2=0 moy3=0
min1=2147483647 min2=2147483647 min3=2147483647
max1=0 max2=0 max3=0
for (( i=x; i<=y; i++ ))
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
echo "Durée de vol en altitude minimum = $min1" >> synthese-$x-$y.txt 
echo "Durée de vol en altitude maximum = $max1" >> synthese-$x-$y.txt 
echo "Durée de vol en altitude moyen (arrondi a l'entier superieur) = $(($moy1/$i))" >> synthese-$x-$y.txt 
echo "Durée de vol minimum  = $min2" >> synthese-$x-$y.txt
echo "Durée de vol maximum  = $max2" >> synthese-$x-$y.txt
echo "Durée de vol moyen (arrondi a l'entier superieur) = $(($moy2/$i))" >> synthese-$x-$y.txt 
echo "Altitude max minimum = $min3" >> synthese-$x-$y.txt 
echo "Altitude max maximum = $max3" >> synthese-$x-$y.txt 
echo "Altitude max moyenne (arrondie a l'entier superieur) = $(($moy3/$i))" >> synthese-$x-$y.txt 
cp synthese-$x-$y.txt ../synthese-$x-$y.txt #on ecrase le fichier s'il existe deja
echo "Fichiers sources bien crees"
echo "Creation des graphiques ..."
gnuplot <<EOF
set terminal jpeg 
set output "../vols$x-$y.jpg"
set title 'Un en fonction de n'
set xlabel 'n'
set ylabel 'Un'
plot for [t = $x : $y : 1] 'f'.t.'.dat' i 0 u 1:2 with lines title ''
EOF
gnuplot <<EOF
set terminal jpeg 
set output "../altmax$x-$y.jpg"
set title 'Altitude maximum pour chaque U0'
set xlabel 'U0'
set ylabel 'Altitude max'
plot "titi.dat" u 1:2 with lines title ''
EOF
gnuplot <<EOF
set terminal jpeg 
set output "../dureedevol$x-$y.jpg"
set title 'Durée de vol pour chaque U0'
set xlabel 'U0'
set ylabel 'Durée de vol'
plot "tata.dat" u 1:2 with lines title ''
EOF
gnuplot <<EOF
set terminal jpeg 
set output "../dureevolalt$x-$y.jpg"
set title 'Durée de vol en altitude pour chaque U0'
set xlabel 'U0'
set ylabel 'Durée de vol en altitude'
plot "toto.dat" u 1:2 with lines title '' 
EOF
echo "Graphiques bien crees les voici :"
cd ..
display ./vols$x-$y.jpg &
display ./altmax$x-$y.jpg &
display ./dureedevol$x-$y.jpg &
display ./dureevolalt$x-$y.jpg &
xdg-open ./synthese-$x-$y.txt
rm -rf tmp
cd ..
}
main "$@"

