extends Area2D


var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var input = Util.get_input_axis()
	input.y = 0 
	if input == Vector2.ZERO:
		velocity = lerp(velocity, Vector2.ZERO, delta*10)
	else:
		velocity = input*delta*100
	velocity = velocity.clamped(10)
	position += velocity
