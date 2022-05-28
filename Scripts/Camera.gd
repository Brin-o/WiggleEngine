extends Camera2D

var player
var target_position := Vector2.ZERO
onready var org_pos = position


func _process(delta):
	player = Util.find_player(false)
	global_position = lerp(
		global_position, player.global_position + player.velocity.normalized() * 10, delta * 10
	)
