extends AudioStreamPlayer2D

var playback: AudioStreamGeneratorPlayback
var sample_rate: float
var phase: float = 0.0

# Customize your tone here
var tone_frequency: float = 440.0 # 440Hz is standard A4 note
var volume: float = 0.2 # Keep it low so it doesn't hurt your ears

const TWO_PI = 2 * 3.14

func _ready() -> void:
	# Get the sample rate from the generator
	sample_rate = stream.mix_rate
	
	# Start playing to activate the playback buffer
	play()
	playback = get_stream_playback()

func _process(_delta: float) -> void:
	_fill_buffer()

func _fill_buffer() -> void:
	if playback == null:
		return
		
	# Find out how many audio frames we need to fill
	var frames_available = playback.get_frames_available()
	
	# Generate and push the sine wave data
	for i in range(frames_available):
		var sample = sin(phase * TWO_PI) * volume
		playback.push_frame(Vector2(sample, sample)) # Stereo channel (Left, Right)
		
		# Advance the wave phase
		phase = fmod(phase + tone_frequency / sample_rate, 1.0)
