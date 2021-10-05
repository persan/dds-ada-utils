PROJECT=dds-ada-utils-examples.gpr
-include Makefile.conf


all:
	gprbuild -P ${PROJECT}
	dds-mq-examples-simple-main

%:
	@true
clean:
	${MAKE} -C .. ${@}
	
edit:
	gnatstudio -P ${PROJECT}

Makefile.conf:Makefile
	echo "export PATH:=${PATH}:${CURDIR}/bin" >${@}
