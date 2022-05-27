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
# =====================


func change_scene(new_scene: PackedScene):
	if viewport.get_child_count() > 1:
		return printerr("WIGGLE ENGINE: There is more than 1 scene in the viewport!")
	elif viewport.get_child_count() > 0:
		if logging:
			print("WIGGLE ENGINE: Deleting scene ", viewport.get_child(0).name)
		viewport.get_child(0).call_deferred("queue_free")
	viewport.add_child(new_scene.instance())
	var scene = viewport.get_child(0)
	if logging:
		print("WIGGLE ENGINE: Loaded scene ", scene.name)
	return scene
