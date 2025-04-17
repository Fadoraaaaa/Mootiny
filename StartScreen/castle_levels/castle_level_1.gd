extends Node2D

signal anim_done()
var death = false
var hiding = false
var hidden_first_time = false
var is_character_saved = false
var tween3

signal player_hidden_first_time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.current_location = 5

	$GameOver.get_node("Button").pressed.connect(set_level)
	$UFO.get_node("UfoBeam/Area2D").body_entered.connect(beam_collide)
	$Dialog.visible = false
	
	$UFO.position = Vector2i(-371, 198)
	$You.position = Vector2i(300,700)
	$You.set_gravity(25)
	death =  false
	$GameOver.hide()
	$Deathscreen.hide()
	$TileMap.set_cell(2, Vector2i(52,-2), 0, Vector2i(2, 28), 0)
	$You.pause = true	
	$AnimationPlayer.play("fade_in")
	await anim_done
	$AnimationPlayer.play("scene_1") #You run in and ask WHATS THE BEEF
	await $Dialog.finished
	
	$AnimationPlayer.play("camera_pans_to_Mademooiselle")
	await anim_done
	
	#she explains
	$AnimationPlayer.play("scene_2")
	await $Dialog.finished
	
	$AnimationPlayer.play("camera_pans_to_Player")
	await anim_done
	
	#you ask where
	$AnimationPlayer.play("scene_3")
	await $Dialog.finished
	
	$AnimationPlayer.play("camera_pans_to_Mademooiselle")
	await anim_done
	set_level()


func set_level():
	$Instructions.visible = false
	$UFO.hide_beam()
	$minimap.visible = true
	$You.allow_attacking(false)
	$You.position = Vector2i(300,700)
	$You.visible = true
	$UFO.set_path_find(false)
	$UFO.set_hp(50)
	$UFO.visible = true
	$UFO.dead = false
	is_character_saved = false
	$UFO.position = Vector2i(-371, 198)
	death =  false
	$Mademooiselle.visible = true
	$Mademooiselle.position = Vector2i(4498, 733)
	$GameOver.hide()
	$You.set_gravity(25)
	$Deathscreen.hide()
	$TileMap.set_cell(2, Vector2i(52,-2), 0, Vector2i(2, 28), 0)
	$You.pause = true
	hidden_first_time = false

	$AnimationPlayer.play("scene_4") #she says BEHIND YOUUUUU
	await $Dialog.finished
	
	$AnimationPlayer.play("camera_pans_to_Player")
	await anim_done
	$Danger.play()
	
	#UFO dramatically rushes in and begins to pathfind towards the player
	$AnimationPlayer.play("scene_5")
	
	$You.pause = false
	$UFO.set_path_find(true)
	$UFO.get_node("Swirl").play()
	
	await player_hidden_first_time
	$UFO.set_path_find(false)
	$UFO.set_velocity(Vector2i(0,0))
	
	var tween2 = create_tween()
	var target_pos = Vector2($Mademooiselle.position.x + 50, 374)
	tween2.tween_property($UFO, "position", target_pos, 0.5)

	print("Traveled over to Mademooiselle location")
	
	$Dialog.position.x = $You.position.x - 300
	$Dialog.visible = true
	$AnimationPlayer.play("scene_6")
	$Instructions.visible = true
	await $Dialog.finished
	$Instructions.visible = false
	$You.allow_attacking(true)
	
	tween3 = create_tween()
	target_pos = Vector2($UFO.position.x - 50, $UFO.position.y + 50)
	tween3.tween_property($Mademooiselle, "position", target_pos, 7)
	tween3.finished.connect(on_tween_finished)
	$Timer.start()
	$UFO.died.connect(_on_ufo_hp_zero)

func on_tween_finished():
	if not is_character_saved:
		$Mademooiselle.visible = false
		print("Character abducted!")
		#triggers failure condition
		$GameOver.show()

func _on_ufo_hp_zero():
	if $Timer.time_left > 0: #Character was saved in time
		if is_character_saved:
			return #already handled
		is_character_saved = true
		if tween3.is_running():
			tween3.kill()
			print("TWEEN KILLED")
		print("Character saved!")
		$AnimationPlayer.play("scene_7")
		await $Dialog.finished
		$TileMap.set_cell(2, Vector2i(52,-2), 0, Vector2i(8, 32), 0) #opening up door
		$AnimationPlayer.play("fade_out")
		$minimap.visible = false
		await anim_done
		get_tree().change_scene_to_file("res://castle_levels/castle_level_2.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if !death:
		$Camera2D.position = Vector2($You.position.x, $You.position.y + 30)
	$Deathscreen.position = Vector2($Camera2D.position.x -520, $Camera2D.position.y - 770)
	if hidden_first_time:
		$Dialog.position.x = $You.position.x - 500
	$minimap.position = Vector2($You.position.x - 516, $You.position.y - 740)

func animation_over():
	emit_signal("anim_done")

func _on_void_of_death_body_entered(body: CharacterBody2D) -> void:
	if body.name == "You":
		death = true
		$Deathscreen.death()
		$You.set_gravity(0)
		$You.velocity.y = 0
		$You.pause = true

func beam_collide(body):
	if body.name == "You" and !death and !$UFO.dead:
		$minimap.visible = false
		$UFO.get_node("Whoosh").play()
		$You.allow_attacking(false)
		death = true
		$UFO.set_path_find(false)
		$UFO.set_velocity(Vector2(0,0))
		print("trying to tween")
		$You.pause = true
		var tween = create_tween()
		var target_pos = Vector2($UFO.position.x, $UFO.position.y + 50)
		tween.tween_property($You, "position", target_pos, 4)
		await tween.finished
		$You.velocity.x = 0
		$You.visible = false
		print("attempting to restart")
		$Deathscreen.death()

func _on_safe_area_body_entered(body: Node2D) -> void:
	if body.name == "You":
		$You.set_hiding(true)
		print("HIDING")
		if !hidden_first_time:
			emit_signal("player_hidden_first_time")
			hidden_first_time = true

func _on_safe_area_body_exited(body: Node2D) -> void:
	$You.set_hiding(false)
	print("NOT HIDING")
