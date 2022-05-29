extends Camera2D

var triggered = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func _process(delta):
	$Label.modulate.a = lerp($Label.modulate.a, 0, delta * 0.75)
	if $Label.modulate.a <= 0.05 and not triggered:
		triggered = true
		Wiggle.change_scene_to_named_level("SoloLine")
		CAT.music.play_new_track(CAT.music.thunder)
