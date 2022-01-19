#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
//commande de compil gcc Projet.c -lm -o Projet
int creationfichier(FILE*,unsigned long ,int , unsigned long , unsigned long, int,int);

int main(int argc, char **argv)
{   
    if (argc!=3)
    {
        printf("Nombre d'argument incorrect\n"); 
        exit(1);
    }
    unsigned long U0 = 0;
    int n=0;
    unsigned long maxtmp = 0;
    unsigned long U0tmp = 0;
    char* pointeurdefin;
    U0 = strtoul(argv[1], &pointeurdefin, 10);
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
	fichier = (fopen((strcat(nomfichier, ".dat")),"w+"));
    int volmax = 0;
    if(fichier == NULL)
		{                
			fprintf(stderr,"Impossible de creer le fichier \n");
			exit(3);
		}
	/*else{
		fprintf(stderr,"Fichier bien crée\n");
		} */
    creationfichier(fichier,U0,n,maxtmp,U0tmp,altitude, volmax);
}

int creationfichier(FILE* fichier,unsigned long x,int i, unsigned long max, unsigned long tmp, int inf,int maxpourvolalt)
{
    if(x>=tmp) inf++;
    if(x<tmp)
    {
        if(maxpourvolalt<inf) maxpourvolalt =inf;
        inf =0;
    }
    if(max<x) max= x;
    fprintf(fichier,"%d %lu\n",i,x);
    if(x==1)
    {
        if(maxpourvolalt<=0)maxpourvolalt =1;
        fprintf(fichier,"\nAltitudemax=%lu\nDureevol=%d\ndureealtitude=%d\n",max,i, maxpourvolalt-1);
        return 0;
    }

    if (x%2==0) creationfichier(fichier,x/2,i+1,max, tmp, inf, maxpourvolalt);
    else creationfichier(fichier,x*3+1,i+1,max,tmp, inf, maxpourvolalt);

}