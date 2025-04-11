extends Node2D

@export var scene_path : String

signal mouse_has_entered
signal mouse_has_exited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_2d_mouse_entered() -> void:
	emit_signal("mouse_has_entered")
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	emit_signal("mouse_has_exited")
	pass # Replace with function body.


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		$Chime2.play()
		$Polygon2D.modulate = Color8(95, 255, 90, 45)
		var tree = get_tree()
		await tree.create_timer(2).timeout
		print("connecting map to scene: " + scene_path)
		tree.change_scene_to_file(scene_path)
	pass # Replace with function body.
