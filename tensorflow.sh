#!/bin/bash
# declare STRING variable
STRING="TENSORFLOW INSTALLING..."
#print variable on a screen
echo $STRING

#TensorFlow Install packages

# 1.Update raspberry pi
sudo apt-get update && dist-upgrade

# 2.Install TensorFlow
sudo pip install tensorflow

# 3.Install OpenCV
sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev lib41-dev
sudo apt-get install libxvidcore-dev libx264-dev
sudo apt-get install qt4-dev-tools
pip3 install opencv-python

# 4.Compile and isntall Protobuf
sudo apt-get install autoconf automake libtool curl
protocolbuffers= "https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protobuf-all-3.6.1.tar.gz"
wget protocolbuffers -P /home/pi/
tar -zxvf /home/pi/protobuf-all-3.6.1.tar.gz
cd protobuf-all-3.6.1
./configure && make
make check
make install && cd python
export LD_LIBRARY_PATH=../src/.libs
python3 setup.py build --cpp_implementation
python3 setup.py test --cpp_implementation
python3 setup.py install --cpp_implementation
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION_VERSION=3
ldconfig

# 5.Setup TensorFlow directory structure
cd
mkdir tensorflow1
cd tensorflow1/
git clone --recurse-submodules https://github.com/tensorflow/models.git
echo 'export PYTHONPATH=$PYTHONPATH:/home/pi/tensorflow1/models/research:/home/pi/tensorflow1/models/research/slim' >> ~/.bashrc
cd /home/pi/tensorflow1/models/research/object_detection
wget http://download.tensorflow.org/models/object_detection/ssdlite_mobilenet_v2_coco_2018_05_09.tar.gz
tar -xzvf ssdlite_mobilenet_v2_coco_2018_05_09.tar.gz
cd /home/pi/tensorflow1/models/research/
protoc object_detection/protos/*.proto --python_out=.

Finish="TensorFlow has been installed. You can test it out"
