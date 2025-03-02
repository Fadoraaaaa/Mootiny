extends Node2D

@onready var anim = $AnimationPlayer as AnimationPlayer
var screen_size : Vector2i
signal anim_done()
signal hiding()
var direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	$You.pause = true
	$Ground.position = Vector2i(-320, 220)
	$Bush1.get_node("Area2D").body_entered.connect(bush_hiding)
	$Bush1.get_node("Area2D").body_exited.connect(bush_left)
	$Bush2.get_node("Area2D").body_entered.connect(bush_hiding)
	$Bush2.get_node("Area2D").body_exited.connect(bush_left)
	$UFO.get_node("UfoBeam/Area2D").body_entered.connect(beam_collide)
	$UFO.position = Vector2i(1207, 381)
	$UFO.show_beam()
	anim.play("scene_1")
	await $Dialog.finished
	anim.play("scene_2")
	await anim_done
	$Timer.start()
	$Dialog.visible = true
	anim.play("scene_3")
	await $Dialog.finished
	anim.play("scene_4")
	$You.pause = false
	
	
	pass # Replace with function body.

func beam_collide(body):
	if body.name == "You" and $UFO.visible and !$UFO.hiding:
		print("trying to tween")
		$Timer.stop()
		var tween = create_tween()
		var target_pos = $UFO.position
		tween.tween_property($You, "position", target_pos, 4)
		await tween.finished
		$You.visible = false
	pass


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
	$Bush2.get_node("Rustle").play()
	$UFO.set_hiding(true)

func bush_left(body: CharacterBody2D):
	$UFO.set_hiding(false)

func animation_over():
	emit_signal("anim_done")


func _on_timer_timeout() -> void:
	if $UFO.position.x >= 1207:
		direction = -1
	if $UFO.position.x <= -200:
		direction = 1
	if direction < 0:
		$UFO.position.x -= 4
	if direction > 0:
		$UFO.position.x += 4
	
	pass # Replace with function body.


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if !$Timer.is_stopped():
		$You.pause = true
		$You.velocity.x = 0
		$Dialog.position.x = $You.position.x - 540
		$Dialog.visible = true
		anim.play("scene_5")
		await $Dialog.finished
		$You.pause = false
	else:
		print("you already killed the UFO")
	
	pass # Replace with function body.
