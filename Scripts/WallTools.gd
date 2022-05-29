extends StaticBody2D

export var rotating_speed: float = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var starting_rot = rotation_degrees
var connected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	#if rotating_speed != 0:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !connected and is_instance_valid(CAT.player):
		CAT.player.connect("crashed", self, "_r")
		connected = true

	if CAT.player.speed > 0:
		rotation_degrees += rotating_speed * delta


func _r():
	rotation_degrees = starting_rot
