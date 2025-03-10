extends Node2D

@onready var anim = $AnimationPlayer as AnimationPlayer
var screen_size : Vector2i
signal anim_done()
signal hiding()
var direction = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	$You.pause = true
	$Ground.position = Vector2i(-320, 220)
	$Bush1.get_node("Area2D").body_entered.connect(bush_hiding)
	$Bush1.get_node("Area2D").body_exited.connect(bush_left)
	$Bush2.get_node("Area2D").body_entered.connect(bush_hiding)
	$Bush2.get_node("Area2D").body_exited.connect(bush_left)
	$Bush3.get_node("Area2D").body_entered.connect(bush_hiding)
	$Bush3.get_node("Area2D").body_exited.connect(bush_left)
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
	$UFO.set_path_find(true)
	
	
	pass # Replace with function body.

func beam_collide(body):
	if body.name == "You" and $UFO.visible and !$UFO.hiding:
		$UFO.set_path_find(false)
		$UFO.set_velocity(Vector2(0,0))
		direction = 0
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
	if direction < 0:
		$UFO.velocity.x = direction * $UFO.get_speed()
	if direction > 0:
		$UFO.velocity.x = direction * $UFO.get_speed()
	pass
	
func bush_hiding(body: CharacterBody2D):
	$Bush2.get_node("Rustle").play()
	$UFO.set_hiding(true)
	$UFO.set_path_find(false)

func bush_left(body: CharacterBody2D):
	$UFO.set_hiding(false)
	$UFO.set_path_find(true)
	print("YOU HAVE LEFT AND PATH FIND IS TRUE")

func animation_over():
	emit_signal("anim_done")


func _on_timer_timeout() -> void:
	if !$UFO.path_finding:
		if $UFO.position.x >= 1207:
			direction = -1
		if $UFO.position.x <= -200:
			direction = 1
		if $UFO.position.y < 376:
			$UFO.velocity.y = 300
		else:
			$UFO.velocity.y = 0
	
	pass # Replace with function body.


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if !$Timer.is_stopped(): #UFO is NOT dead yet
		if $UFO.hiding:
			$UFO.set_path_find(false)	
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
