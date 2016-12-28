if [ $# -ne 3 ]
then
    echo "Syntax:\$program ip udp_port mp4_file_path"
    echo "This program sends MP4 media to UDP on destined IP"
    echo " For example $program 127.0.0.1 10000 /home/ubuntu/sample.mp4"
    exit
fi

echo "$1:$2"
MACHINE_IP=$1
UDP_PORT=$2
MP4_FILE_PATH=$3
RTCP_PORT=`expr $2 + 1`
echo $UDP_PORT:$RTCP_PORT

for i in `seq 1 10000`;
do
echo "Playing $MP4_FILE_PATH: $i time"
gst-launch-1.0 -v filesrc location=$MP4_FILE_PATH ! decodebin ! videoconvert  \
! video/x-raw ,format=I420 \
! x264enc  tune=zerolatency byte-stream=true bitrate=90000 \
! video/x-h264,profile=main \
! h264parse \
! queue min-threshold-time=5000000000 max-size-buffers=600 max-size-bytes=100000 max-size-time=8000000000 \
! rtph264pay config-interval=1 pt=96 \
! rtpbin.send_rtp_sink_0 \
\
rtpbin name=rtpbin do-retransmission=true \
rtpbin.send_rtp_src_0  ! udpsink clients=$MACHINE_IP:$UDP_PORT \
rtpbin.send_rtcp_src_0 ! udpsink clients=$MACHINE_IP:$RTCP_PORT sync=false async=false
done

