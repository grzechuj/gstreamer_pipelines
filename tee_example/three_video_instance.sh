#!/bin/bash
#
#  Check Image two_video_instance.png for Graphical explanation 
#
gst-launch-1.0 videotestsrc ! videoconvert ! tee name=t ! queue ! autovideosink t. ! tee name=newt ! queue ! autovideosink newt. ! queue ! autovideosink
