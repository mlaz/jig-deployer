#!/bin/bash
cd $HOME/jig

git clone --recurse-submodules git://git.code.sf.net/p/openocd/code openocd
cd openocd
./bootstrap
./configure --prefix=/boot --host=arm-linux-gnueabihf --enable-bcm2835gpio --enable-sysfsgpio --disable-jlink
make install DESTDIR=$(pwd)/../
cd ..

git clone https://github.com/exclave/exclave.git
cd exclave
cargo build --target=armv7-unknown-linux-gnueabihf --release
cp target/armv7-unknown-linux-gnueabihf/release/exclave ../boot/bin/
cd ..

mkdir $GOPATH/src
cd $GOPATH/src
git clone https://github.com/apache/mynewt-mcumgr-cli.git
mkdir mynewt.apache.org/
mv mynewt-mcumgr-cli/ mynewt.apache.org/mcumgr
cd mynewt.apache.org/mcumgr/mcumgr
go get -v ./
env GOOS=linux GOARCH=arm GOARM=7 go build -v -o $HOME/jig/boot/bin/mcumgr mcumgr.go
