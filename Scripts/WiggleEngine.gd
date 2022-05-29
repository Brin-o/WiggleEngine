extends Node2D

var logging := true

# === ENGINE VARS ====
# assigned by the engine
# on bootup, dont touch
var viewport
var interface
var effects
var shaders
var recolor: ColorManager

var screenshotting: bool = false
var screenshotting_t: float = 0
var screenshotting_gate: float = 1.5
# =====================


func _process(delta):
	screenshotting_t += delta
	if screenshotting_t >= screenshotting_gate:
		take_screenshot()
		screenshotting_t = 0


func change_scene(new_scene: PackedScene):
	if viewport.get_child_count() > 1:
		return printerr("WIGGLE ENGINE: There is more than 1 scene in the viewport!")
	elif viewport.get_child_count() > 0:
		if logging:
			print("WIGGLE ENGINE: Deleting scene ", viewport.get_child(0).name)
		viewport.get_child(0).call_deferred("queue_free")
	viewport.call_deferred("add_child", new_scene.instance())
	var scene = viewport.get_child(0)
	if logging:
		print("WIGGLE ENGINE: Loaded scene ", scene.name)
	return scene


func get_current_scene_node() -> Node:
	return viewport.get_child(0)


func change_scene_to_level(num: int):
	var path = "res://Levels/Level" + str(num) + ".tscn"
	var level = load(path)
	change_scene(level)


func change_scene_to_named_level(_name):
	var path = "res://Levels/" + _name + ".tscn"
	var level = load(path)
	change_scene(level)


func take_screenshot():
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	var date = (
		str(OS.get_date().year)
		+ "_"
		+ str(OS.get_date().month)
		+ "_"
		+ str(OS.get_date().day)
		+ "_"
		+ str(OS.get_time().hour)
		+ "_"
		+ str(OS.get_time().minute)
		+ "_"
		+ str(OS.get_time().second)
	)
	print(date)
	var name = "screenshot_" + ProjectSettings.get("application/config/name") + "_" + date
	image.save_png("res://Screenshots/" + name + ".jpg")
