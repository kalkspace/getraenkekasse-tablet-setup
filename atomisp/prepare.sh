#!/bin/sh

set -e

if [ -z $1 ]; then
	echo "Please provide a kernel-source-tree as argument"
        exit 1
fi

DIR=$(realpath $(dirname $0))

rm -rf $DIR/atomisp-0.0.1
cp -a $1/drivers/staging/media/atomisp atomisp-0.0.1

cat $DIR/atomisp-0.0.1/Makefile | sed -e "s;^atomisp =.*;atomisp = $DIR/atomisp-0.0.1;g" > $DIR/atomisp-0.0.1/Makefile.hacked

cat >> $DIR/atomisp-0.0.1/Makefile.hacked <<EOT
all default: modules
install: modules_install

modules modules_install help clean:
	\$(MAKE) -C \$(KERNELDIR) M=\$(shell pwd) \$@
EOT

cp $DIR/atomisp-0.0.1/Makefile.hacked $DIR/atomisp-0.0.1/Makefile
cp dkms.conf $DIR/atomisp-0.0.1
