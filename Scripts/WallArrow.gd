tool
extends Sprite

export var custom: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func _process(delta):
	if custom:
		return
	global_scale = Vector2.ONE
	var par = get_parent()
	#var v = Vector2(cos(deg2rad(par.rotation_degrees)), sin(deg2rad(par.rotation_degrees)))
	#global_position = v * par.scale.y + par.global_position
	position.y = -par.scale.y / 80
