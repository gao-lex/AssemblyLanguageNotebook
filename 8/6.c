struct company{
    char cn[3];
    char hn[9];
    int pm;
    int sr;
    char cp[3];
};

struct company dec={"DEC","Ken Olsen",137,40,"PDP"};

int main()
{
    int i;
    dec.pm=38;
    dec.sr=dec.sr+70;
    i=0;
    dec.cp[i]='V';
    i++;
    dec.cp[i]='A';
    i++;
    dec.cp[i]='X';
    return 0;
}