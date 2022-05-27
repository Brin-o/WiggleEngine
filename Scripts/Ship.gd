extends KinematicBody2D


export var power_push : float = 80
var steering_str_normal : float = 380
var steering_str_overheating : float = 80
var steering_follow_multiplier : float = 0.8


var friction : float = 2
var friction_holding : float = 0.5
var drag : float = 0.125
var drag_holding : float = 0.035
var drag_gate : float = 180



export var overheating : bool = false

export var C_NORMAL : Color
export var C_OVERHEATING : Color

var velocity : Vector2 = Vector2.ZERO
var min_speed = 30
var energy : float = 100

var steering_input : float = 0


var player_copy
func _ready():
	CAT.player = self
	player_copy = PackedScene.new()
	player_copy.pack(self)


func _process(delta):
	animations()
	if Input.is_action_just_pressed("r"):
		reset_player()


func _physics_process(delta):

	var steering_str = steering_str_normal
	if overheating: 
		modulate =  C_OVERHEATING
		steering_str = steering_str_overheating
		set_collision_mask_bit(1, false)

	else:
		modulate = C_NORMAL
		set_collision_mask_bit(1, true)


	steering_input = Util.get_input_axis().x
	rotation_degrees += steering_input*steering_str*delta
	velocity = velocity.rotated(steering_input*deg2rad(steering_str*steering_follow_multiplier)*delta)
	


	if velocity.length() > min_speed:
		var f = friction
		if overheating:
			f = friction_holding

		var d = drag
		if velocity.length() >= drag_gate: 
			if drag_gate: 
				d = drag_holding
		
			velocity = lerp(velocity, velocity.normalized()*min_speed, d)
		
		velocity += -velocity.normalized()*f

	
		

	if Input.is_action_just_pressed("ui_accept"):
		boost()
	if Input.is_action_pressed("ui_select"):
		overheating = true
	if Input.is_action_just_released("ui_select"):
		oh_saftey_t = oh_saftey
		#overheating = false
	if oh_saftey_t > 0:
		oh_saftey_t -= delta
		if oh_saftey_t <= 0:
			oh_saftey_t = 0
			overheating = false
	
	if velocity.length() > min_speed:
		$Direction.global_rotation = lerp_angle($Direction.global_rotation, velocity.angle(), delta*10)
	else:
		$Direction.global_rotation = lerp_angle($Direction.global_rotation, global_rotation, delta*2)
	#move_and_slide(veloctiy)
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.is_in_group("wall"):
				reset_player()
				
var oh_saftey = 0.12
var oh_saftey_t = 0.0
				
func reset_player():
	queue_free()
	Wiggle.get_current_scene_node().add_child(player_copy.instance())


func boost():
	velocity += Vector2.RIGHT.rotated(rotation) * power_push
	$BoostVFX.emitting = true


func _on_Overheatbooster_body_entered(body:Node):
	if(overheating):
		boost()



func animations():
	$AnimatedSprite.animation = "normal"
	$LowFirctionVFX.emitting = false
	if overheating and Input.is_action_pressed("ui_select"):
		$AnimatedSprite.animation = "aero"
		$LowFirctionVFX.emitting = true;
