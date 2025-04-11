extends Node2D

signal anim_done()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.current_location = 5
	set_level()
	pass # Replace with function body.

func set_level():
	$TileMap.set_cell(2, Vector2i(53,-2), 0, Vector2i(2, 28), 0)
	
	#setting tile to an OPEN staircase\
	$TileMap.set_cell(2, Vector2i(53,-2), 0, Vector2i(8, 32), 0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func animation_over():
	emit_signal("anim_done")
