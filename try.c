#include <stdio.h>

int main()
{
    int n_blocks, n_files, blocks[100], files[100], allocation[100], fragments[100];
    printf("Enter the number of blocks: ");
    scanf("%d", &n_blocks);
    printf("Enter the number of files: ");
    scanf("%d", &n_files);

    printf("Enter the sizes of the blocks:\n");
    for (int i = 0; i < n_blocks; i++)
    {
        printf("Block %d: ", i + 1);
        scanf("%d", &blocks[i]);
    }

    printf("Enter the sizes of the files:\n");
    for (int i = 0; i < n_files; i++)
    {
        printf("File %d: ", i + 1);
        scanf("%d", &files[i]);
    }

    for (int i = 0; i < n_files; i++)
    {
        allocation[i] = -1;
    }

    for (int i = 0; i < n_files; i++)
    {
        int best_fit = -1;
        for (int j = 0; j < n_blocks; j++)
        {
            if (blocks[j] >= files[i])
            {
                if (best_fit == -1 || blocks[j] < blocks[best_fit])
                {
                    best_fit = j;
                }
            }
        }
        if (best_fit != -1)
        {
            allocation[i] = best_fit;
            fragments[i] = blocks[best_fit] - files[i];
            blocks[best_fit] -= files[i];
        }
    }

    printf("\nFile_no\tFile_size\tBlock_no\tBlock_size\tFragment\n");
    for (int i = 0; i < n_files; i++)
    {
        printf("%d\t\t%d\t\t", i + 1, files[i]);
        if (allocation[i] != -1)
        {
            printf("%d\t\t%d\t\t%d\n", allocation[i] + 1, files[i] + fragments[i], fragments[i]);
        }
        else
        {
            printf("Not allocated\n");
        }
    }

    return 0;
}