extends Node2D

@onready var anim = $AnimationPlayer as AnimationPlayer
var screen_size : Vector2i
signal anim_done()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("scene_1")
	await $Dialog.finished
	anim.play("scene_2")
	await anim_done
	$Dialog.visible = true
	anim.play("scene_3")
	await $Dialog.finished
	anim.play("scene_4")
	
	screen_size = get_window().size
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.position.x = $You.position.x + 324
	if abs($Camera2D.position.x - $Grass.position.x) > screen_size.x:
		if $You.horizontal_direction < 0:
			$Grass.position.x -= screen_size.x
		if $You.horizontal_direction > 0:
			$Grass.position.x += screen_size.x
	pass

func animation_over():
	emit_signal("anim_done")
