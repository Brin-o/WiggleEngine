tool

extends Node2D

export var generate: bool = false
export(PackedScene) var tile
export var size_x = 240
export var size_y = 240
var tile_size = 16

var per_many_beats = 4

var all_tiles: Array
var frame_lenght

onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.editor_hint:
		CAT.background = self
		all_tiles = $Tiles.get_children()
		frame_lenght = all_tiles[0].frames.get_frame_count("default")
		set_random_frame_on_tiles()


var beat_t = 0
var beat_gate = 0.4


func _process(delta):
	if Engine.editor_hint:
		if generate:
			generate = false
			generate_self()


func set_random_frame_on_tiles():
	for f in all_tiles:
		f.frame = round(rand_range(0, frame_lenght))


func _on_Timer_timeout():
	set_random_frame_on_tiles()


func setup_timer(_bpm, _per):
	var beat_t = 60.0 / _bpm
	print("beat t: ", beat_t, " - - ", _per)
	var b = beat_t * _per
	timer.wait_time = b
	print("setting timer time to be: ", b)
	timer.start()


func generate_self():
	randomize()
	for _x in range(0, size_x, tile_size):
		for _y in range(0, size_x, tile_size):
			var r = rand_range(0, 1)
			if r >= 0.5:
				var t = tile.instance()
				t.position.x = _x
				t.position.y = _y
				t.frame = round(rand_range(0, frame_lenght))
				add_child(t)
				t.set_owner(get_tree().edited_scene_root)
