extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://menu stuff/menu scenes/Menu.tscn")
	pass # Replace with function body.
