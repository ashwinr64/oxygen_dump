# $1: wave file to write
# $2: audio source
#     0: default
#     1: mic
#     2: uplink
#     3: downlink
#     4: call
#     5: camcorder
#     6: recognition
#     7: communication
#     8: remote submix
#     9: fm
#    -1: raw primic
#    -2: raw topmic
#    -3: raw backmic
#    -4: raw frontmic
# $3: sample rate(Hz)
# $4: sample bit
# $5: channel number
# $6: capture duration(s)
# tinycap file.wav [-D card] [-d device] [-c channels] [-r rate] [-b bits] [-p period_size] [-n n_periods] [-t duration]
# sample usage: capture_audio.sh /data/test1.wav -1 48000 16 1 10
 

function enable_main_mic
{
	echo "enabling main mic"
	tinymix 'DEC1 MUX' 'ADC2'
	tinymix 'ADC2 MUX' 'INP3'
	tinymix 'MultiMedia1 Mixer TERT_MI2S_TX' 1
}

function disable_main_mic
{
	echo "disabling main mic"
	tinymix 'DEC1 MUX' 'ZERO'
	tinymix 'ADC2 MUX' 'ZERO'
	tinymix 'MultiMedia1 Mixer TERT_MI2S_TX' 0

}

function enable_top_mic
{
	echo "enabling top mic"
	tinymix 'DEC1 MUX' 'ADC1'
	tinymix 'MultiMedia1 Mixer TERT_MI2S_TX' 1
}

function disable_top_mic
{
	echo "disabling top mic"
	tinymix 'DEC1 MUX' 'ZERO'
	tinymix 'MultiMedia1 Mixer TERT_MI2S_TX' 0
}

function enable_back_mic
{
	echo "PHONE HAS NO BACK MIC!"
}

function disable_back_mic
{
	echo "PHONE HAS NO BACK MIC!"
}

function enable_front_mic
{
	echo "PHONE HAS NO FRONT MIC!"
}

function disable_front_mic
{
	echo "PHONE HAS NO FRONT MIC!"
}


case "$2" in
	"-1" )
		enable_main_mic
		;;
	"-2" )
		enable_top_mic
		;;
esac

# start recording
tinycap $1 -c $5 -r $3 -b $4 -t $6
ret=$?
if [ $ret -ne 0 ]; then
	echo "tinycap done, return $ret"
fi

# tear down
case "$2" in
	"-1" )
		disable_main_mic
		;;
	"-2" )
		disable_top_mic
		;;
esac
exit 0
