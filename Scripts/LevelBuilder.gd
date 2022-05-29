tool
extends Node2D

export var editingActive: bool = false
#export var ignore_on_save: Array
export var level_name = "Test"  #todo: implement this
const LEVEL_PATH = "res://Levels/"

var selected_num: int = 0
var blocks
var selected_node

export(NodePath) var target_path
export var grid_size: int = 16


func _enter_tree():
	var event
	# setup event keys here

	if not InputMap.has_action("editor_switch"):
		InputMap.add_action("editor_switch")
	event = InputEventKey.new()
	event.physical_scancode = KEY_P
	InputMap.action_add_event("editor_switch", event)

	if not InputMap.has_action("editor_cycle"):
		InputMap.add_action("editor_cycle")
	event = InputEventKey.new()
	event.physical_scancode = KEY_N
	InputMap.action_add_event("editor_cycle", event)

	if not InputMap.has_action("editor_rotate"):
		InputMap.add_action("editor_rotate")
	event = InputEventKey.new()
	event.physical_scancode = KEY_M
	InputMap.action_add_event("editor_rotate", event)

	if not InputMap.has_action("editor_scale_up"):
		InputMap.add_action("editor_scale_up")
	event = InputEventKey.new()
	event.physical_scancode = KEY_I
	InputMap.action_add_event("editor_scale_up", event)

	if not InputMap.has_action("editor_scale_down"):
		InputMap.add_action("editor_scale_down")
	event = InputEventKey.new()
	event.physical_scancode = KEY_K
	InputMap.action_add_event("editor_scale_down", event)

	if not InputMap.has_action("editor_scale_left"):
		InputMap.add_action("editor_scale_left")
	event = InputEventKey.new()
	event.physical_scancode = KEY_J
	InputMap.action_add_event("editor_scale_left", event)

	if not InputMap.has_action("editor_scale_right"):
		InputMap.add_action("editor_scale_right")
	event = InputEventKey.new()
	event.physical_scancode = KEY_L
	InputMap.action_add_event("editor_scale_right", event)

	if not InputMap.has_action("editor_shift"):
		InputMap.add_action("editor_shift")
	event = InputEventKey.new()
	event.physical_scancode = KEY_SHIFT
	InputMap.action_add_event("editor_shift", event)

	if not InputMap.has_action("editor_ctrl"):
		InputMap.add_action("editor_ctrl")
	event = InputEventKey.new()
	event.physical_scancode = KEY_CONTROL
	InputMap.action_add_event("editor_ctrl", event)

	if not InputMap.has_action("editor_alt"):
		InputMap.add_action("editor_alt")
	event = InputEventKey.new()
	event.physical_scancode = KEY_ALT
	InputMap.action_add_event("editor_alt", event)

	if not InputMap.has_action("editor_s"):
		InputMap.add_action("editor_s")
	event = InputEventKey.new()
	event.physical_scancode = KEY_S
	InputMap.action_add_event("editor_s", event)


export var target_rotation = 0
export var target_scale := Vector2(1, 80)


func _process(delta):
	if !Engine.editor_hint:
		editingActive = false

	if Engine.editor_hint:
		var build_target = get_node(target_path)
		$Tooltip/Label.text = ""

		blocks = $BuildingBlocks.get_children()
		for n in blocks:
			n.visible = false
			n.position = Vector2.ZERO
			n.get_node("CollisionShape2D").disabled = true
		if Input.is_action_just_pressed("editor_switch"):
			editingActive = !editingActive
		if not editingActive:
			return

		selected_num = wrapi(selected_num, 0, blocks.size())

		selected_node = blocks[selected_num]
		selected_node.visible = true
		var _pos = get_global_mouse_position()
		$Tooltip.global_position = _pos
		_pos.x = int(_pos.x) - int(_pos.x) % grid_size
		_pos.y = int(_pos.y) - int(_pos.y) % grid_size
		selected_node.global_position = _pos

		var shift = Input.is_action_pressed("editor_shift")
		if Input.is_action_just_pressed("editor_cycle"):
			selected_num += 1

		#edit currently selected node
		if Input.is_action_just_pressed("editor_rotate"):
			var val = 45
			if Input.is_action_pressed("editor_ctrl"):
				val = 90
			if Input.is_action_pressed("editor_alt"):
				val = 30
			target_rotation += val
			if target_rotation == 0:
				target_rotation = 360
			target_rotation = wrapi(target_rotation, 0, 360)
		if (
			Input.is_action_just_pressed("editor_scale_up")
			or (Input.is_action_pressed("editor_scale_up") and shift)
		):
			var val = grid_size / 2
			if Input.is_action_pressed("editor_ctrl"):
				val = 1
			target_scale.y += val
		if (
			Input.is_action_just_pressed("editor_scale_down")
			or (Input.is_action_pressed("editor_scale_down") and shift)
		):
			var val = grid_size / 2
			if Input.is_action_pressed("editor_ctrl"):
				val = 1
			target_scale.y -= val
		if (
			Input.is_action_just_pressed("editor_scale_left")
			or (Input.is_action_pressed("editor_scale_left") and shift)
		):
			var val = grid_size / 2
			if Input.is_action_pressed("editor_ctrl"):
				val = 1
			target_scale.x -= val
		if (
			Input.is_action_just_pressed("editor_scale_right")
			or (Input.is_action_pressed("editor_scale_right") and shift)
		):
			var val = grid_size / 2
			if Input.is_action_pressed("editor_ctrl"):
				val = 1
			target_scale.x += val

		target_scale.x = max(1, target_scale.x)
		target_scale.y = max(1, target_scale.y)

		selected_node.rotation_degrees = target_rotation
		selected_node.scale = target_scale
		$Tooltip/Label.text = selected_node.name + "\n" + str(target_rotation) + " deg"

		#place node
		if Input.is_action_just_pressed("ui_select"):
			var b = selected_node.duplicate()
			b.get_node("CollisionShape2D").disabled = false
			build_target.add_child(b)
			b.global_position = selected_node.global_position
			b.rotation = selected_node.rotation
			b.rotation_degrees = selected_node.rotation_degrees
			if target_rotation == 0:
				b.rotation_degrees = 360
			if b.rotation_degrees == -90:
				print("WE GOT A -90 SIR!")
			b.set_owner(get_tree().edited_scene_root)

		if Input.is_action_just_pressed("editor_s") and Input.is_action_pressed("editor_ctrl"):
			save_level()
		pass
		#selected_node = get_children()[0]


func save_level():
	var packedLevel = PackedScene.new()
	var _name = "Level" + level_name

	#disable colour shader
	#var c_shader: ColorRect = get_node("../Shaders/ColorRemap")
	#c_shader.visible = false
	editingActive = false

	get_parent().name = _name
	var result = packedLevel.pack(get_parent())
	#print(result)
	if result == OK:
		var path = LEVEL_PATH + level_name + ".tscn"
		var error = ResourceSaver.save(path, packedLevel)
		print(error)
		print("WIGGLE ENGINE: Level saved at " + path)
		#c_shader.visible = true
		editingActive = true
		get_parent().name = "LevelBuilder"
	else:
		print("WIGGLE ENGINE: Error occured saving the scene!")
	pass


func debugtxt():
	$Label.text += "SelNum: " + str(selected_num) + "\n"
	$Label.text += "Selected: " + selected_node.name + "\n"
