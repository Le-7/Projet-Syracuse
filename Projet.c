#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int creationfichier(FILE*,unsigned long ,int , unsigned long , unsigned long, int,int);
//appel des bibliotheques nécessaire et prototype de fonction
int main(int argc, char **argv)
{       //on verifie que le programme a bien été appelé sans erreur (trop d'argument ou pas un entier)
    if (argc!=3)
    {
        printf("Nombre d'argument incorrect\n"); 
        exit(1);
    }
        //déclaration des variables
    unsigned long U0 = 0;
    int n=0;
    unsigned long maxtmp = 0;
    unsigned long U0tmp = 0;
    char* pointeurdefin;
    U0 = strtoul(argv[1], &pointeurdefin, 10); //fonction de string.h "string to unsigned long"(convertir)
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
	int veriff;
	fichier = (fopen((strcat(nomfichier, ".dat")),"w+")); //on ouvre un fichier .dat en droit d'écriture
    int volmax = 0;
    if(fichier == NULL)
		{                
			fprintf(stderr,"Impossible de creer le fichier \n");
			exit(3);
		}
	/*else{
		fprintf(stderr,"Fichier bien crée\n");
		} */
    creationfichier(fichier,U0,n,maxtmp,U0tmp,altitude, volmax); //appel de la fonction récursive
}

//la ca devient compliqué a expliquer
int creationfichier(FILE* fichier,unsigned long x,int i, unsigned long max, unsigned long tmp, int inf,int maxpourvolalt)
{
    if(x>=tmp) inf++; //pour le calcul de vol en altitude
    if(x<tmp)
    {
        if(maxpourvolalt<inf) maxpourvolalt =inf; //on enregistre le maximum s'il l'est
        inf =0;  //on remet a 0 s'il retombe en dessous de la valeur de départ
    }
    if(max<x) max= x;   //pour calculer le max
    fprintf(fichier,"%d %lu\n",i,x);  //on écrit dans le fichier la nieme etape et le Un
    if(x==1) //condition d'arret
    {
        if(maxpourvolalt<=0)maxpourvolalt =1;  //pour pas avoir de probleme dans la suite avec un O
        fprintf(fichier,"\nAltitudemax=%lu\nDureevol=%d\ndureealtitude=%d\n",max,i, maxpourvolalt-1);  //si x=1 alors on a fini, on ecrit a la fin du  fichier ce qui nous interesse 
        return 0;
    }
    //appels recursifs
    if (x%2==0) creationfichier(fichier,x/2,i+1,max, tmp, inf, maxpourvolalt);
    else creationfichier(fichier,x*3+1,i+1,max,tmp, inf, maxpourvolalt);

}
