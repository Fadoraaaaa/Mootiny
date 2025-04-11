extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("res://map_scene.tscn")
	pass # Replace with function body.
