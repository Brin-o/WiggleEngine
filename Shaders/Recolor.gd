tool
extends ColorRect
class_name ColorManager
onready var tween = $Tween
export var starting_color: String = "grays"
export var apply_color: bool

export var palettes: Dictionary = {
	grays = [
		Color(0.95, 0.95, 0.95),
		Color(0.75, 0.75, 0.75),
		Color(0.62, 0.62, 0.62),
		Color(0.51, 0.51, 0.51),
		Color(0.38, 0.38, 0.38),
		Color(0.25, 0.25, 0.25),
		Color(0.13, 0.13, 0.13),
		Color(0.01, 0.01, 0.01)
	],
	nyx = [
		Color("#FCD5B9"),
		Color("#C9A186"),
		Color("#A07376"),
		Color("#865F72"),
		Color("#4F4961"),
		Color("#173A51"),
		Color("#022B41"),
		Color("#05141F")
	],
	ayy8 = [
		Color("#F1F2D7"),
		Color("#FFCC8D"),
		Color("#FF6C72"),
		Color("#9574E7"),
		Color("#046E73"),
		Color("#044148"),
		Color("#00313C"),
		Color("#00232A")
	],
	destatur = [
		Color("#f0f0eb"),
		Color("#ffff8f"),
		Color("#7be098"),
		Color("#849ad8"),
		Color("#e8b382"),
		Color("#d8828e"),
		Color("#605164"),
		Color("#545155"),
	]
}


func _ready():
	set_current_palette(palettes[starting_color])
	pass


# change to given palette (8 color array, found in Wiggle.recolor.palette)
func set_current_palette(palette: Array, transition_t: float = 0):
	if tween.is_active():
		tween.remove_all()
	var i = 0
	for c in palette:
		var param_path = "shader_param/c" + String(i + 1)
		if transition_t == 0:
			self.material.set(param_path, palette[i])
		else:
			tween.interpolate_property(get_material(), param_path, null, palette[i], transition_t)
			tween.start()
		i += 1


func _process(delta):
	if Engine.editor_hint:
		if apply_color:
			print("Applying color: ", starting_color)
			set_current_palette(palettes[starting_color], 0)
			apply_color = false

	# if Input.is_action_just_pressed("ui_accept"):
	# 	var p = palettes[palettes.keys()[randi() % palettes.size()]]
	# 	set_current_palette(p, 0.7)
