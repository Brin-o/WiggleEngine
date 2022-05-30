extends Area2D

export var auto_mode: bool = true
export(String) var next_level = 2
onready var tween: Tween = $Tween
var rotation_speed = 70

var ending = false
var connected = false


func _ready():
	rotation_speed *= rand_range(0.8, 1.2)
	print("resetting end thingy")


func _r():
	ending = false
	player = null
	pass


func _on_LevelEnd_body_entered(body: Node):
	if body.is_in_group("player") and not ending:
		CAT.ui.level_prog.flash_completed()
		$SFX.pitch_scale = rand_range(0.9, 1.1)
		$SFX.playing = true
		ending = true
		CAT.player.velocity = Vector2.ZERO
		tween.interpolate_property(
			self, "scale", null, Vector2.ONE * 32, 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT
		)
		tween.start()
		rotation_speed *= rand_range(1.5, 2.5)
		#Wiggle.change_scene_to_level(next_level)


var player


func _on_Sucker_body_entered(body: Node):
	if body.is_in_group("player"):
		player = body


func _process(delta):
	if !connected and is_instance_valid(CAT.player):
		CAT.player.connect("crashed", self, "_r")
		connected = true

	rotation_degrees += rotation_speed * delta
	if is_instance_valid(player):
		player.position = lerp(player.position, position, delta * 8)
		player.look_at(global_position)


func _on_Tween_tween_completed(object: Object, key: NodePath):
	if auto_mode:
		var next_one = CAT.current_level + 1
		next_one = wrapi(next_one, 0, CAT.levels.size())
		var next_name = CAT.levels[next_one]
		print("Loading next level named, ", next_name)
		if next_name == "SquidTight":
			CAT.music.switch_track(CAT.music.threeam)
			Wiggle.recolor.set_current_palette(Wiggle.recolor.palettes.nyx)

		if next_name == "MovingLine":
			print("i'm supposed to load the last song now!")
			CAT.music.switch_track(CAT.music.feeling)
			Wiggle.recolor.set_current_palette(Wiggle.recolor.palettes.destatur, 1)

		if next_name == "End":
			Wiggle.recolor.set_current_palette(Wiggle.recolor.palettes.grays, 1)
			CAT.music.fade_out()

		# elif next_name == "TurnSwapper":
		# 	Wiggle.recolor.set_current_palette(Wiggle.recolor.palettes.destatur, 1)
		# 	CAT.music.switch_track(CAT.music.castle)

		Wiggle.change_scene_to_named_level(next_name)
		CAT.current_level += 1

	else:
		Wiggle.change_scene_to_named_level(next_level)


func _on_LevelEnd_body_exited(body: Node):
	if body.is_in_group("player"):
		player = null
