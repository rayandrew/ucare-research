#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>

#define N_PAGES 1

void p_s(void)
{
  int fd;
  char buff[1];
  sleep(3);
  fd = open("/sys/kernel/mm/ksm/pages_sharing", O_RDONLY);
  read(fd, &buff, 1);
  printf("Sharing pages: %d\n", atoi(buff));
  close(fd);
}

int main(int argc, char *argv[])
{
  int i;

  size_t p_size = 32768;

  if (argc > 1)
  {
    sscanf(argv[1], "%lu", &p_size);
  }

  printf("Size %lu\n", p_size);

  void **pages = (void **)calloc(N_PAGES, sizeof(void *));

  for (i = 0; i < N_PAGES; i++)
  {
    pages[i] = mmap(NULL, p_size, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    if (pages[i])
    {
      memset(pages[i], 0, p_size);

      printf("Pages content %d : %p\n", i, pages[i]);
    }
    else
    {
      exit(-1);
    }
  }

  while (1)
  {
    p_s();
  }

  return 0;
}