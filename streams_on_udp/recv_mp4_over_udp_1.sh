if [ $# -ne 3 ]
then
    echo "Syntax:\$program local_ip local_ifc local_udp_port "
    echo "This program recieves RTP Traffic send on UDP Port at local machine"
    echo " For example $program 127.0.0.1 lo 10000"
    exit
fi

MULTICAST_IP_ADDR=$1
MULTICAST_IFACE=$2
MULTICAST_UDP_PORT=$3

gst-launch-1.0 udpsrc multicast-group=$MULTICAST_IP_ADDR auto-multicast=true port=$MULTICAST_UDP_PORT multicast-iface=$MULTICAST_IFACE caps="application/x-rtp, payload=96" !  rtph264depay ! h264parse ! identity ! avdec_h264 max-threads=2 !autovideosink

#gst-launch-1.0 -v udpsrc multicast-group=$MULTICAST_IP_ADDR auto-multicast=true port=$MULTICAST_UDP_PORT multicast-iface=$MULTICAST_IFACE ! video/x-h264 ! tsdemux !  queue ! h264parse ! avdec_h264 max-threads=2 !autovideosink
#gst-launch-1.0 udpsrc multicast-group=$MULTICAST_IP_ADDR auto-multicast=true port=$MULTICAST_UDP_PORT multicast-iface=$MULTICAST_IFACE caps="application/x-rtp, payload=96" ! queue ! rtph264depay ! avdec_h264 max-threads=2 !xvimagesink 
#sync=0
