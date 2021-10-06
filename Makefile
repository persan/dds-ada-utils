PROJECT=dds-ada-utils.gpr

-include Makefile.conf

all:
	gprbuild -P ${PROJECT}
	gprbuild -P relengtools/relengtools.gpr
	gprbuild -P examples/dds-ada-utils-examples.gpr

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

master:
	git checkout master
merge:
	git checkout master
	git pull
	git checkout request-response-wip
	git merge master

