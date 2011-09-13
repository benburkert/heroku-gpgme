#!/bin/bash

set -e
set -x

ruby_gpgme_dir="$HOME/ruby-gpgme"
prefix="$ruby_gpgme_dir/ext/gpgme/opt"

## Ruby

cd $HOME

wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.gz
tar -zxvf ruby-1.9.2-p180.tar.gz
cd ruby-1.9.2-p180

./configure
make
make install

gem install bundler

## ruby-gpgme

cd $HOME

apt-get -y install git-core

git clone git://github.com/benburkert/ruby-gpgme.git
cd ruby-gpgme
git checkout -b heroku origin/heroku
mkdir -p $prefix

## GPGME

cd $HOME

wget ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.11.tar.bz2
tar xjvf gnupg-1.4.11.tar.bz2
cd gnupg-1.4.11

./configure --disable-dependency-tracking --prefix=$prefix
make
make install

cd $HOME

wget ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.10.tar.bz2
tar xjvf libgpg-error-1.10.tar.bz2
cd libgpg-error-1.10

./configure --disable-dependency-tracking --prefix=$prefix
make
make install

cd $HOME

wget ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.0.2.tar.bz2
tar xjvf libassuan-2.0.2.tar.bz2
cd libassuan-2.0.2
./configure --disable-dependency-tracking --prefix=$prefix \
            --with-gpg-error-prefix=$prefix
make
make install

cd $HOME

wget ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.3.1.tar.bz2
tar xjvf gpgme-1.3.1.tar.bz2
cd gpgme-1.3.1

./configure --disable-dependency-tracking --prefix=$prefix \
            --with-gpg-error-prefix=$prefix \
            --with-libassuan-prefix=$prefix
make
make install

## Build .gem

cd $ruby_gpgme_dir
gem build *.gemspec
gem install *.gem

cp *.gem $HOME/share
cp -R $prefix $HOME/share
