#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

// Function that the thread will execute
void *myThread(void *arg)
{
    printf("Thread is running...\n");
    return NULL;
}

int main()
{
    int ret;
    pthread_t mythread;

    ret = pthread_create(&mythread, NULL, myThread, NULL);
    if (ret != 0)
    {
        printf("Can't create pthread (%s)\n", strerror(ret));
        exit(1);
    }

    // Wait for the thread to finish
    pthread_join(mythread, NULL);

    return 0;
}
