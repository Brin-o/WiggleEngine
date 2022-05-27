#  ____    _____   _____   _____   ___   _   _    ____   ____
# / ___|  | ____| |_   _| |_   _| |_ _| | \ | |  / ___| / ___|
# \___ \  |  _|     | |     | |    | |  |  \| | | |  _  \___ \
#  ___) | | |___    | |     | |    | |  | |\  | | |_| |  ___) |
# |____/  |_____|   |_|     |_|   |___| |_| \_|  \____| |____/
#

tool
extends Node

class_name WiggleSettings

export var apply_on_click = false
export var width: int = 180
export var height: int = 180
export var zoom: int = 3
export var fps: int = 60
export var project_name: String = "WiggleProject"
export var include_date: bool = true
export var bg_color: Color = Color.black
export var UI_stretch_mode: bool = false

var fader


func _ready():
	if not Engine.editor_hint:
		Wiggle.viewport = $"../ViewportContainer/Viewport"
		Wiggle.interface = $"../Interface"
		Wiggle.shaders = $"../Shaders"
		queue_free()


func _process(_delta):
	if Engine.editor_hint:
		if apply_on_click:
			apply_on_click = false
			ProjectSettings.set("dynamic_fonts/use_oversampling", false)  # stop the errors!
			ProjectSettings.set("network/limits/debugger_stdout/max_errors_per_frame", 100)
			#		print("Set max errors per frame to 100")
			ProjectSettings.set("display/window/stretch/mode", "viewport")
			if UI_stretch_mode:
				ProjectSettings.set("display/window/stretch/mode", "disabled")
			#		print("Set stretch mode to 'viewport'")
			ProjectSettings.set("rendering/quality/2d/use_pixel_snap", true)
			#		print("Set 2d/pixel snap to true")
			ProjectSettings.set("display/window/size/width", width)
			ProjectSettings.set("display/window/size/height", height)
			ProjectSettings.set("display/window/size/test_width", width * zoom)
			ProjectSettings.set("display/window/size/test_height", height * zoom)
			#		print("Set width x height to ", width, " x ", height)
			ProjectSettings.set("debug/settings/fps/force_fps", fps)
			print("Set FPS to ", ProjectSettings.get("debug/settings/fps/force_fps"))
			var time = OS.get_datetime()
			var _name = project_name
			if include_date:
				_name = str(time["year"]) + "_" + str(time["month"]) + "_" + project_name
			print("Name will be ", _name)
			ProjectSettings.set("application/config/name", _name)

			ProjectSettings.set("application/run/main_scene", get_tree().edited_scene_root.filename)

			ProjectSettings.set("rendering/environment/default_clear_color", bg_color)

			var err = ProjectSettings.save()
			if err == OK:
				print(
					"Applied Brick 2d project settings for '",
					project_name,
					"' viewed @ ",
					width,
					"x",
					height
				)
			else:
				print("WiggleEngine failed to apply: ", err)
			print("Thank you Droqen!")
