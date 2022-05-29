extends Node2D

var flashing = false
var t = 0
var flash_gate = 0.1
var flash_c = 0
var flash_c_gate = 14


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = "completed " + str(CAT.current_level) + "/" + str(CAT.levels.size() - 1)
	if flashing:
		t += delta
		if t > flash_gate:
			t = 0
			visible = !visible
			flash_c += 1
			if flash_c >= flash_c_gate:
				flashing = false
				visible = true


func flash_completed():
	flashing = true
	t = 0
	flash_c = 0
