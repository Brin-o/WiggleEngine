extends Node2D


onready var tween:Tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2.ZERO
	CAT.msg = self
	#set_message("test hello helloo")
	randomize()
	set_message("wiggle engine")


func set_message(msg):
	$Label.text = msg
	tween.interpolate_property(self, "scale", null, Vector2.ONE*rand_range(1.1,1.3), 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(self, "rotation_degrees", null, rand_range(5,10)*Util.rand_one(), 0.4, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()


func clear_message():
	tween.interpolate_property(self, "scale", null, Vector2.ZERO, 0.25, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	
