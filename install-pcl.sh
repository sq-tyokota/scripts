#!/bin/bash
# install pcl 1.8
echo -e '\e[1;32m### install dep pkg \e[m'
sudo apt-get update
sudo apt-get install -y cmake build-essential python-pip git python-dev libopenni-dev libopenni2-dev libvtk6-dev vtk6 libpcap-dev libflann-dev

CUDACHK=`sudo find /usr/local/ -name "cuda" | grep -c cuda`


echo -e '\e[1;32m### git clone pcl-1.8 \e[m'
mkdir lib
cd lib
git clone https://github.com/PointCloudLibrary/pcl.git pcl-1.8
cd pcl-1.8
git checkout -b pcl-1.8.0 refs/tags/pcl-1.8.0 
mkdir build
cd build

if [ $CUDACHK -ne 0 ] ; then
	echo -e '\e[1;32m### With CUDA \e[m'
	echo -e '\e[1;32m### make deviceQuery \e[m'
	cd /usr/local/cuda/samples/1_Utilities/deviceQuery
	sudo make
	cd

	echo -e '\e[1;32m### setting CUDA compute capability \e[m'
	SET_CUDA_ARCH=`/./usr/local/cuda/samples/1_Utilities/deviceQuery/deviceQuery | grep CUDA\ Capability | grep -o -e [0-9].[0-9]` # set cuda compute capability
	echo -e '\e[1;41mCUDA compute capbility='$SET_CUDA_ARCH'\e[m'
	
	echo -e '\e[1;32m### CUDA_\e[m'
	
	echo -e '\e[1;32m### cmake pcl-1.8 \e[m'
	cmake .. -DBUILD_CUDA=ON -DBUILD_GPU=ON -DCMAKE_BUILD_TYPE=Release -DCUDA_ARCH_BIN=$SET_CUDA_ARCH
	
else
	echo -e '\e[1;32m### No CUDA \e[m'
	cmake ..
fi

MEMSIZE=`vmstat -s -S m| grep 'total memory' | grep -o [0-9]*`

echo -e '\e[1;32m### make pcl-1.8 \e[m'
if [ $MEMSIZE -gt 7000 ] ; then
	if [ $MEMSIZE -gt 14000 ] ; then
		make -j4
	else
		make -j2
	fi
else
	make
fi 
make

echo -e '\e[1;32m### make install pcl-1.8 \e[m' # install for prefix path (default=/usr/local)
sudo make install
