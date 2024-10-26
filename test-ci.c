#include <stdio.h>  
#include <pthread.h>

void* thr(void* arg)
{
    printf("waiting. press enter\n");
    getchar();
    printf("exiting...\n");
    printf("exiting...\n");
    return NULL;
}

int main()
{
    pthread_t t;
    if(pthread_create(&t, NULL, thr, NULL) < 0)
    {
        fprintf(stderr, "cannot init thread\n");
        return 1;
    }
    pthread_join(t, NULL);
    return 0;
}
