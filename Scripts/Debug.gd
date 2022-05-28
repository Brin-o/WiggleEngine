extends Label


func _process(delta):
	var player = CAT.player
	if is_instance_valid(player):
		text = "Speed: " + Util.round_decimal_str(player.velocity.length(), 0) + "\n"
		text += "State: " + str(player.ship_state) + "\n"
		text += "Normal pass: " + str(player.passing_normal) + "\n"
		text += "Squid pass: " + str(player.passing_squid) + "\n"
		text += "OH pass: " + str(player.passing_oh) + "\n"
