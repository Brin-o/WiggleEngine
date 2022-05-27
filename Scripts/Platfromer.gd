extends KinematicBody2D


var can_move := true

var input := 0
var friction = 12
var air_friction = 5
var gravity = 10

var jump_str = 100
var jumped := false
var extended_jump_t := 0.0
var extended_jump_gate = 0.2
var jump_count := 1

var acc = 40
var air_acc = 55
var max_spd = 65

var velocity : Vector2 = Vector2.ZERO


var grounded := false
var coyoting  := false
var coyote_time = 0.15

# Called when the node enters the scene tree for the first time.
func _ready():
	CAT.player = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input = Util.get_input_axis().x
	if is_on_floor() and !grounded:
		grounded = true
	if !is_on_floor() and grounded:
		grounded = false
		coyoting = true
		yield(get_tree().create_timer(coyote_time), "timeout")
		coyoting = false

func _physics_process(delta):
	if !can_move: return
	if input != 0:
		var a = acc
		if !grounded: a = air_acc
		velocity.x += input*a
	else:
		var fric = friction
		if !grounded: fric = air_friction
		velocity.x = lerp(velocity.x, 0, delta*fric)
	velocity.x = clamp(velocity.x, -max_spd,max_spd)
	var can_jump = grounded or coyoting
	var gravity_mod = 1
	if Input.is_action_just_pressed("ui_select") and can_jump:
		velocity.y = -jump_str
		jumped = true
	if Input.is_action_pressed("ui_select") and jumped:
		gravity_mod = 0.4
		extended_jump_t += delta
		if extended_jump_t >= extended_jump_gate:
			jumped = false
			extended_jump_t = 0
	if Input.is_action_just_released("ui_select"):
		jumped = false
		gravity_mod = 1
	velocity.y += gravity * gravity_mod
	velocity = move_and_slide(velocity, Vector2.UP)

	pass
