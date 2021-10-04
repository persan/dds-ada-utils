PROJECT=dds-ada-utils.gpr
all:
	gprbuild -P ${PROJECT}

clean:
	git clean -xdf

test:
	${MAKE} -C tests
doc:
	gnatdoc --no-subprojects -P ${PROJECT}
