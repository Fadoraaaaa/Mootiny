extends Node2D

@export var scene_path : String

signal mouse_has_entered
signal mouse_has_exited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	emit_signal("mouse_has_entered")
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	emit_signal("mouse_has_exited")
	pass # Replace with function body.


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		print("connecting map to scene: " + scene_path)
		get_tree().change_scene_to_file(scene_path)
	pass # Replace with function body.
