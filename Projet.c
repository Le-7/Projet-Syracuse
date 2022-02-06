/* PROJET SYRACUSE
 * COSTA Mathéo & AÏT CHADI Anissa
 * PRÉING2 MI GROUPE 3
 */

                                //Inclusion des bibliothèques
#include <stdio.h>
#include <stdlib.h>
#include <string.h>             //Prototype de fonction
int creationfichier(FILE*,unsigned long ,int , unsigned long , unsigned long, int,int);
                              
int main(int argc, char **argv) //Fonction principale
{                               
    if (argc!=3)                //On vérifie que le programme a bien été appelé sans erreur (trop d'arguments ou pas un entier)
    {
        printf("Nombre d'argument incorrect\n"); 
        exit(1);
    }
                                //Déclaration des variables
    unsigned long U0 = 0;
    int n=0;
    unsigned long maxtmp = 0;
    unsigned long U0tmp = 0;
    char* pointeurdefin;
    U0 = strtoul(argv[1], &pointeurdefin, 10); //Fonction incluse dans string.h pour convertir chaine de caractères vers entiers non signés ("string to unsigned long")
    if(U0==0)
    {
        puts("U0 n'est pas un entier superieur a 0");
        exit(2);
    } 
    U0tmp = U0;
    unsigned long  altitude = 0;
    FILE* fichier; 
	char* nomfichier = NULL;
	nomfichier = argv[2];
	fichier = (fopen((strcat(nomfichier, ".dat")),"w+"));         //On ouvre un fichier .dat en droit d'écriture
    int volmax = 0;
    if(fichier == NULL)
		{                
			fprintf(stderr,"Impossible de creer le fichier \n");
			exit(3);
		}
		
    creationfichier(fichier,U0,n,maxtmp,U0tmp,altitude, volmax); //Appel de la fonction récursive
}


int creationfichier(FILE* fichier,unsigned long x,int i, unsigned long max, unsigned long tmp, int inf,int maxpourvolalt) //Fonction récursive
{
    if(x>=tmp) inf++;                               //Boucle pour le calcul de vol en altitude
    if(x<tmp)
    {
        if(maxpourvolalt<inf) maxpourvolalt =inf;   //Si la valeur est maximale, alors on l'enregistre en tant que maximum
        inf =0;                                     //On remet à 0 s'il retombe en dessous de la valeur de départ
    }
    if(max<x) max= x;   //pour calculer le max
    fprintf(fichier,"%d %lu\n",i,x);                //On écrit dans le fichier la nième étape et le Un
    if(x==1)                                        //Condition d'arret
    {
        if(maxpourvolalt<=0)maxpourvolalt =1;       //Pour ne pas avoir de problèmes dans la suite avec un O
        fprintf(fichier,"\nAltitudemax=%lu\nDureevol=%d\ndureealtitude=%d\n",max,i, maxpourvolalt-1);  //si x=1 alors on a fini, on écrit à la fin du fichier ce qui nous intéresse 
        return 0;
    }
                                                    //Appels recursifs
    if (x%2==0) creationfichier(fichier,x/2,i+1,max, tmp, inf, maxpourvolalt);
    else creationfichier(fichier,x*3+1,i+1,max,tmp, inf, maxpourvolalt);

}
