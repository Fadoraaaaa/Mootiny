extends Node

#preload obstacles
var stump_scene = preload("res://level1/scenes/stump.tscn")
var rock_scene = preload("res://level1/scenes/rock.tscn")
var barrel_scene = preload("res://level1/scenes/barrel.tscn")
var obstacle_types := [stump_scene, rock_scene, barrel_scene]
var obstacles : Array

#game variables
const DINO_START_POS := Vector2i(450, 285)
const CAM_START_POS := Vector2i(576, 124)
var difficulty
const MAX_DIFFICULTY : int = 2
var score : int
const SCORE_MODIFIER : int = 10
var high_score : int
var speed : float
const START_SPEED : float = 6.0
const MAX_SPEED : int = 10
const SPEED_MODIFIER : int = 5000
var screen_size : Vector2i
var ground_height : int
var game_running : bool 
var last_obs
var hit_num = 0
var collided
var levelover

signal anim_done()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height() -20
	$GameOver.get_node("Button").pressed.connect(new_game)
	$Dino.get_node("AnimatedSprite2D/Red").visible = false
	new_game()
	$UFO.hide()
	$AnimationPlayer.play("intro")
	await anim_done
	$AnimationPlayer.play("introtext")
	await $Dialog.finished
	$AnimationPlayer.play("intro2")
	$UFO.show()
	$UFO.show_beam()
	$UFO.play_sound("buzz")
	$UFO.get_node("UfoBeam/Area2D").body_entered.connect(beam_collide)
	collided = false
	$JENNATenseMusic.play()
	$bush.get_node("Area2D").body_entered.connect(bush_hiding)
	$Deathscreen.get_node("AnimationPlayer").play("death")
	$Deathscreen.hide()
	$GameOver.hide()
	

func new_game():
	#reset variables
	score = 0
	show_score()
	game_running = false
	get_tree().paused = false
	difficulty = 0
	hit_num = 0
	print("starting new game")
	collided = false
	
	#delete all obstacles
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	#reset the nodes
	$UFO.position = Vector2i(143, -167)
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, -200)
	$ProgressBar.position.x = 107
	$CowFace.position.x = 107
	$MiniUFO.position.x = $ProgressBar.position.x
	$bush.position = Vector2i(30000, 305)
	
	
	#reset hud and game over screen
	$HUD.get_node("StartLabel").show()
	
	var action_events = InputMap.action_get_events("jump")
	var action_keycode = OS.get_keycode_string(action_events[0].physical_keycode)
	$HUD.get_node("StartLabel").text = "PRESS " + action_keycode + " TO JUMP"
	$GameOver.hide()
	$Deathscreen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		if !$JENNATenseMusic.playing:
			$JENNATenseMusic.play()
			
		#speed up and adjust difficulty
		speed = (START_SPEED + score / SPEED_MODIFIER) - hit_num
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		if speed <= 0 and ($Dino.position.x - $UFO.position.x) >= 700:
			speed = 0
			$UFO.position.x = $Dino.position.x - 650
		adjust_difficulty()
		
		#generate obstacles
		generate_obs()
		
		#move dino and camera
		$Dino.position.x += speed
		$JENNATenseMusic.position.x += speed
		$Camera2D.position.x = $Dino.position.x +126
		$UFO.position.x += 5
		
		$ProgressBar.value = score / SCORE_MODIFIER
		$ProgressBar.position.x += speed
		$CowFace.position.x = $ProgressBar.position.x + 907 * ($ProgressBar.value / 3000)
		$MiniUFO.position.x = $ProgressBar.position.x + 907 * ($UFO.position.x/30000)
		
		#update score
		score += speed
		show_score()
		
		if $Dino.position.x >= ($bush.position.x - 50):
			speed = 0
			game_running = false
		
		#update ground position
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
			
		if $Dino.is_on_floor():
			if db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("JENNA MODE"))) > 0.0002:
				if !$Dino.get_node("JENNAFootsteps").playing:
					$Dino.get_node("JENNAFootsteps").play()
			else:
				if !$Dino.get_node("Footsteps").playing:
					$Dino.get_node("Footsteps").play()
		else:
			$Dino.get_node("Footsteps").stop()
			$Dino.get_node("JENNAFootsteps").stop()
			
		#remove obstacles that have gone off screen
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		
		if Input.is_action_pressed("jump") and $UFO.visible and !$AnimationPlayer.is_playing() and !collided and !levelover:
			game_running = true
			$HUD.get_node("StartLabel").hide()

func generate_obs():
	#generate ground obstacles
	if ($Dino.position.x < 28000):
		if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
			var obs_type = obstacle_types[randi() % obstacle_types.size()]
			var obs
			var max_obs = difficulty + 1
			for i in range(randi() % max_obs + 1):
				obs = obs_type.instantiate()
				var obs_height = obs.get_node("Sprite2D").texture.get_height()
				var obs_scale = obs.get_node("Sprite2D").scale
				var obs_x : int = screen_size.x + score + 200 + (i * 100)
				var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) - 200
				last_obs = obs
				add_obs(obs, obs_x, obs_y-350)

func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obs.z_index =- 1
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func hit_obs(body):
	if body.name == "Dino":
		hit_num += 1
		if db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("JENNA MODE"))) > 0.0002:
			$Dino.get_node("JENNACollision").play()
		else: 
			$Dino.get_node("Collision").play()
		$Dino.get_node("AnimatedSprite2D/Red").visible = true
		var tween = create_tween()
		tween.tween_callback(
			func invisRed():
				$Dino.get_node("AnimatedSprite2D/Red").visible = false
		).set_delay(0.25)

func show_score():
	$HUD.get_node("ScoreLabel").text = "DISTANCE: " + str(score / SCORE_MODIFIER)

func check_high_score():
	if score > high_score:
		high_score = score
		$HUD.get_node("HighScoreLabel").text = "BEST: " + str(high_score / SCORE_MODIFIER)

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func game_over():
	check_high_score()
	get_tree().paused = true
	game_running = false
	$Deathscreen.position = Vector2($Camera2D.position.x - 510, $Deathscreen.position.y)
	$Deathscreen.show()
	$Deathscreen.add_to_death_count()
	$Deathscreen.get_node("Death_Sound").play()
	$GameOver.show()

func beam_collide(body):
	if body.name == "Dino":
		if game_running:
			game_running = false
			collided = true
			$UFO.get_node("Whoosh").play()
			$Dino.get_node("Footsteps").stop()
			var tween = create_tween()
			var target_pos = $UFO.position
			tween.tween_property($Dino, "position", target_pos, 4)
			await tween.finished
			game_over()
	
func animation_over():
	emit_signal("anim_done")
	
func bush_hiding(body: CharacterBody2D):
	#levelover = true
	for obs in obstacles:
		remove_obs(obs)
	$UFO.set_hiding(true)
	$UFO.position.x = $Dino.position.x - 2000
	var tween = get_tree().create_tween()
	var target_pos = Vector2($Dino.position.x + 2000, $UFO.position.y)
	tween.tween_property($UFO, "position", target_pos, 2)
	await tween.finished
	
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://level2/level_2_practice.tscn")
