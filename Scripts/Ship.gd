extends KinematicBody2D

enum ShipState { Normal, Squid, Overheat }
var ship_state = ShipState.Normal

export var power_push: float = 80
var steering_str_normal: float = 380
var steering_str_overheating: float = 80
var steering_follow_multiplier: float = 0.8

var friction: float = 2
var friction_holding: float = 0.5
var drag: float = 0.125
var drag_holding: float = 0.035
var drag_gate: float = 180

export var C_NORMAL: Color
export var C_SQUID: Color
export var C_OVERHEAT: Color

var velocity: Vector2 = Vector2.ZERO
var min_speed = 30
var energy: float = 100

var steering_input: float = 0

var player_copy

var passing_normal = true
var passing_squid = false
var passing_oh = false


func _ready():
	CAT.player = self
	player_copy = PackedScene.new()
	player_copy.pack(self)
	CAT.camera.target_position = self.position


func _process(delta):
	animations()
	if Input.is_action_just_pressed("r"):
		reset_player()


func _physics_process(delta):
	set_collision_mask_bit(1, !passing_normal)  #normal wall
	set_collision_mask_bit(2, !passing_squid)  #squid wall
	set_collision_mask_bit(3, !passing_oh)  #oh wall
	var steering_str = steering_str_normal

	if ship_state == ShipState.Normal:
		modulate = C_NORMAL
		steering_str = steering_str_normal

		passing_normal = true
		passing_squid = false
		passing_oh = false

	if ship_state == ShipState.Squid:
		modulate = C_SQUID
		steering_str = steering_str_overheating
		passing_normal = false
		passing_squid = true
		passing_oh = false

	steering_input = Util.get_input_axis().x
	rotation_degrees += steering_input * steering_str * delta
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
	if ship_state == ShipState.Normal or ship_state == ShipState.Squid:
		if Input.is_action_just_pressed("ui_accept"):
			boost()
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
			print("Collision with " + collision.collider.name + " !")
			reset_player()


var squid_saftey = 0.12
var squid_saftey_t = 0.0


func reset_player():
	queue_free()
	Wiggle.get_current_scene_node().add_child(player_copy.instance())


func boost():
	velocity += Vector2.RIGHT.rotated(rotation) * power_push
	$BoostVFX.emitting = true


func animations():
	$AnimatedSprite.animation = "normal"
	$LowFirctionVFX.emitting = false
	if ship_state == ShipState.Squid and Input.is_action_pressed("ui_select"):
		$AnimatedSprite.animation = "aero"
		$LowFirctionVFX.emitting = true


func _on_SquidBooster_body_entered(body: Node):
	if ship_state == ShipState.Squid:
		boost()
