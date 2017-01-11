#!/bin/bash
#
#  Check Image two_video_instance.png for Graphical explanation 
#
gst-launch-1.0 videotestsrc ! videoconvert ! tee name=t ! queue ! autovideosink t. ! queue ! autovideosink
