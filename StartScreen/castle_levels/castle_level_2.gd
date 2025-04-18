extends Node2D

var beams_out
var death = false
var game_started
signal anim_done()
var animation_playing = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beams_out = 1
	Global.current_location = 5
	$GameOver.get_node("Button").pressed.connect(set_level)
	$UFO1.beam_player.connect(beam_collide.bind(1))
	$UFO2.beam_player.connect(beam_collide.bind(2))
	$Dialog.visible = false
	$You/Camera2D.position = Vector2($You/Camera2D.position.x + 100, $You/Camera2D.position.y + 200)
	$UFO1.hide_beam()
	$UFO2.show_beam()
	$Dialog.visible = false
	$minimap.visible = false
	$You.pause = true
	game_started = true
	$ColorRect2.visible = false
	$Timer.start()
	
	animation_playing = true
	await anim_done
	$AnimationPlayer.play("camera_pans_up")
	await anim_done
	$AnimationPlayer.play("scene_1")
	await $Dialog.finished
	$AnimationPlayer.play("scene_2")
	await anim_done
	$AnimationPlayer.play("scene_3")
	await $Dialog.finished
	$AnimationPlayer.play("camera_pans_up")
	await anim_done
	$AnimationPlayer.play("scene_4")
	await $Dialog.finished
	$AnimationPlayer.play("camera_pans_down")
	await anim_done
	$AnimationPlayer.play("scene_5")
	await $Dialog.finished
	set_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$minimap.position = Vector2($You.position.x- 420, $You.position.y - 550)
	if !animation_playing:
		$Dialog.position = Vector2($You.position.x-500, $You.position.y - 633)
	$Deathscreen.position = Vector2($You.position.x- 420, $You.position.y - 570)

func set_level():
	animation_playing = true
	$Dialog.visible = false
	$You.allow_attacking(false)
	death = false
	$Deathscreen.hide()
	$GameOver.hide()
	$You.position = Vector2(18,733)
	$You.visible = true
	$You.pause = true
	$Timer.start()
	$You.velocity = Vector2(2,2)
	
	#Game just began--prevent the random flying bug:
	game_started = true

	$AnimationPlayer.play("camera_pans_up")
	await anim_done
	$AnimationPlayer.play("scene_6")
	await $Dialog.finished
	$AnimationPlayer.play("camera_pans_down")
	await anim_done
	$You.pause = false
	$minimap.visible = true
	animation_playing = false
	
	game_started = false
	

func beam_collide(num):
	var ufo = get_node("UFO" + str(num))
	if !death and !ufo.dead and !game_started:
		$minimap.visible = false
		ufo.get_node("Whoosh").play()
		$You.allow_attacking(false)
		death = true
		$You.pause = true
		var tween = create_tween()
		var target_pos = Vector2(ufo.position.x, ufo.position.y + 50)
		tween.tween_property($You, "position", target_pos, 4)
		await tween.finished
		$You.velocity.x = 0
		$You.visible = false
		$Deathscreen.death()

func _on_timer_timeout() -> void:
	if beams_out == 1:
		$UFO1.show_beam()
		$UFO2.hide_beam()
	if beams_out == -1:
		$UFO1.hide_beam()
		$UFO2.show_beam()
	beams_out *= -1

func animation_over():
	emit_signal("anim_done")

func _on_acoustics_area_body_entered(body: Node2D) -> void:
	$You.allow_attacking(true)

func _on_acoustics_area_body_exited(body: Node2D) -> void:
	$You.allow_attacking(false)

func _on_dairy_queen_talking_area_body_entered(body: Node2D) -> void:
	if !game_started:
		$ColorRect2.visible = true
		await get_tree().create_timer(2).timeout
		$ColorRect2.visible = false
