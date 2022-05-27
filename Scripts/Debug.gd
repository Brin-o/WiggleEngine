extends Label





func _process(delta):
	var player = CAT.player
	if is_instance_valid(player):
		text = "Speed: " + Util.round_decimal_str(player.velocity.length(), 0) + "\n"
		text += "OH: " + str(player.overheating)
