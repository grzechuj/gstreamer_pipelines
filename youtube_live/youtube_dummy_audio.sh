if [ $# -ne 1 ]
then
    echo "Syntax:\$program rtpm_uri"
    echo "For example $sh youtube_dummy_audio.sh rtmp://a.rtmp.youtube.com/live2/your_secret_key"
    exit
fi
RTMP_URI=$1
gst-launch-1.0 \
v4l2src device=/dev/video0 do-timestamp=true \
    ! video/x-raw,framerate=30/1,width=640,height=480 \
    ! videoconvert \
    ! video/x-raw,format=I420  \
    ! videorate \
    ! video/x-raw,framerate=15/1 \
    ! videoflip method=none \
    ! identity name=ZMQ_EMITTING_POINT \
    ! clockoverlay halignment=right valignment=bottom time-format="%Y-%m-%d %H:%M:%S" \
    ! queue leaky=downstream  \
    ! x264enc key-int-max=60 \
    ! video/x-h264,profile=main \
    ! h264parse \
    ! queue max-size-buffers=600 ! out_video. \
      tee name=out_video \
    ! queue \
    ! mux.video \
      out_video. \
    ! queue \
    ! flv.video \
      flvmux name=flv streamable=true \
    ! queue \
    ! rtmpsink location="$RTMP_URI" \
      splitmuxsink name=mux faststart=true faststart-file=/mnt/scorer/stream.pre \
      max-size-time=600000000000 \
      location=/tmp/stream%d sync=false \
      audiotestsrc wave=silence ! queue ! audioconvert ! voaacenc ! aacparse ! flv. 

