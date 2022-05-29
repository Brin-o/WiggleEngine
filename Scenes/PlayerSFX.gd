extends Node

onready var player: Ship = $".."
export(PackedScene) var boostSFX


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Engine.volume_db = Util.remap(player.speed, player.min_speed, 160, -8, 0)
	$Engine.pitch_scale = Util.remap(player.speed, player.min_speed, 300, 0.2, 0.8)
	if not $Engine.playing:
		$Engine.playing = true


func _on_Player_boost_fired(source):
	print("boost called")
	if $Boost.playing:
		$Boost.playing = false
	if source == "player":
		var p = Util.remap(player.speed, 0, 200, 0.5, 0.8)
		$Boost.pitch_scale = p * rand_range(1, 1.05)
	if source == "wall":
		$Boost.pitch_scale = rand_range(0.2, 0.3)
	$Boost.play()


func _on_Player_crashed():
	if $Crash.playing:
		$Crash.playing = false
	$Crash.pitch_scale = rand_range(0.8, 1.2)
	$Crash.play()
