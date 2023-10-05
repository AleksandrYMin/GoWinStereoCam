# GoWinStereoCam
Stereo camera with MIPI CSI-2 interface, based on [SiPEED TangPrimer 20K](https://wiki.sipeed.com/hardware/en/tang/tang-primer-20k/primer-20k.html) module and two OV5640 cameras.

GoWin TangPrimer board transmits 1280х720 image via two line MIPI CSI-2 interface, connected to Raspberry Pi.
Video received with modified raspiraw app (original code [here](https://github.com/raspberrypi/raspiraw)).
Changed modes 6 and 7 for imx219, added gstreamer plugin by HermannSW from [here](https://forums.raspberrypi.com//viewtopic.php?f=43&t=197124&p=1236528).

## Prepare Raspberry Pi 4 for receiving with raspiraw
On R-Pi in /boot/config.txt

### Add lines:
```
dtparam=i2c_vc=on  
start_x=1  
gpu_mem=256  
### Delete line:
camera_auto_detect=1  
```


## View video
Now you can run modified raspiraw with following arguments:  
```
./StereoCam.out -md 7 -vf -e 6000 -y 10 -t 100000 -f 2 -hd -o 'appsrc name=_  caps="video/x-raw, format=(string)RGB, width=(int)1024, height=(int)768"! videoconvert ! fpsdisplaysink name=#'
```

To stream video with h264 codec and receive with VLC run:  
```
./StereoCam.out -md 7 -vf -e 6000 -y 10 -t 100000 -f 2 -hd -o 'appsrc name=_ ! videoconvert ! v4l2h264enc ! video/x-h264,level=(string)4 ! rtph264pay config-interval=10 pt=96 ! udpsink host={DESTINATION_IP} port=5000'  
```
Create video.sdp file with text:  
```
v=0  
m=video 5000 RTP/AVP 96  
c=IN IP4 127.0.0.1  
a=rtpmap:96 H264/90000
```
and open it with VLC
