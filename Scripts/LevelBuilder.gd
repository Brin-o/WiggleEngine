tool
extends Node2D


export var selected_num : int = 0
var blocks
var selected_node

export (NodePath) var target_path




func _enter_tree():
	var event
	# setup event keys here
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


var target_rotation = 0
var target_scale := Vector2(1, 100)

func _process(delta):
	if Engine.editor_hint:
		var build_target = get_node(target_path)


		blocks = $BuildingBlocks.get_children()
		for n in blocks:
			n.visible = false
			
		selected_num = wrapi(selected_num, 0, blocks.size())

		selected_node = blocks[selected_num]
		selected_node.visible = true
		selected_node.global_position = get_global_mouse_position()
		

		if Input.is_action_just_pressed("editor_cycle"): selected_num+=1

		#edit currently selected node
		if Input.is_action_just_pressed("editor_rotate"): target_rotation += 15
		if Input.is_action_just_pressed("editor_scale_up"): target_scale.y += 5
		if Input.is_action_just_pressed("editor_scale_down"): target_scale.y -= 5
		if Input.is_action_just_pressed("editor_scale_left"): target_scale.x -= 5
		if Input.is_action_just_pressed("editor_scale_right"): target_scale.x += 5


		selected_node.rotation_degrees = target_rotation
		selected_node.scale = target_scale

		#place node
		if Input.is_action_just_pressed("ui_select"):
			var b = selected_node.duplicate()
			build_target.add_child(b)
			b.set_owner(get_tree().edited_scene_root)
			b.global_position = selected_node.global_position
			b.global_rotation = selected_node.global_rotation

		#if Input.is_action_just_pressed("ui_down"): selected_num -= 1
		#debugtxt()
		pass
		#selected_node = get_children()[0]

func debugtxt():
	$Label.text += "SelNum: " + str(selected_num) + "\n"
	$Label.text += "Selected: " + selected_node.name + "\n"



func _input(event):
	if event is InputEventMouseButton:
		print(Input.is_action_just_pressed("ui_editor_next"))