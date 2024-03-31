export PATH=/usr/local/bin/:$PATH

printenv

# 获取完整的引用（例如：refs/tags/v1.0.0）  
full_ref=$GITHUB_REF  
  
# 提取标签名（例如：v1.0.0）  
# 注意：这里假设了 GITHUB_REF 是以 'refs/tags/' 开头的  
tag_name=${full_ref#refs/tags/}  
  
echo "Current tag is: $tag_name"  
  

source /opt/ros/humble/setup.bash
mkdir -p /github/home/.platformio/penv/bin/
touch /github/home/.platformio/penv/bin/activate
pio run
cp .config/microros/colcon.meta .pio/libdeps/featheresp32/micro_ros_platformio/metas/colcon.meta
rm -rf .pio/libdeps/featheresp32/micro_ros_platformio/libmicroros/
pio run

rm -rf bin && mkdir bin
export TNAME='fishbot_motion_control_four_driver'
export TVERSION=`git tag`
export TDATA=`date +%y%m%d`
export BINNAME=`echo $TNAME`_$TVERSION.$TDATA.bin

esptool.py  --chip esp32 merge_bin -o bin/$BINNAME --flash_mode dio --flash_size 4MB 0x1000 .pio/build/featheresp32/bootloader.bin 0x8000 .pio/build/featheresp32/partitions.bin  0x10000 .pio/build/featheresp32/firmware.bin 
echo "Build Finish bin/`ls bin`"
