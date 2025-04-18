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
	$Dialog.visible = true
	$You/Camera2D.position = Vector2($You/Camera2D.position.x + 100, $You/Camera2D.position.y + 200)
	$UFO1.hide_beam()
	$UFO2.show_beam()
	$Dialog.visible = false
	$You.pause = true
	game_started = true
	$ColorRect2.visible = false
	$Timer.start()
	$minimap.visible = true
	$minimap.position = Vector2(-430, 220)
	animation_playing = true
	await anim_done
	await play_sequence([
		["camera_pans_up", "anim"],
		["scene_1", "dialog"], #queen exclaims how they're in the walls
		["scene_2", "anim"],
		["scene_3", "dialog"], #you say you can easily defeat them
		["camera_pans_up", "anim"],
		["scene_4", "dialog"], #queen says that 
		["camera_pans_down", "anim"],
		["scene_5", "dialog"]
	])
	set_level()

func play_sequence(sequence: Array) -> void: #helps handle animations & dialog
	for step in sequence:
		$AnimationPlayer.play(step[0])
		if step[1] == "anim":
			await anim_done
		if step[1] == "dialog":
			await $Dialog.finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !animation_playing:
		$minimap.position = Vector2($You.position.x - 448, $You.position.y - 513)
		$Dialog.position = Vector2($You.position.x - 398, $You.position.y - 583)
	$Deathscreen.position = Vector2($You.position.x - 420, $You.position.y - 570)

func set_level():
	$Timer.start(0)
	animation_playing = true
	$Dialog.visible = false
	$You.allow_attacking(false)
	death = false
	$Deathscreen.hide()
	$GameOver.hide()
	$You.position = Vector2(18,733)
	$You.visible = true
	$You.pause = true
	$You.velocity = Vector2(2,2)
	$UFO1.set_hp(40)
	$UFO2.set_hp(40)	
	game_started = true #Game just began--prevent the random flying bug:
	await play_sequence([["camera_pans_up", "anim"], ["scene_6", "dialog"], ["camera_pans_down", "anim"]])
	$You.pause = false
	animation_playing = false	
	game_started = false

func beam_collide(num):
	var ufo = get_node("UFO" + str(num))
	if !death and !ufo.dead and !game_started:
		$minimap.visible = false
		ufo.get_node("Whoosh").play()
		$You.allow_attacking(false)
		$Timer.stop()
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
	var ufos = [$UFO1, $UFO2] #alternates beams
	ufos[(beams_out + 1) / 2].show_beam()
	ufos[(beams_out -1 ) / 2].hide_beam()
	beams_out *= -1

func animation_over():
	emit_signal("anim_done")

func _on_acoustics_area_body_entered(body: Node2D) -> void:
	$You.allow_attacking(true)
	if !game_started and (!$UFO1.get_dead() or !$UFO2.get_dead()): #at least one UFO is alive
		$ColorRect2.visible = true
		await get_tree().create_timer(2).timeout
		$ColorRect2.visible = false

func _on_acoustics_area_body_exited(body: Node2D) -> void:
	$You.allow_attacking(false)

func _on_dairy_queen_talking_area_body_entered(body: Node2D) -> void:
	if !game_started and $UFO1.get_dead() and $UFO2.get_dead(): #both UFO's are dead
		print("both UFOS are dead")
		$Dialog.visible = true
		await play_sequence([["scene_7", "dialog"], ["fade_out", "anim"]])
		get_tree().change_scene_to_file("res://castle_levels/castle_level_3.tscn")
