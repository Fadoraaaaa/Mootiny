extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 300

@onready var footsteps_sound = $FootstepsSound as AudioStreamPlayer2D
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

var pause = false
var attack = false

func _ready():
	$Exclamation.visible = false
	$Questionmark.visible = false

func done_attacking():
	attack = false
	print("done attacking")

func _physics_process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		print("quitting")
	
	if Input.is_action_just_pressed("kick"):
		print("kicking")
		ap.play("kick")
		attack = true
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 200:
			velocity.y = 200
	
	if Input.is_action_just_pressed("menu"):
			print("menu button pressed")
			get_tree().change_scene_to_file("res://menu stuff/menu scenes/Menu.tscn")
			
	if !pause && !attack:
		if Input.is_action_just_pressed("jump"): # && is_on_floor():
			velocity.y = -jump_force 

	var horizontal_direction = Input.get_axis("move_left","move_right")
	if !pause && !attack: 
		velocity.x = speed * horizontal_direction	

	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
	move_and_slide()
	update_animation(horizontal_direction)
	
func update_animation(horizontal_direction):
	if (!attack):
		if is_on_floor():
			if horizontal_direction == 0:
				ap.play("idle")
				if footsteps_sound.playing:
					footsteps_sound.stop()
			else:
				ap.play("run")
				if !footsteps_sound.playing:
					footsteps_sound.play()
		else:
			ap.play("jump")
			if footsteps_sound.playing:
				footsteps_sound.stop()
	
func play_animation(animation_name):
	ap.play(animation_name)
	
func stop_animation():
	ap.stop()

func show_emote(emotion):
	if emotion == "curious":
		$Questionmark.visible = true
		await get_tree().create_timer(2).timeout
		$Questionmark.visible = false
	if emotion == "surprise":
		$Exclamation.visible = true
		if db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("JENNA MODE"))) < 0.0002:
			$EmotionIndicator.play()
		else:
			$JENNAEmotionIndicator.play()
		await get_tree().create_timer(2).timeout
		$Exclamation.visible = false
	else:
		pass
		
func is_speaking(direction, emotion):
	if emotion != "":
		show_emote(emotion)
	velocity.y = -200
	if direction == "right":
		var horizontal_direction = 1
		sprite.flip_h = (horizontal_direction == -1)
	if direction == "left":
		var horizontal_direction = -1
		sprite.flip_h = (horizontal_direction == -1)
	
