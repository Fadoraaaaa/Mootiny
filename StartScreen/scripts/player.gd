extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 300

@onready var footsteps_sound = $FootstepsSound as AudioStreamPlayer2D
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
var horizontal_direction
var pause = false
var attack = false

#attack stuff
signal hp_max_changed(new_hp_max)
signal hp_changed(new_hp)
signal died

const INDICATOR_DAMAGE = preload("res://level2/DamageIndicator.tscn")


@export var hp_max: int = 100: set = set_hp_max
@export var hp: int = hp_max: get = get_hp, set = set_hp
@export var defense: int = 0

@export var receives_knockback: bool = true
@export var knockback_modifier: float = 0.1

@export var SPEED: int = 75
var vel: Vector2 = Vector2.ZERO

@export var EFFECT_HIT: PackedScene = null
@export var EFFECT_DIED: PackedScene = null

@onready var collShape = $CollisionShape2D
@onready var animPlayer = $AnimationPlayer
#@onready var hurtbox = $Hurtbox
@onready var healthBar = $EntityHealthbar

func get_hp():
	return hp

func set_hp(value):
	if value != hp:
		hp = clamp(value, 0, hp_max)
		emit_signal("hp_changed", hp)
#		healthBar.value = hp
		healthBar.animate_hp_change(hp)
		if hp == 0:
			emit_signal("died")
		elif hp != hp_max:
			healthBar.show()

func set_hp_max(value):
	if value != hp_max:
		hp_max = max(0, value)
		emit_signal("hp_max_changed", hp_max)
		healthBar.max_value = hp_max
		self.hp = hp

func _ready():
	$Exclamation.visible = false
	$Questionmark.visible = false
	horizontal_direction = 0

func _physics_process(_delta):
	#lets you quit the game
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		print("quitting")
		
	#lets you go to the menu
	if Input.is_action_just_pressed("menu"):
			print("menu button pressed")
			get_tree().change_scene_to_file("res://menu stuff/menu scenes/Menu.tscn")
	
	#lets you play the kick animation
	if Input.is_action_just_pressed("kick"):
		print("kicking")
		ap.play("kick")
		attack = true
	
	#makes it so that you fall back down when you jump
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 200:
			velocity.y = 200
	
	#allows you to jump
	if !pause && !attack:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			velocity.y = -jump_force 

	#allows you to move left and right and flip sprite accordingly
	horizontal_direction = Input.get_axis("move_left","move_right")
	if !pause && !attack: 
		velocity.x = speed * horizontal_direction	
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
	move_and_slide()
	update_animation(horizontal_direction)
	
func update_animation(horizontal_direction):
	
	if db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("JENNA MODE"))) > 0.0002:
		footsteps_sound = $JENNAFootsteps as AudioStreamPlayer2D
	
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
	
