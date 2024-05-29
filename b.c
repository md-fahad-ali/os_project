#include <stdio.h>

#define MAX 25

void bestFit()
{
    int blocks[MAX], files[MAX], frag[MAX], i, j, nb, nf, temp, highest = 0;
    int bf[MAX], ff[MAX];

    printf("Enter the number of blocks: ");
    scanf("%d", &nb);

    printf("Enter the number of files: ");
    scanf("%d", &nf);

    printf("Enter the size of the blocks:\n");
    for (i = 1; i <= nb; i++)
    {
        printf("Block %d: ", i);
        scanf("%d", &blocks[i]);
    }

    printf("Enter the size of the files:\n");
    for (i = 1; i <= nf; i++)
    {
        printf("File %d: ", i);
        scanf("%d", &files[i]);
    }

    for (i = 1; i <= nf; i++)
    {
        highest = 0;
        for (j = 1; j <= nb; j++)
        {
            if (bf[j] != 1)
            {
                temp = blocks[j] - files[i];
                if (temp >= 0)
                {
                    if (highest < temp)
                    {
                        ff[i] = j;
                        highest = temp;
                    }
                }
            }
        }
        frag[i] = highest;
        bf[ff[i]] = 1;
        highest = 0;
    }

    printf("\nFile_no \tFile_size \tBlock_no \tBlock_size \tFragment\n");
    for (i = 1; i <= nf; i++)
    {
        printf("%d\t\t%d\t\t%d\t\t%d\t\t%d\n", i, files[i], ff[i], blocks[ff[i]], frag[i]);
    }
}

int main()
{
    bestFit();
    return 0;
}