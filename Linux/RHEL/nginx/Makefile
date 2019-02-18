VERSION=1.14.2
RELEASE=1.el7_4
RPM_NAME=um-nginx
ARCH=$(shell uname -m)
TOPDIR	:= $(shell pwd)
FILES = \
${TOPDIR}/BUILD \
${TOPDIR}/BUILDROOT \
${TOPDIR}/SOURCES \
${TOPDIR}/RPMS \
${TOPDIR}/SRPMS \
${RPM_NAME}-${VERSION} \
${RPM_NAME}-${VERSION}.tar.gz \
${TOPDIR}/SOURCES/${RPM_NAME}-${VERSION}.tar.gz \
${RPM_NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm \
${RPM_NAME}-${VERSION}-${RELEASE}.src.rpm

all : ${FILES}

${TOPDIR}/BUILD :
	mkdir -p $@

${TOPDIR}/BUILDROOT :
	mkdir -p $@/${RPM_NAME}-${VERSION}-${RELEASE}.${ARCH}

${TOPDIR}/RPMS :
	mkdir -p $@

${TOPDIR}/SRPMS :
	mkdir -p $@

${TOPDIR}/SOURCES :
	mkdir -p $@

${RPM_NAME}-${VERSION} :
	sudo yum-builddep -y ${RPM_NAME}.spec
	rpm --define "_topdir ${TOPDIR}" -i src/nginx-${VERSION}-${RELEASE}.ngx.src.rpm
	git clone http://git-eman/open/open_source/nginx-auth-ldap.git SOURCES/nginx-auth-ldap
	cp src/nginx-${VERSION}.tar.gz .
	tar xzf nginx-${VERSION}.tar.gz
	cp src/nginx.conf SOURCES/nginx.conf
	cp src/nginx.service SOURCES/nginx.service
	cp src/nginx-debug.service SOURCES/nginx-debug.service
	cp -r nginx-${VERSION} $@
	cp -r $@ ${TOPDIR}/BUILD/

${RPM_NAME}-${VERSION}.tar.gz : ${RPM_NAME}-${VERSION}
	tar --exclude-vcs -czf  $@ $<	|| tar -czf  $@ $<

${TOPDIR}/SOURCES/${RPM_NAME}-${VERSION}.tar.gz : ${RPM_NAME}-${VERSION}.tar.gz
	cp $< $@

${RPM_NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm : ${TOPDIR}/SOURCES/${RPM_NAME}-${VERSION}.tar.gz  ${RPM_NAME}.spec
	@echo ${RPM_NAME}
	rpmbuild --buildroot ${TOPDIR}/BUILDROOT/${RPM_NAME}-${VERSION}-${RELEASE}.${ARCH} --define "_topdir ${TOPDIR}" --define "_name ${RPM_NAME}" --define "_version ${VERSION}" --define "_release ${RELEASE}" -vv -ba ${RPM_NAME}.spec
	cp ${TOPDIR}/RPMS/${ARCH}/$@ .
	test -e $@

${RPM_NAME}-${VERSION}-${RELEASE}.src.rpm : ${RPM_NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm
	cp ${TOPDIR}/SRPMS/$@ .

test: ${RPM_NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm
	 rpm -qpl ${RPM_NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm | cat -n
	 rpm --test -i $< ; if [ $$? == 0 ] ; then echo "PASS"; else echo "FAIL"; fi

clean:
	rm -rf ${FILES} SPECS SRPMS nginx-${VERSION}.tar.gz nginx-${VERSION}

install-dev:
	sudo yum install -y ${RPM_NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm

push-nprd-repo:
	rsync -avhz ${RPM_NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm esd-aln2-7-1:/apps/yum/SILO/nprd/ESD/RPMS/

push-prod-repo:
	rsync -avhz ${RPM_NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm esd-aln2-7-1:/apps/yum/SILO/production/ESD/RPMS/

erase:
	sudo yum erase -y um-nginx