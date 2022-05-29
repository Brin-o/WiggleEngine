extends AudioStreamPlayer

enum MusicState { playing, switching }
var music_state = MusicState.playing

var starting_vol

export var thunder: AudioStream
export var threeam: AudioStream


# Called when the node enters the scene tree for the first time.
func _ready():
	CAT.music = self
	starting_vol = volume_db
	#playing = true


func _process(delta):
	if Input.is_action_just_released("ui_up"):
		switch_track(threeam)


func switch_track(_m: AudioStream):
	if music_state == MusicState.switching:
		return

	music_state = MusicState.switching
	var delay = 0
	if playing:
		print("fading out")
		delay = 2
		$Tween.interpolate_property(
			self, "volume_db", null, -50, delay, Tween.TRANS_LINEAR, Tween.EASE_IN
		)
		$Tween.start()
	yield(get_tree().create_timer(delay +  0.1), "timeout")
	play_new_track(_m)


func play_new_track(_m: AudioStream):
	stream = _m
	volume_db = -50
	playing = true
	$Tween.interpolate_property(
		self, "volume_db", null, starting_vol, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	$Tween.start()
