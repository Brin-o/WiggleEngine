extends AudioStreamPlayer

enum MusicState { playing, switching }
var music_state = MusicState.playing

var starting_vol

export var thunder: AudioStream
export var threeam: AudioStream
export var castle: AudioStream
export var feeling: AudioStream
var audio_offset
var bpm = 150
var bpm_hit = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	CAT.music = self
	starting_vol = volume_db

	#playing = true


#func _process(delta):
#if Input.is_action_just_released("ui_up"):
#switch_track(threeam)


func switch_track(_m: AudioStream):
	if music_state == MusicState.switching:
		return

	music_state = MusicState.switching
	var delay = 0
	if playing:
		print("Ending current track!")
		delay = 2
		$Tween.interpolate_property(
			self, "volume_db", null, -50, delay, Tween.TRANS_LINEAR, Tween.EASE_IN
		)
		$Tween.start()
	yield(get_tree().create_timer(delay + 0.1), "timeout")
	play_new_track(_m)


func play_new_track(_m: AudioStream):
	stream = _m
	volume_db = -50
	audio_offset = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()

	if _m == threeam:
		bpm = 150
		bpm_hit = 1
	elif _m == thunder:
		bpm = 128
		bpm_hit = 2
	elif _m == castle:
		bpm = 95
		bpm_hit = 2
	elif _m == feeling:
		bpm = 125
		bpm_hit = 1
	print(bpm)
	CAT.background.setup_timer(bpm, bpm_hit)

	play()
	$Tween.interpolate_property(
		self, "volume_db", null, starting_vol, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	$Tween.start()


func fade_out():
	$Tween.interpolate_property(
		self, "volume_db", null, -50, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	$Tween.start()
