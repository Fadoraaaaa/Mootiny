extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func change_to_menu():
	get_tree().change_scene_to_file("res://menu stuff/menu scenes/Menu.tscn")
