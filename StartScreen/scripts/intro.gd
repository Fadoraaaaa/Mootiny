extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AnimationPlayer.play("Fade in")
	await get_tree().create_timer(3).timeout
	$AnimationPlayer.play("Fade out")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://menu stuff/menu scenes/Menu.tscn")
