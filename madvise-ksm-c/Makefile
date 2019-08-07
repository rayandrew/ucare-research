CC=gcc
CFLAGS=-c -Wall -g
LDFLAGS=-g -lm

WITH_MADVISE_MAIN=./src/with_madvise.c
WITHOUT_MADVISE_MAIN=./src/without_madvise.c

SOURCES=$(wildcard ./src/*.c)
OBJECTS=$(SOURCES:.c=.o)
WITH_MADVISE_OBJECTS=$(filter-out $(WITHOUT_MADVISE_MAIN:.c=.o), $(OBJECTS))
WITHOUT_MADVISE_OBJECTS=$(filter-out $(WITH_MADVISE_MAIN:.c=.o), $(OBJECTS))

WITH_MADVISE_EXECUTABLE=./bin/with_madvise
WITHOUT_MADVISE_EXECUTABLE=./bin/without_madvise

.PHONY: all bin clean

all: bin

bin: $(WITH_MADVISE_EXECUTABLE) $(WITHOUT_MADVISE_EXECUTABLE)

$(WITH_MADVISE_EXECUTABLE): $(WITH_MADVISE_OBJECTS)
	$(CC) $(LDFLAGS) $(WITH_MADVISE_OBJECTS) -o $@

$(WITHOUT_MADVISE_EXECUTABLE): $(WITHOUT_MADVISE_OBJECTS)
	$(CC) $(LDFLAGS) $(WITHOUT_MADVISE_OBJECTS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	-rm $(OBJECTS)
	-rm $(WITH_MADVISE_EXECUTABLE)
	-rm $(WITHOUT_MADVISE_EXECUTABLE)

run-with-madvise:
	for i in `seq 1 ${num_process}` ; do \
		./bin/with_madvise ${array_size} & \
	done

run-without-madvise:
	for i in `seq 1 ${num_process}` ; do \
		./bin/without_madvise ${array_size} & \
	done

priv-profiling-with-madvise:
	ps_mem -p `pgrep -d, -f ./bin/with_madvise`

priv-profiling-without-madvise:
	ps_mem -p `pgrep -d, -f ./bin/without_madvise`

profiling-with-madvise:
	make priv-profiling-with-madvise > ./logs/with_madvise/size_${array_size}/${num_process}.log && make kill-with-madvise

profiling-without-madvise:
	make priv-profiling-without-madvise > ./logs/without_madvise/size_${array_size}/${num_process}.log && make kill-without-madvise

kill-with-madvise:
	killall with_madvise

kill-without-madvise:
	killall without_madvise