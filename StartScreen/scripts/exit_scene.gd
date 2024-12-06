extends Area2D

@export var whereto = "insert destination"

signal exiting_level()

var entered = false

func _on_body_entered(body: CharacterBody2D) -> void:
	entered = true

func _on_body_exited(body: CharacterBody2D) -> void:
	entered = false

func _process(delta):
	if entered == true:
		#get_tree().change_scene_to_file(whereto)
		emit_signal("exiting_level")
