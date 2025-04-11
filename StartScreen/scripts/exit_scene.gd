extends Area2D

signal exiting_level()

var entered = false

func _on_body_entered(_body: CharacterBody2D) -> void:
	entered = true

func _on_body_exited(_body: CharacterBody2D) -> void:
	entered = false

func _process(_delta):
	if entered == true:
		emit_signal("exiting_level")
