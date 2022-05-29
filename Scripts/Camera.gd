extends Camera2D

var player
var target_position := Vector2.ZERO
onready var org_pos = position

export var speed_gate := 90
var follow_speed_fast = 10
var follow_speed_static = 4

var shake_p: float = 0
var shake_p_rolloff: float = 10
var shake_r: float = 0
var shake_r_rolloff: float = 18

var angle_shake: float
var angle_turn: float
var angle_turn_target: float
var angle_offset: float = 2
var angle_offset_slider = 1.5

var distance_gate = 50


func _ready():
	CAT.camera = self
	#target_position = position
	angle_offset = rand_range(-angle_offset_slider, angle_offset_slider)


func _process(delta):
	player = Util.find_player(false)
	if player.speed > 0:
		zoom = lerp(zoom, Vector2.ONE, delta * 16)

	var follow_speed = follow_speed_static

	if player.velocity.length() > speed_gate:
		var speed_mod = Util.remap(player.velocity.length(), speed_gate, 250, 10, 100)
		target_position = player.global_position + player.velocity.normalized() * speed_mod
		follow_speed = follow_speed_fast

	elif global_position.distance_to(player.global_position) > distance_gate and player.speed > 0:
		target_position = player.global_position + player.velocity.normalized() * 50
	global_position = lerp(global_position, target_position, delta * follow_speed)

	#shake code
	global_position.x += rand_range(-shake_p, shake_p)
	global_position.y += rand_range(-shake_p, shake_p)
	if shake_p > 0:
		shake_p = lerp(shake_p, 0, shake_p_rolloff * delta)

	#rotation
	angle_shake += rand_range(-shake_r, shake_r)
	if shake_r > 0.2:
		shake_r = lerp(shake_r, 0, shake_r_rolloff * delta)
	else:
		angle_shake = lerp(global_rotation_degrees, 0, delta * shake_r_rolloff)

	var p_spd = Util.remap(CAT.player.speed, 50, 200, 0, 2)
	angle_turn = lerp(angle_turn, angle_turn_target, delta * p_spd)
	angle_turn_target = Util.get_input_axis().x * -4
	rotation_degrees = angle_shake + angle_turn + angle_offset
