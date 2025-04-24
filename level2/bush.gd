extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(body: CharacterBody2D) -> void:
	print("area entered has been called")
	pass

func _on_area_2d_area_exited(body: CharacterBody2D) -> void:
	pass
