extends Node2D


@onready var anim = $AnimationPlayer as AnimationPlayer
var screen_size : Vector2i
signal anim_done()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.current_location = 3
	screen_size = get_window().size
	set_level()
	pass # Replace with function body.
	
func set_level():
	get_node("Camera2D/AudioStreamPlayer2D").play()
	$You.pause = true
	$You.visible = true
	$You.position = Vector2i(192,768)
	$Ground.position = Vector2i(-370, 220)
	
	anim.play("scene_0")
	await anim_done
	get_tree().change_scene_to_file("res://level2/level_2_cutscene.tscn")

func animation_over():
	emit_signal("anim_done")
