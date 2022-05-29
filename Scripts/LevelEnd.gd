extends Area2D

export var auto_mode: bool = true
export(String) var next_level = 2


func _on_LevelEnd_body_entered(body: Node):
	if body.is_in_group("player"):
		#Wiggle.change_scene_to_level(next_level)
		if auto_mode:
			var next_one = CAT.current_level + 1
			next_one = wrapi(next_one, 0, CAT.levels.size())
			Wiggle.change_scene_to_named_level(CAT.levels[next_one])
			CAT.current_level += 1
		else:
			Wiggle.change_scene_to_named_level(next_level)


var player


func _on_Sucker_body_entered(body: Node):
	if body.is_in_group("player"):
		player = body


func _process(delta):
	if is_instance_valid(player):
		player.position = lerp(player.position, position, delta * 4)
		player.look_at(global_position)
