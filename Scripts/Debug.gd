extends Label

export var output_debug :bool = false
func _process(delta):
	if output_debug:
		var player = CAT.player
		if is_instance_valid(player):
			text = "Speed: " + Util.round_decimal_str(player.velocity.length(), 0) + "\n"
			text += "Direction: " + str(player.transform.x) + "\n"
			text += "V Direction: " + str(player.velocity.normalized()) + "\n"
