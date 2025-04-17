extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().on_exit_pressed()
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("AnimationPlayer").play("Fade out")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://credits.tscn")
