extends Node2D

@onready var anim = $AnimationPlayer as AnimationPlayer
var screen_size : Vector2i
signal anim_done()
signal hiding()
var direction = -1
var beginning_of_level = true
var death = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.current_location = 3
	screen_size = get_window().size
	for i in range(1, 3+1):
		get_node("Bush" + str(i) + "/Area2D").body_entered.connect(bush_hiding)
		get_node("Bush" + str(i) + "/Area2D").body_exited.connect(bush_left)
	$UFO.get_node("UfoBeam/Area2D").body_entered.connect(beam_collide)
	$GameOver.get_node("Button").pressed.connect(set_level)
	set_level()
	
func set_level():
	get_node("Camera2D/AudioStreamPlayer2D").play()
	death = false
	$GameOver.hide()
	$Dialog.visible = true
	$UFO.set_hp(100)
	$You.pause = true
	$You.visible = true
	$Deathscreen.hide()
	$UFO.set_path_find(false)
	$ColorRect.hide()
	$You.position = Vector2i(192,768)
	$Moogician.position = Vector2i(2000, 768)
	$Ground.position = Vector2i(-370, 220)
	$UFO.position = Vector2i(1207, 381)
	
	$UFO.show_beam()
	
	direction = 0
	$Timer.stop()
	
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
	if body.name == "You" and $UFO.visible and !$UFO.hiding and !death:
		death = true
		$UFO.set_path_find(false)
		$You.allow_attacking(false)
		$UFO.set_velocity(Vector2(0,0))
		direction = 0
		print("trying to tween")
		$Timer.stop()	
		$You.pause = true
		var tween = create_tween()
		var target_pos = Vector2($UFO.position.x, $UFO.position.y + 50)
		tween.tween_property($You, "position", target_pos, 4)
		await tween.finished
		$UFO.velocity = Vector2(0,0)
		$You.velocity.x = 0
		$Camera2D/AudioStreamPlayer2D.stop()
		$You.visible = false
		print("attempting to restart")
		$Deathscreen.death()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $You.position.x < 3460: #make it so that you can't look past castle entrance
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
	if !$Camera2D/AudioStreamPlayer2D.playing and !death:
		$Camera2D/AudioStreamPlayer2D.play()
	
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
		if $UFO.position.x <= -250:
			direction = 1
		if $UFO.position.y < 376:
			$UFO.velocity.y = 300
		else:
			$UFO.velocity.y = 0


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.name == "You":
		if $UFO.get_dead(): #UFO IS DEAD
			print("UFO is NOT alive")
			$You.pause = true
			$Dialog.visible = true
			anim.play("scene_6")
			await $Dialog.finished
			$You.pause = false
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

func play_magic_sound():
	$Magic.play()


func _on_castle_entrance_area_entered(area: Area2D) -> void:
	if $UFO.get_dead():
		print("ENTRANCE ENTERED")
		$CastleForeboding.play()
		$AnimationPlayer.play("exiting")
		await anim_done
		get_tree().change_scene_to_file("res://castle_levels/castle_level_1.tscn")
	
	else:
		print("UFO IS NOT DEAD YET")
