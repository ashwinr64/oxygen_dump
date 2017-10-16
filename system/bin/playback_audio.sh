# $1: wave file to read
# $2: volume(0-15)
# $3: device for output
#     0: current
#     1: speaker
#    12: earpiece
#    -1: raw speaker
#    -2: raw earpiece
#    -3: headphone-48khz-16bit

# tinyplay file.wav [-D card] [-d device] [-p period_size] [-n n_periods]
# sample usage: playback_audio.sh 2000.wav  15 -1

function enable_receiver
{
	echo "enabling receiver"
	tinymix "QUIN_MI2S_RX Audio Mixer MultiMedia1" 1
	tinymix "RCV Mixer RCV" 1
}

function disable_receiver
{
	echo "disabling receiver"
	tinymix "QUIN_MI2S_RX Audio Mixer MultiMedia1" 0
	tinymix "RCV Mixer RCV" 0
}

function enable_speaker
{
	echo "enabling speaker"
	tinymix "QUIN_MI2S_RX Audio Mixer MultiMedia1" 1
	tinymix "SPK Mixer SPK" 1
}

function disable_speaker
{
	echo "disabling speaker"
	tinymix "QUIN_MI2S_RX Audio Mixer MultiMedia1" 0
	tinymix "SPK Mixer SPK" 0
}

function enable_headphone48
{
	echo "enabling headphone-48khz-16bit"
	tinymix 'MI2S_RX Channels' 'Two'
	tinymix 'RX1 MIX1 INP1' 'RX1'
	tinymix 'RX2 MIX1 INP1' 'RX2'
	tinymix 'RDAC2 MUX' 'RX2'
	tinymix 'HPHL' 'Switch'
	tinymix 'HPHR' 'Switch'
	tinymix 'COMP0 RX1' '1'
	tinymix 'COMP0 RX2' '1'
	tinymix 'PRI_MI2S_RX Audio Mixer MultiMedia1' 1
}

function disable_headphone48
{
	echo "disabling headphone-48khz-16bit"
	tinymix 'MI2S_RX Channels' 'One'
	tinymix 'RX1 MIX1 INP1' 'ZERO'
	tinymix 'RX2 MIX1 INP1' 'ZERO'
	tinymix 'RDAC2 MUX' 'ZERO'
	tinymix 'HPHL' 'ZERO'
	tinymix 'HPHR' 'ZERO'
	tinymix 'COMP0 RX1' '0'
	tinymix 'COMP0 RX2' '0'
	tinymix 'PRI_MI2S_RX Audio Mixer MultiMedia1' 0
}

echo "Volume is ignored by this script for now"

if [ "$3" -eq "1" -o "$3" -eq "-1" ]; then
	enable_speaker
elif [ "$3" -eq "12" -o "$3" -eq "-2" ]; then
	enable_receiver
elif [ "$3" -eq "-3" ]; then
	enable_headphone48
fi

tinyplay $1

if [ "$3" -eq "1" -o "$3" -eq "-1" ]; then
	disable_speaker
elif [ "$3" -eq "12" -o "$3" -eq "-2" ]; then
	disable_receiver
elif [ "$3" -eq "-3" ]; then
	disable_headphone48
fi

exit 0
