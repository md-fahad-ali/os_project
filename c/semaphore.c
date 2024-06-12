#include <stdio.h>
#include <pthread.h>

typedef struct
{
    int count;
    pthread_mutex_t mutex;
    pthread_cond_t condition;
} Semaphore;

void semaphore_init(Semaphore *sem, int initial_count)
{
    sem->count = initial_count;
    pthread_mutex_init(&sem->mutex, NULL);
    pthread_cond_init(&sem->condition, NULL);
}

void semaphore_wait(Semaphore *sem)
{
    pthread_mutex_lock(&sem->mutex);
    while (sem->count <= 0)
    {
        pthread_cond_wait(&sem->condition, &sem->mutex);
    }
    sem->count--;
    pthread_mutex_unlock(&sem->mutex);
}

void semaphore_signal(Semaphore *sem)
{
    pthread_mutex_lock(&sem->mutex);
    sem->count++;
    pthread_cond_signal(&sem->condition);
    pthread_mutex_unlock(&sem->mutex);
}

void semaphore_destroy(Semaphore *sem)
{
    pthread_mutex_destroy(&sem->mutex);
    pthread_cond_destroy(&sem->condition);
}

// Example usage
Semaphore mySemaphore;

void *thread_function(void *arg)
{
    int id = *((int *)arg);
    printf("Thread %d waiting...\n", id);
    semaphore_wait(&mySemaphore);
    printf("Thread %d enters critical section\n", id);
    // Critical section
    // Do some work...
    printf("Thread %d leaves critical section\n", id);
    semaphore_signal(&mySemaphore);
    return NULL;
}

int main()
{
    semaphore_init(&mySemaphore, 3); // Initialize semaphore with count 3

    pthread_t threads[5];
    int thread_ids[5] = {1, 2, 3, 4, 5};

    for (int i = 0; i < 5; i++)
    {
        pthread_create(&threads[i], NULL, thread_function, &thread_ids[i]);
    }

    for (int i = 0; i < 5; i++)
    {
        pthread_join(threads[i], NULL);
    }

    semaphore_destroy(&mySemaphore);

    return 0;
}