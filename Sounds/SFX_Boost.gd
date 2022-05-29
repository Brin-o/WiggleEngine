extends AudioStreamPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Boost_finished():
	call_deferred("queue_free")
