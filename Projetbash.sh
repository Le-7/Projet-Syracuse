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
for (( i=x; i<=y; i++ ))
do ../../Projet "$i" "f$i"
error=$?
if [ "$error" -ne 0 ] ; then
 echo "Probleme dans l'execution du programme en c, code d'erreur = "$error""
 aide
 exit 5
fi
done
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
plot for [t = $x : $y : 1] 'f'.t.'.dat' i 1 u 1:2 w p ls 1 title '' 
EOF
gnuplot <<EOF
set terminal jpeg 
set output "../dureedevol$x-$y.jpg"
set title 'Durée de vol pour chaque U0'
set xlabel 'U0'
set ylabel 'Durée de vol'
plot for [t = $x : $y : 1] 'f'.t.'.dat' i 2 u 1:2 w p ls 1 title '' 
EOF
gnuplot <<EOF
set terminal jpeg 
set output "../dureevolalt$x-$y.jpg"
set title 'Durée de vol en altitude pour chaque U0'
set xlabel 'U0'
set ylabel 'Durée de vol en altitude'
plot for [t = $x : $y : 1] 'f'.t.'.dat' i 3 u 1:2 w p ls 1 title '' 
EOF
cd ..
xdg-open ./vols$x-$y.jpg
xdg-open ./altmax$x-$y.jpg
xdg-open ./dureedevol$x-$y.jpg
xdg-open ./dureevolalt$x-$y.jpg
rm -rf tmp
cd ..
}
main "$@"

