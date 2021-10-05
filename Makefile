PROJECT=dds-ada-utils.gpr

-include Makefile.conf

all:
	gprbuild -P ${PROJECT}

clean:
	git clean -xdf

test:
	${MAKE} -C examples
doc:
	gnatdoc --no-subprojects -P ${PROJECT}

edit:
	${MAKE} -C examples $@ & 

Makefile.conf:Makefile
	echo "export PATH:=${PATH}:${CURDIR}/bin" >${@}


