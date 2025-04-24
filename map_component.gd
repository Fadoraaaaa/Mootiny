extends Node2D

@export var scene_path : String
@export var options : Dictionary = {}
signal mouse_has_entered
signal mouse_has_exited
signal sublevels_requested(options: Dictionary)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_2d_mouse_entered() -> void:
	emit_signal("mouse_has_entered")


func _on_area_2d_mouse_exited() -> void:
	emit_signal("mouse_has_exited")


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		$Chime2.play()
		$Polygon2D.modulate = Color8(95, 255, 90, 45)
		
		if options.size() > 0:
			emit_signal("sublevels_requested", options)
		else:
			var tree = get_tree()
			await tree.create_timer(2).timeout
			print("connecting map to scene: " + scene_path)
			tree.change_scene_to_file(scene_path)
