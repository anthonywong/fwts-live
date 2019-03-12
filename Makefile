all: clean build

build:
	docker build -t fwts-live .
	docker run --privileged --rm -v `pwd`:/image fwts-live

clean:
	-docker rmi fwts-live
