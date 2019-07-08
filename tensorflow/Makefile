# clean:
# 	-rm $(OBJECTS)
# 	-rm $(WITH_MADVISE_EXECUTABLE)
# 	-rm $(WITHOUT_MADVISE_EXECUTABLE)

run:
	for i in `seq 1 ${task_number}` ; do \
		python3 cluster.py ${task_number} ${task_number} & \
	done