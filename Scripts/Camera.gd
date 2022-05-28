extends Camera2D

var player
var target_position := Vector2.ZERO
onready var org_pos = position

export var speed_gate := 90
var follow_speed_fast = 10
var follow_speed_static = 4


func _ready():
	CAT.camera = self
	#target_position = player.global_position


func _process(delta):
	player = Util.find_player(false)
	var follow_speed = follow_speed_static
	if player.velocity.length() > speed_gate:
		var speed_mod = Util.remap(player.velocity.length(), speed_gate, 250, 10, 100)
		target_position = player.global_position + player.velocity.normalized() * speed_mod
		follow_speed = follow_speed_fast
	global_position = lerp(global_position, target_position, delta * follow_speed)
