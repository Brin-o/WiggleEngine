extends "res://Scripts/WallTools.gd"

var mod = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_PlusTrigger_body_entered(body: Node):
	if body.is_in_group("player"):
		mod = 1


func _on_MinusTrigger_body_entered(body: Node):
	if body.is_in_group("player"):
		mod = -1
