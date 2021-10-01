all:
	gprbuild

clean:
	git clean -xdf

 test:
	${MAKE} -C tests
