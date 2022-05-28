extends Node

# ---------------
# JUICE FUNCTIONS
# ---------------


# HITSTOP
# stops the node from functioning for a certian amount of time
func hit_stop(_node, _time):
	set_pause_scene(_node, true)
	yield(get_tree().create_timer(_time), "timeout")
	set_pause_scene(_node, false)


# PAUSE FUNCTIONS - Credit: https://old.reddit.com/r/godot/comments/bkrtzi/utility_functions_to_pause_a_scenea_node/
# (UN)PAUSE SINGLE NODE
func set_pause_node(node: Node, pause: bool) -> void:
	node.set_process(!pause)
	node.set_process_input(!pause)
	node.set_process_internal(!pause)
	node.set_process_unhandled_input(!pause)
	node.set_process_unhandled_key_input(!pause)


# (UN)PAUSE A SCENE
# Ignored childs is an optional argument, that contains the path of nodes whose state must not be altered by the function
func set_pause_scene(rootNode: Node, pause: bool, ignoredChilds: PoolStringArray = [null]):
	set_pause_node(rootNode, pause)
	for node in rootNode.get_children():
		if not (String(node.get_path()) in ignoredChilds):
			set_pause_scene(node, pause, ignoredChilds)


# FREEZE FRAMES
var t: float = 0
var t_gate: float = 1


func _ready():
	randomize()
	pause_mode = Node.PAUSE_MODE_PROCESS


func freeze(_seconds: float):
	t = 0
	t_gate = _seconds
	get_tree().paused = true


func _process(delta):
	#if(Input.is_action_just_pressed("r")): restart()
	if get_tree().paused == true:
		t += delta
		if t >= t_gate:
			t = 0
			get_tree().paused = false


# -----------------
# FIND FUNCTIONS
# -----------------
# finds game objects that are common in my programming stlye :)
# no clue if this is smart but it works


func find_player(verbose = true):
	var ply = get_tree().get_nodes_in_group("player")
	if ply.size() == 0:
		#print("ERROR: Can't find player node!")
		return null
	else:
		if verbose:
			print("player found!")
		return ply[0]


func find_camera():
	var cameras = get_tree().get_nodes_in_group("camera")
	return cameras[0]


func find_level():
	var levels = get_tree().get_nodes_in_group("level")
	return levels[0]


#returns the first member of the group
func find(tag):
	var group = get_tree().get_nodes_in_group(tag)
	return group[0]


# -----------------
# RETURN FUNCTIONS
# -----------------
# just a short hand for getting 0.001 * ms
func time() -> float:
	return OS.get_system_time_msecs() * 0.001


# Returns a random variable from given arguments (give them in an array)
func choose(choices: Array):
	var r = round(rand_range(0, choices.size() - 1))
	return choices[r]


# Returns random argument, but respect their wieght (every second arugment) Format as: choose_weigthed(a1, 7, a2, 3)
# Based on: https://yal.cc/gamemaker-weighted-choose/
# TODO: finsih this
func choose_weighted(choices: Array):
	printerr("CHOOSE WEIGHTED: This function is not yet finished")
	# if choices.size()%2 != 0:
	# 	return printerr("CHOOSE WEIGHTED: Uneven amount of arguments given. You are probablly missing a weight")
	# else:
	# 	var n = 0
	# 	for i in range(0,choices.size()):
	# 		print(i)
	# 		pass
	# 	return true


# Normalizes any number to an arbitrary range
# by assuming the range wraps around when going below min or above max
func normalize_repeating(value: float, start: float, end: float):
	var _width = end - start
	var _offset = value - start
	return (_offset - ((_offset / _width) * _width)) + start


# returns degs from a vector 2
func vector2deg(_vec: Vector2) -> float:
	return rad2deg(_vec.angle())


# takes a vector and returns it rotated by _rot degrees
func vector2rotated(_vec: Vector2, _rot: float) -> Vector2:
	return _vec.rotated(deg2rad(_rot))


#im not sure if this works lol? takes a deg. angle and returns it as a directional vector2. 0 returns Vector2.RIGHT
func angle2vector(_angle: float) -> Vector2:
	var _x = cos(deg2rad(_angle))
	var _y = sin(deg2rad(_angle))
	return Vector2(_x, _y)


# sign function but if given 0 it returns 1
func sign_positive(_num: float) -> int:
	var a = sign(_num)
	if a == 0:
		a = 1
	return a


# sign function but if given 0 it returns -1
func sign_negative(_num: float) -> int:
	var a = sign(_num)
	if a == 0:
		a = -1
	return a


# returns 1 or -1 randomly
func rand_one():
	var r = rand_range(0, 1)
	if r > 0.5:
		return -1
	else:
		return 1


# returns an integer from 0-A1 or from A1-A2
func rand_int(a1: int, a2 = null):
	if a2 != null:
		return round(rand_range(a1, a2))
	else:
		return round(rand_range(0, a1))


# lerp delta
# based on https://www.construct.net/en/blogs/ashleys-blog-2/using-lerp-delta-time-924
# frame-rate indipendant lerp where t should be 0-1
func lerp_delta(delta, a, b, t):
	var _t = 1 - t
	return lerp(a, b, 1 - pow(_t, delta))


func round_decimal(number, decimal_count: int):
	var tenner = pow(10, decimal_count)
	return float(round(number * tenner) / tenner)


func round_decimal_str(number, decimal_count: int):
	return str(float(round_decimal(number, decimal_count)))


# Finds ANY node, children or not of other nodes
func find_node_by_name(node_name):
	return get_tree().get_root().find_node(node_name)


# gets the node by name. Can NOT find any children
func get_node_by_name(node_name):
	return get_tree().get_root().get_node(get_tree().current_scene.name + "/" + node_name)


# Sends A towards B regardless if that requieres addition or substraction
func towards(a, b, rate):
	if a + rate < b:
		return a + rate
	if a - rate > b:
		return a - rate
	return b


# Remaps the number from its old scale to new scale (eg. a 4 on a scale of 1-10 will become a 2 on a scale of 1-5). The value is clamped, with the min/max being new_bottom/new_top.
func remap(value: float, old_bottom: float, old_top: float, new_bottom: float, new_top):
	return clamp(
		new_bottom + (value - old_bottom) * (new_top - new_bottom) / (old_top - old_bottom),
		new_bottom,
		new_top
	)


# Remaps the number from its old scale to new scale (eg. a 4 on a scale of 1-10 will become a 2 on a scale of 1-5)
func remap_unclamped(value: float, old_bottom: float, old_top: float, new_bottom: float, new_top):
	return new_bottom + (value - old_bottom) * (new_top - new_bottom) / (old_top - old_bottom)


# --------------
# WAVE FUNCTIONS
# --------------
# returns sin/cos waves
# pass in a time parameter, magnitude (how far do you want it to go), frequency in seconds, delay (how much should it start at
func wave_sin(t, magnitude, freq, delay = 0):
	var new_freq = 1 / freq
	var wave = sin((t + delay) * new_freq) * magnitude
	return wave


func wave_cos(t, magnitude, freq, delay = 0):
	var new_freq = 1 / freq
	var wave = cos((t + delay) * new_freq) * magnitude
	return wave


# -------------------
# ANIMATION FUNCTIONS
# -------------------
# Changes the sacle of the node following Squash & Stretch aniamtion principle
# applied any time a nodes scale is not 1
# use inside of _process
func squash_to(delta, node: Node2D, squash_speed: float, target_scale: float):
	var target_x = lerp(node.scale.x, target_scale, delta * squash_speed)
	var target_y = target_scale / target_x
	node.scale = Vector2(target_x, target_y)


func rotate_to(delta, node: Node2D, speed, target_rotation):
	node.rotation_degrees = lerp(node.rotation_degrees, target_rotation, delta * speed)


#returns a value form -factor to + factor to be used in sprite scale for a breathing effects
func ss_breath(scale_factor, freq) -> Vector2:
	var _x = sin(time() * freq) * scale_factor
	var _y = -_x
	return Vector2(_x, _y)


func get_input_axis():
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()


## GENERAL LOADING FUNCTIONS
func load_level(num: int):
	get_tree().change_scene("res://Levels/Level" + str(num) + ".tscn")


# Restarts current scene
func restart():
	get_tree().reload_current_scene()


## NOTES ##
# not actual code just notes of what i find confusing in godot and need to check in on every so often
#
# NOTE - QUICK TIMER
# a shortcut for creating timers works like this
func note_timer():
	# code that you want before the timer
	yield(get_tree().create_timer(0.3), "timeout")
	# code that you want after the timer


# NOTE - SPRING CODE
# I actually have no fucking clue how this works, thank ash the god of juice
func note_spring(delta, position = 0, speed = 0, target = 100, springiness = 15, excitement = 8):
	speed = lerp(speed, (target - position) * springiness, delta * excitement)
	position.x += speed * delta
