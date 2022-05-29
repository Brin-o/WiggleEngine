extends Area2D

export var auto_mode: bool = true
export(String) var next_level = 2
onready var tween: Tween = $Tween
var rotation_speed = 70



var ending = false


func _ready():
	rotation_speed *= rand_range(0.8, 1.2)


func _on_LevelEnd_body_entered(body: Node):
	if body.is_in_group("player") and not ending:
		ending = true
		player.velocity = Vector2.ZERO
		tween.interpolate_property(
			self, "scale", null, Vector2.ONE * 32, 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT
		)
		tween.start()
		rotation_speed *= rand_range(1.5, 2.5)
		#Wiggle.change_scene_to_level(next_level)


var player


func _on_Sucker_body_entered(body: Node):
	if body.is_in_group("player"):
		player = body


func _process(delta):
	rotation_degrees += rotation_speed * delta
	if is_instance_valid(player):
		player.position = lerp(player.position, position, delta * 4)
		player.look_at(global_position)


func _on_Tween_tween_completed(object: Object, key: NodePath):
	if auto_mode:
		var next_one = CAT.current_level + 1
		next_one = wrapi(next_one, 0, CAT.levels.size())
		Wiggle.change_scene_to_named_level(CAT.levels[next_one])
		CAT.current_level += 1
	else:
		Wiggle.change_scene_to_named_level(next_level)
