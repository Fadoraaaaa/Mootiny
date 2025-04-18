extends Node2D

@onready var tilemap = $TileMap
signal anim_done()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await anim_done
	$You.pause = true
	$AnimationPlayer.play("camera_pans_right")
	await anim_done
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tilemap == null:
		print("TileMap not found!")
		return

func animation_over():
	emit_signal("anim_done")
