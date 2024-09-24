extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 300

@onready var footsteps_sound = $FootstepsSound as AudioStreamPlayer2D
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

var pause = false

func _ready():
	$Exclamation.visible = false
	$Questionmark.visible = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		print("quitting")
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 200:
			velocity.y = 200
	
	if Input.is_action_just_pressed("menu"):
			print("menu button pressed")
			get_tree().change_scene_to_file("res://menu stuff/menu scenes/Menu.tscn")
			
	if !pause:
		if Input.is_action_just_pressed("jump"): # && is_on_floor():
			velocity.y = -jump_force 

	var horizontal_direction = Input.get_axis("move_left","move_right")
	if !pause: 
		velocity.x = speed * horizontal_direction	

	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
	move_and_slide()
	update_animation(horizontal_direction)
	
func update_animation(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			ap.play("idle")
		else:
			ap.play("run")
			if !footsteps_sound.playing:
				footsteps_sound.play()
	else:
		ap. play("jump")
	
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
		await get_tree().create_timer(2).timeout
		$Exclamation.visible = false
	else:
		pass
		
func is_speaking(direction, emotion):
	if emotion != "":
		show_emote(emotion)
	velocity.y = -200
