DIRS = \
	web2py

# Allow user to pass in OS build options
ifeq ($(TARGET),alpine)
	DFILE := Dockerfile.${TARGET}
else
	TARGET := alpine
	DFILE := Dockerfile
endif

all: build
build: 
	@for d in ${DIRS}; do ${MAKE} -C $$d TARGET=${TARGET}; done

lint:
	@for d in ${DIRS}; do ${MAKE} lint -C $$d; done

test:
	@for d in ${DIRS}; do ${MAKE} test -C $$d; done

clean:
	@for d in ${DIRS}; do ${MAKE} clean -C $$d; done

deploy:
	@for d in ${DIRS}; do ${MAKE} deploy -C $$d; done
