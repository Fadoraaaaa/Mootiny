extends Node2D

@onready var anim = $AnimationPlayer as AnimationPlayer
var screen_size : Vector2i
signal anim_done()
signal hiding()
var direction = -1
var beginning_of_level = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	$Bush1.get_node("Area2D").body_entered.connect(bush_hiding)
	$Bush1.get_node("Area2D").body_exited.connect(bush_left)
	$Bush2.get_node("Area2D").body_entered.connect(bush_hiding)
	$Bush2.get_node("Area2D").body_exited.connect(bush_left)
	$Bush3.get_node("Area2D").body_entered.connect(bush_hiding)
	$Bush3.get_node("Area2D").body_exited.connect(bush_left)
	$UFO.get_node("UfoBeam/Area2D").body_entered.connect(beam_collide)
	$GameOver.get_node("Button").pressed.connect(set_level)
	set_level()
	pass # Replace with function body.
	
func set_level():
	$GameOver.hide()
	$Dialog.visible = true
	$You.pause = true
	$You.visible = true
	$Deathscreen.hide()
	$UFO.set_path_find(false)
	$ColorRect.hide()
	#$You.allow_attacking(false)
	$Moogician.position = Vector2i(2000, 768)
	$Ground.position = Vector2i(-320, 220)
	$UFO.position = Vector2i(1207, 381)
	$You.position = Vector2i(192,768)
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

func beam_collide(body):
	if body.name == "You" and $UFO.visible and !$UFO.hiding:
		$UFO.set_path_find(false)
		$UFO.set_velocity(Vector2(0,0))
		direction = 0
		print("trying to tween")
		$Timer.stop()
		var tween = create_tween()
		var target_pos = Vector2($UFO.position.x, $UFO.position.y + 50)
		tween.tween_property($You, "position", target_pos, 4)
		await tween.finished
		$You.visible = false
		$You.pause = true
		print("attempting to restart")
		$Deathscreen.death()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $You.position.x < 3460:
		$Camera2D.position.x = $You.position.x
	$Deathscreen.position = Vector2($Camera2D.position.x - 510, $Deathscreen.position.y)
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
	print(str($You.position.x))
	pass
	
func bush_hiding(body: CharacterBody2D):
	$You.set_hiding(true)
	$Bush2.get_node("Rustle").play()
	$UFO.set_hiding(true)
	$UFO.set_path_find(false)

func bush_left(body: CharacterBody2D):
	$UFO.set_hiding(false)
	$UFO.set_path_find(true)
	$You.set_hiding(false)

func animation_over():
	emit_signal("anim_done")


func _on_timer_timeout() -> void:
	if !$UFO.path_finding:
		if $UFO.position.x >= 1940:
			direction = -1
		if $UFO.position.x <= -200:
			direction = 1
		if $UFO.position.y < 376:
			$UFO.velocity.y = 300
		else:
			$UFO.velocity.y = 0
	
	pass # Replace with function body.


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.name == "You":
		if $UFO.get_dead(): #UFO IS DEAD
			print("UFO is NOT alive")
		else: #UFO IS ALIVE
			if !$You.get_attack(): #CANNOT ATTACK
				print("UFO is STILL alive, and you CANNOT attack")
				if $UFO.hiding or beginning_of_level:
					$UFO.set_path_find(false)	
				$You.pause = true
				$You.velocity.x = 0
				$Dialog.position.x = $You.position.x - 540
				$Dialog.visible = true
				anim.play("scene_5")
				await $Dialog.finished
				anim.play("swirly_magic")
				await anim_done
				$You.pause = false
				$You.allow_attacking(true)
				$ColorRect.position.x = $You.position.x - 300
				$ColorRect.show()
				await get_tree().create_timer(2).timeout
				$ColorRect.hide()
			if $You.get_attack(): #CAN ATTACK
				print("UFO is STILL alive, and you CAN attack")	
				$ColorRect.show()
				await get_tree().create_timer(2).timeout
				$ColorRect.hide()	
	pass # Replace with function body.


func _on_ufo_died() -> void:
	$Timer.stop()
	print("UFO HAS DIEEDDDDDDD IN THE LEVEL 2 CODE")

func play_magic_sound():
	$Magic.play()
