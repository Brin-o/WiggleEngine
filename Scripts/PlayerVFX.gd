extends Node

onready var player: Ship = $".."
export(PackedScene) var crashParticleStars
export(PackedScene) var crashParticleDust


func _on_Player_crashed():
	var d = crashParticleDust.instance()
	d.self_modulate = player.modulate
	d.global_position = player.global_position
	d.emitting = true
	add_child(d)
	var s = crashParticleStars.instance()
	s.self_modulate = player.modulate
	s.global_position = player.global_position
	s.emitting = true

	add_child(s)
