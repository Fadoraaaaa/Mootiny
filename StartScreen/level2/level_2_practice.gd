extends Node2D

@onready var anim = $AnimationPlayer as AnimationPlayer
var screen_size : Vector2i
signal anim_done()
signal hiding()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	$Ground.position = Vector2i(-320, 220)
	$Bush1.get_node("Area2D").body_entered.connect(bush_hiding)
	$Bush1.get_node("Area2D").body_exited.connect(bush_left)
	$Bush2.get_node("Area2D").body_entered.connect(bush_hiding)
	$Bush2.get_node("Area2D").body_exited.connect(bush_left)
	$UFO.show_beam()
	anim.play("scene_1")
	await $Dialog.finished
	anim.play("scene_2")
	await anim_done
	$Dialog.visible = true
	anim.play("scene_3")
	await $Dialog.finished
	anim.play("scene_4")
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.position.x = $You.position.x
	if abs($Camera2D.position.x - $Ground.position.x) > screen_size.x * 1.5:
		if $You.horizontal_direction > 0:
			$Ground.position.x += screen_size.x
	if ($You.horizontal_direction < 0):
		if abs($Camera2D.position.x - $Ground.position.x) < 500:
			$Ground.position.x -= screen_size.x
	pass
	
func bush_hiding(body: CharacterBody2D):
	print("bush has been entered - IN THE LEVEL")
	$Bush2.get_node("Rustle").play()
	$UFO.set_hiding(true)

func bush_left(body: CharacterBody2D):
	print("bush has been LEFT - IN THE LEVEL")
	$UFO.set_hiding(false)

func animation_over():
	emit_signal("anim_done")
