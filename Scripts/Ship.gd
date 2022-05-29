class_name Ship
extends KinematicBody2D

signal boost_fired(source)
signal crashed

enum ShipState { Normal, Squid, Overheat }
var ship_state = ShipState.Normal

var accepting_input: bool = true
export var power_push: float = 100
export var power_wall: float = 120
var speed: float = 0

var steering_str_normal: float = 400
var steering_str_squid: float = 60
var steering_str_overheating: float = 300

var steering_follow_m_normal: float = 0.8
var steering_follow_m_squid: float = 1
var steering_follow_m_overheating: float = 1.2

var friction: float = 2
var friction_holding: float = 0.5
var drag: float = 0.125
var drag_holding: float = 0.035
var drag_gate: float = 200

export var C_NORMAL: Color
export var C_SQUID: Color
export var C_OVERHEAT: Color

var velocity: Vector2 = Vector2.ZERO
var min_speed = 50

var steering_input: float = 0

var player_copy

var passing_normal = true
var passing_squid = false
var passing_oh = false


func _ready():
	CAT.player = self
	CAT.camera.global_position = self.global_position
	CAT.camera.target_position = self.global_position


func _process(delta):
	b_shake_p = lerp(b_shake_p, 0, delta * 6)
	b_shake_r = lerp(b_shake_r, 0, delta * 6)

	speed = velocity.length()
	animations()
	if Input.is_action_just_pressed("r"):
		reset_player()


func _physics_process(delta):
	set_collision_mask_bit(1, !passing_normal)  #normal wall
	set_collision_mask_bit(2, !passing_squid)  #squid wall
	set_collision_mask_bit(3, !passing_oh)  #oh wall

	var steering_str = steering_str_normal
	var steering_follow_multiplier = steering_follow_m_normal

	if ship_state == ShipState.Normal:
		modulate = C_NORMAL
		steering_str = steering_str_normal
		steering_follow_multiplier = steering_follow_m_normal
		passing_normal = true
		passing_squid = false
		passing_oh = false

	if ship_state == ShipState.Squid:
		modulate = C_SQUID
		steering_str = steering_str_squid
		steering_follow_multiplier = steering_follow_m_squid
		passing_normal = false
		passing_squid = true
		passing_oh = false

	steering_input = Util.get_input_axis().x
	if speed < 1 or !accepting_input:
		steering_input = 0
	rotation_degrees += steering_input * steering_str * delta
	#rotation_degrees -= int(rotation_degrees) % 5
	velocity = velocity.rotated(
		steering_input * deg2rad(steering_str * steering_follow_multiplier) * delta
	)

	if velocity.length() > min_speed:
		var f = friction
		if ship_state == ShipState.Squid:
			f = friction_holding

		var d = drag
		if velocity.length() >= drag_gate:
			if drag_gate:
				d = drag_holding

			velocity = lerp(velocity, velocity.normalized() * min_speed, d)

		velocity += -velocity.normalized() * f

	#movement option
	if (ship_state == ShipState.Normal or ship_state == ShipState.Squid) and accepting_input:
		if Input.is_action_just_pressed("ui_accept"):
			boost(power_push)
			emit_signal("boost_fired", "player")
		if Input.is_action_pressed("ui_select"):
			ship_state = ShipState.Squid
		if Input.is_action_just_released("ui_select"):
			squid_saftey_t = squid_saftey
		if squid_saftey_t > 0:
			squid_saftey_t -= delta
			if squid_saftey_t <= 0:
				squid_saftey_t = 0
				ship_state = ShipState.Normal
	elif ship_state == ShipState.Overheat:
		pass

	#COLLISION
	#var collision = move_and_collide(velocity * delta)
	velocity = move_and_slide(velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("wall"):
			#print("Collision with " + collision.collider.name + " !")
			emit_signal("crashed")
			reset_player()


var squid_saftey = 0.06
var squid_saftey_t = 0.0

onready var start_pos = global_position
onready var start_rot = global_rotation


func reset_player():
	global_position = start_pos
	global_rotation = start_rot
	velocity = Vector2.ZERO
	CAT.camera.angle_offset = rand_range(
		-CAT.camera.angle_offset_slider, CAT.camera.angle_offset_slider
	)


var b_shake_p = 0
var b_shake_r = 0


func boost(amount, _shake_p = 6, _shake_r = 2):
	b_shake_p += _shake_p
	b_shake_r += _shake_r
	CAT.camera.shake_p = b_shake_p
	CAT.camera.shake_r = b_shake_r
	velocity += Vector2.RIGHT.rotated(rotation) * amount
	$BoostVFX.emitting = true


func animations():
	$AnimatedSprite.animation = "normal"
	$LowFirctionVFX.emitting = false
	if ship_state == ShipState.Squid and Input.is_action_pressed("ui_select"):
		$AnimatedSprite.animation = "aero"
		$LowFirctionVFX.emitting = true


func _on_SquidBoost_body_entered(body: Node):
	if ship_state == ShipState.Squid and body.is_in_group("wall"):
		emit_signal("boost_fired", "wall")
		boost(power_wall, 3, 1)


var wall_rotaiton: float = 40


func _on_NormalBoost_body_entered(body: Node):
	if ship_state == ShipState.Normal and body.is_in_group("wall"):
		emit_signal("boost_fired", "wall")

		rotation_degrees += wall_rotaiton * body.mod
		velocity = velocity.length() * Vector2.RIGHT.rotated(deg2rad(rotation_degrees))
		boost(50, 1, 0.5)
