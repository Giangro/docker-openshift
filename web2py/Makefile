CONTEXT = alex
VERSION = v1.0
IMAGE_NAME = web2py
#REGISTRY = 172.30.236.224:5000
REGISTRY = 172.17.0.3:5000
OC_USER=devops
OC_PASS=devops
PROJECT=web2py

# Allow user to pass in OS build options
ifeq ($(TARGET),alpine)
        DFILE := Dockerfile.${TARGET}
else
        TARGET := alpine
        DFILE := Dockerfile
endif

all: build
build:
	docker build --pull -t $(CONTEXT)/$(IMAGE_NAME):$(TARGET)-$(VERSION) -f $(DFILE) .
	@if docker images $(CONTEXT)/$(IMAGE_NAME):$(TARGET)-$(VERSION); then touch build; fi

lint:
	dockerfile_lint -f Dockerfile
	dockerfile_lint -f Dockerfile.alpine

deploy:	all
	$(eval token = $(shell docker exec -it origin bash -c "oc login -u $(OC_USER) -p $(OC_PASS) 2>&1 >/dev/null && oc whoami -t"))
	@echo login into registry with user = $(OC_USER)
	docker login -u $(OC_USER) -p $(token) $(REGISTRY)
	@echo tag image  $(CONTEXT)/$(IMAGE_NAME):$(TARGET)-$(VERSION) by $(REGISTRY)/$(PROJECT)/$(CONTEXT)-$(IMAGE_NAME):$(TARGET)-$(VERSION)
	docker tag $(CONTEXT)/$(IMAGE_NAME):$(TARGET)-$(VERSION) $(REGISTRY)/$(PROJECT)/$(CONTEXT)-$(IMAGE_NAME):$(TARGET)-$(VERSION)
	@echo push image 
	docker push $(REGISTRY)/$(PROJECT)/$(CONTEXT)-$(IMAGE_NAME):$(TARGET)-$(VERSION)

clean:
	rm -f build

