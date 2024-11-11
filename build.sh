#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
VERSION=6.6.2
SUBVERSION=1
IMAGE="alpine_wordpress"
TAG=`date '+%Y%m%d_%H%M%S'`

case "$1" in
	
	test)
		docker build ./ -t bayrell/alpine_wordpress:$VERSION-$SUBVERSION-$TAG --file Dockerfile --build-arg ARCH=-amd64
	;;
	
	amd64)
		docker build ./ -t bayrell/alpine_wordpress:$VERSION-$SUBVERSION-amd64 \
			--file Dockerfile --build-arg ARCH=-amd64
	;;
	
	arm64v8)
		docker build ./ -t bayrell/alpine_wordpress:$VERSION-$SUBVERSION-arm64v8 \
			--file Dockerfile --build-arg ARCH=-arm64v8
	;;
	
	arm32v7)
		docker build ./ -t bayrell/alpine_wordpress:$VERSION-$SUBVERSION-arm32v7 \
			--file Dockerfile --build-arg ARCH=-arm32v7
	;;
	
	manifest)
		rm -rf ~/.docker/manifests/docker.io_bayrell_alpine_wordpress-*
		
		docker tag bayrell/alpine_wordpress:$VERSION-$SUBVERSION-amd64 bayrell/alpine_wordpress:$VERSION-amd64
		docker tag bayrell/alpine_wordpress:$VERSION-$SUBVERSION-arm64v8 bayrell/alpine_wordpress:$VERSION-arm64v8
		docker tag bayrell/alpine_wordpress:$VERSION-$SUBVERSION-arm32v7 bayrell/alpine_wordpress:$VERSION-arm32v7
		
		docker push bayrell/alpine_wordpress:$VERSION-$SUBVERSION-amd64
		docker push bayrell/alpine_wordpress:$VERSION-$SUBVERSION-arm64v8
		docker push bayrell/alpine_wordpress:$VERSION-$SUBVERSION-arm32v7
		
		docker push bayrell/alpine_wordpress:$VERSION-amd64
		docker push bayrell/alpine_wordpress:$VERSION-arm64v8
		docker push bayrell/alpine_wordpress:$VERSION-arm32v7
		
		docker manifest create bayrell/alpine_wordpress:$VERSION-$SUBVERSION \
			--amend bayrell/alpine_wordpress:$VERSION-$SUBVERSION-amd64 \
			--amend bayrell/alpine_wordpress:$VERSION-$SUBVERSION-arm64v8 \
			--amend bayrell/alpine_wordpress:$VERSION-$SUBVERSION-arm32v7
		docker manifest push bayrell/alpine_wordpress:$VERSION-$SUBVERSION
		
		docker manifest create bayrell/alpine_wordpress:$VERSION \
			--amend bayrell/alpine_wordpress:$VERSION-amd64 \
			--amend bayrell/alpine_wordpress:$VERSION-arm64v8 \
			--amend bayrell/alpine_wordpress:$VERSION-arm32v7
		docker manifest push bayrell/alpine_wordpress:$VERSION
	;;
	
	upload-image)
		
		if [ -z "$2" ] || [ -z "$3" ]; then
			echo "Type:"
			echo "$0 upload-image $VERSION raspa 172"
			echo "  $VERSION - version"
			echo "  raspa - ssh host"
			echo "  172 - bandwidth KiB/s"
			exit 1
		fi
		
		image=$IMAGE
		version=$2
		ssh_host=$3
		bwlimit=""
		
		if [ ! -z "$4" ]; then
			bwlimit=$4
		fi
		
		mkdir -p images
		
		if [ ! -f ./images/$image-$version.tar.gz ]; then
			echo "Save image"
			docker image save bayrell/$image:$version | gzip \
				> ./images/$image-$version.tar.gz
		fi
		
		echo "Upload image"
		ssh $ssh_host "mkdir -p ~/images"
		ssh $ssh_host "yes | rm -f ~/images/$image-$version.tar.gz"
		
		if [ ! -z "$bwlimit" ]; then
			time rsync -aSsuh \
				--info=progress2 \
				--bwlimit=$bwlimit \
				./images/$image-$version.tar.gz \
				$ssh_host:images/$image-$version.tar.gz
		else
			time rsync -aSsuh \
				--info=progress2 \
				./images/$image-$version.tar.gz \
				$ssh_host:images/$image-$version.tar.gz
		fi
		
		echo "Load image"
		ssh $ssh_host "docker load -i ~/images/$image-$version.tar.gz"
	;;
	
	all)
		$0 amd64
		$0 arm64v8
		$0 arm32v7
		$0 manifest
	;;
	
	*)
		echo "Usage: $0 {amd64|arm64v8|arm32v7|manifest|all|test}"
		RETVAL=1

esac

exit $RETVAL
