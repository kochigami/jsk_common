#!/bin/bash
sudo aptitude install libgnomeui-dev libxml++2.6-dev
#wget http://winnie.kuis.kyoto-u.ac.jp/HARK/src/flowdesigner-0.9.1-hark-1.2.0.tar.gz
#wget http://winnie.kuis.kyoto-u.ac.jp/HARK/src/libharkio2-1.2.0.tar.gz
#wget http://winnie.kuis.kyoto-u.ac.jp/HARK/src/libharknetapi-1.2.0.tar.gz
#wget http://winnie.kuis.kyoto-u.ac.jp/HARK/src/hark-fd-1.2.0.tar.gz
#wget http://winnie.kuis.kyoto-u.ac.jp/HARK/src/harktool4-1.2.0.tar.gz
#wget http://winnie.kuis.kyoto-u.ac.jp/HARK/src/harktool4-gui-1.2.0.tar.gz
#wget http://winnie.kuis.kyoto-u.ac.jp/HARK/src/hark-ros-groovy-1.2.0.tar.gz
#wget http://winnie.kuis.kyoto-u.ac.jp/HARK/src/julius-4.2.2-hark-1.2.0.tar.gz
#wget http://winnie.kuis.kyoto-u.ac.jp/HARK/src/julius-4.2.2-hark-plugin-1.2.0.tar.gz
#hark-ros-stacksがない
#ls *.tar.gz | xargs -i{} tar axvf {}

HARK_PATH=$HOME/hark-groovy
YOUR_HARK_DOWNLOAD_DIR=`pwd`
apt-get source flowdesigner-0.9.1-hark
apt-get source harkfd
apt-get source libharkio2
apt-get source hark-ros-groovy
apt-get source hark-ros-stacks-groovy
apt-get source libhark-netapi
apt-get source hark_designer
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$YOUR_HARK_DOWNLOAD_DIR/libhark-netapi_2.0.0.4749/
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HARK_PATH/lib/pkgconfig
export PATH=$HARK_PATH/bin:$PATH
export ROS_PACKAGE_PATH=$YOUR_HARK_DOWNLOAD_DIR/hark-ros-stacks-groovy.6430:$ROS_PACKAGE_PATH
# install hark-ros-stacks
cd hark-ros-stacks-groovy-2.0.0.6430
./make-all-packages.sh
cd ..

# install flowdesigner
cd ./flowdesigner-0.9.1-hark-2.0.0.6239
./configure --prefix=$HARK_PATH
make -j
make install
cd ..

# install libharkio2
#cd ..
cd ./libharkio2-2.0.0.5424/
#./configure --prefix=$HARK_PATH --enable-harknetapi --with-harknetapi-inc=$YOUR_HARK_DOWNLOAD_DIR/libharknetapi-*.*.* --with-harknetapi-lib=$YOUR_HARK_DOWNLOAD_DIR/libharknetapi-*.*.* --with-harkio2-inc=$HARK_PATH/include --enable-harkio2
./configure --prefix=$HARK_PATH 
make -j
make install
cd ..

# install libhark-netapi
cd ./libhark-netapi-2.0.0.4749
make DESTDIR=$HOME/hark-groovy static
make DESTDIR=$HOME/hark-groovy install
cd ..


# install hark-fd
cd ./harkfd-2.0.0.6582
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HARK_PATH/lib/pkgconfig
export PATH=$PATH:$HARK_PATH/bin
#./configure --prefix=$HARK_PATH --enable-harknetapi --with-harknetapi-inc=$HOME/src/hark-srcs/libharknetapi-1.2.0 --with-harknetapi-lib=${HOME}/src/hark-srcs/libharknetapi-1.2.0  --with-harkio2-inc=$HOME/hark/include --with-harkio2-lib=$HOME/hark/lib/ --enable-harkio2 --disable-harkio1
#./configure --prefix=$HARK_PATH --enable-harknetapi --with-harknetapi-inc=$YOUR_HARK_DOWNLOAD_DIR/libharknetapi-1.2.0 --with-harknetapi-lib=$YOUR_HARK_DOWNLOAD_DIR/libharknetapi-1.2.0 --enable-fast-install
./configure --prefix=$HARK_PATH --enable-harknetapi --with-harknetapi-inc=${YOUR_HARK_DOWNLOAD_DIR}/libharknetapi-2.0.0.4749 --with-harknetapi-lib=${YOUR_HARK_DOWNLOAD_DIR}/libharknetapi-2.0.0.4749
make
make install
cd ../

# install hark-ros-groovy
cd hark-ros-groovy-2.0.0.6582
./configure --prefix=$HARK_PATH --enable-ros --with-hark-inc=$HARK_PATH/include/hark
make
make install
cd ..

# instal hark-designer
cd hark-designer-2.0.0.6519
python - <<EOF
localharkdesignerdir="$HOME/hark-groovy/bin/hark-designer"
with open("hark_designer") as f:
    lines = f.readlines()
print lines
newlines = []
for line in lines:
    newlines.append(line.replace("/usr/bin/hark-designer/",localharkdesignerdir))
with open("hark_designer.new",'w') as f:
    f.write("".join(newlines))
import os
os.makedirs(localharkdesignerdir)
EOF


################################################################
# install julius
cd julius-4.2.2-hark-1.2.0/
chmod +x configure
./configure --prefix=$HARK_PATH --enable-mfcnet
make
make install
cd ..

# make julius plugin
cd julius-4.2.2-hark-plugin-1.2.0
make
cd ..

# install hark kinect
if [ "$(uname -m)" = "x86_64" ]; then
    #for 64bit
    sudo wget "http://http.us.debian.org/debian/pool/main/p/p7zip/p7zip-full_9.20.1~dfsg.1-4_amd64.deb"
    sudo dpkg -i p7zip-full_9.20.1~dfsg.1-4_amd64.deb
else
    #for 32bit
    sudo wget "http://http.us.debian.org/debian/pool/main/p/p7zip/p7zip-full_9.20.1~dfsg.1-4_i386.deb"
    sudo dpkg -i p7zip-full_9.20.1~dfsg.1-4_i386.deb
fi

cd hark-kinect-1.2.0
make
sudo make install
cd ..

echo "********************************************************"
echo "* please add the following lines to your $HOME/.bashrc *"
echo "********************************************************"
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/YOUR_HARK_DOWNLOAD_DIR/libharknetapi-1.2.0/" 
echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HARK_PATH/lib/pkgconfig" 
echo "export PATH=$PATH:$HARK_PATH/bin" 
echo "export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$YOUR_HARK_DOWNLOAD_DIR/hark-ros-stacks" 

