extends Node2D

@onready var tilemap = $TileMap
signal anim_done()
var death = false
var game_started
var ufo_death_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Dialog.visible = false
	$You.pause = true
	$GameOver.get_node("Button").pressed.connect(set_level)
	$UFO.beam_player.connect(beam_collide)
	await anim_done
	$AnimationPlayer.play("camera_pans_right")
	await anim_done
	set_level()


func set_level() -> void:
	$PolishCowMusic.stop()
	$You.set_knight_mode(false)
	$You.use_excowlibur_dagger = false
	$Dialog.visible = true
	$UFO.set_sprite("baby")
	death = false
	$You.allow_attacking(false)
	$UFO.set_path_find(false)
	$Dialog.visible = false
	$You.pause = true
	$Deathscreen.visible = false
	$GameOver.visible = false
	$UFO.set_hp(100)
	$UFO.position = Vector2(405, -92)
	$UFO/UfoBeam.modulate = Color8(1,1,1,0)
	$You.visible = true
	game_started = true
	$You.position = Vector2(0,739)
	$AnimationPlayer.play("scene_1") #the burger king speaks to you
	await $Dialog.finished
	$AnimationPlayer.play("scene_2") #the camera zooms into UFO dramatically
	$Danger.play()
	await anim_done
	$UFO.show_beam()
	$You.pause = false
	$UFO.set_path_find(true)
	$You.allow_attacking(true)
	game_started = false
	
	await $UFO.at_10_hp
	$You.allow_attacking(false)
	$You.use_excowlibur_dagger = true
	
	$UFO.set_path_find(false) #UFO will pause as the following animations play
	$UFO.velocity = Vector2(0,0)
	
	$AnimationPlayer.play("scene_3")#burger king will say "FINISH HIM! YOU JUST NEED ONE FINAL SHOT!"
	await $Dialog.finished
	$UFO.set_sprite("headphones_baby")
	$AnimationPlayer.play("scene_4") #NOOO HEADPHONES BABY	
	await $Dialog.finished

	$PolishCowMusic.play() #the cow god descends
	$God_Descends.play() 
	$You.pause = true
	$CowGod.position.x = $You.position.x
	var godtween = create_tween()
	var target_pos = Vector2($You.position.x, $You.position.y - 300)
	godtween.tween_property($CowGod, "position", target_pos, 10)
	await godtween.finished
	
	$AnimationPlayer.play("scene_5") #cow god speaks
	await $Dialog.finished
	
	$You.set_knight_mode(true)
	
	var godtween2 = create_tween()
	target_pos = Vector2($CowGod.position.x, -991)
	godtween2.tween_property($CowGod, "position", target_pos, 10)
	
	$You.pause = false	
	$You.allow_attacking(true)
	$UFO.set_path_find(true)
	
	await $You.dagger_thrown #you may only throw ONE excowlibur
	$You.allow_attacking(false)
	
	await $UFO.died #YOU KILLED THE UFO
	$AnimationPlayer.play("scene_6")
	await $Dialog.finished
	$AnimationPlayer.play("fade_out")
	await anim_done
	get_tree().change_scene_to_file("credits.tscn")
	#once dead, the Burger king will thank you and the end credits will roll

func beam_collide():
	if !death and !$UFO.dead and !game_started:
		$minimap.visible = false
		$UFO.get_node("Whoosh").play()
		$You.allow_attacking(false)
		$UFO.path_finding = false
		$UFO.velocity = Vector2(0,0)
		death = true
		$You.pause = true
		var tween = create_tween()
		var target_pos = Vector2($UFO.position.x, $UFO.position.y + 50)
		tween.tween_property($You, "position", target_pos, 4)
		await tween.finished
		$You.velocity.x = 0
		$You.visible = false
		$Deathscreen.death()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tilemap == null:
		print("TileMap not found!")
		return
	$Deathscreen.position = Vector2($You.position.x - 510, $You.position.y - 770)
	if !game_started:
		$Dialog.position = Vector2($You.position.x - 510, $You.position.y - 770)

func animation_over():
	emit_signal("anim_done")
