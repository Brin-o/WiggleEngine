#					  _
#  \    /\    ___ __ _| |_
#   )  ( ')  / __/ _` | __/
#  (  /  )  | (_| (_| | |_
# 	\(__)|   \___\__,_|\__|
#
# == CONTROLLER OF ALL THINGS ==
# home to all game related functions
# that are relevant throught the whole game

extends Node

var save_dic: Dictionary
var save_path = "user://save.dat"


func save_data():
	var file = File.new()
	var err = file.open(save_path, File.WRITE)
	if err == OK:
		file.store_var(save_dic)
		file.close()
		print("WE_CAT: Dictonary saved!")


func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var err = file.open(save_path, File.READ)
		if err == OK:
			save_dic = file.get_var()
			file.close()
			print("WE_CAT: Dictonary loaded!")

# ====== ACTUAL GAME CODE ========
var ui
var msg
var player 
