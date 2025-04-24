extends CharacterBody2D

@export var buzz = false
@export var swirl = false
@export var whoosh = false
@export var baby = false
@export var headphones_baby = false
@export var sad_baby = false
@export var path_finding = false
@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var speed = 400

signal at_10_hp()
signal beam_player()

var hiding = false

signal hp_max_changed(new_hp_max)
signal hp_changed(new_hp)
signal died

const INDICATOR_DAMAGE = preload("res://level2/DamageIndicator.tscn")


@export var hp_max: int = 100: set = set_hp_max
@export var hp: int = hp_max: get = get_hp, set = set_hp
@export var defense: int = 0

@export var receives_knockback: bool = true
@export var knockback_modifier: float = 0.1

var vel: Vector2 = Vector2.ZERO

@export var EFFECT_HIT: PackedScene = null
@export var EFFECT_DIED: PackedScene = null

@onready var sprite = $Sprite2D
@onready var animPlayer = $AnimationPlayer
@onready var hurtbox = $Hurtbox
@onready var healthBar = $EntityHealthbar
var dead = false


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
		
		if is_instance_valid(healthBar):
			healthBar.max_value = hp_max
		self.hp = hp

func die():
	spawn_effect(EFFECT_DIED)
	print("HAS DIED")
	#queue_free()
	dead = true
	visible = false

func receive_damage(base_damage: int):
	var actual_damage = base_damage
	actual_damage -= defense
	if !dead:
		$Metal.play()
	self.hp -= actual_damage
	if get_hp() == 10:
		emit_signal("at_10_hp")
	return actual_damage

func receive_knockback(damage_source_pos: Vector2, received_damage: int):
	if receives_knockback:
		var knockback_direction = damage_source_pos.direction_to(self.global_position)
		var knockback_strength = received_damage * knockback_modifier
		var knockback = knockback_direction * knockback_strength
		
		global_position += knockback

func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

func spawn_dmgIndicator(damage: int):
	var indicator = spawn_effect(INDICATOR_DAMAGE)
	if indicator:
		indicator.label.text = str(damage)

func _ready():
	$UfoBeam.visible = false
	$Exclamation.visible = false
	hiding = false
	if !baby and !sad_baby and !headphones_baby:
		sprite.play("default")
	if sad_baby:
		sprite.play("baby_sad")
	if headphones_baby:
		sprite.play("headphones_baby")
	if baby:
		sprite.play("baby")
	healthBar.visible = false
	
func show_beam():
	$AnimationPlayer.play("show_beam")

func hide_beam():
	$AnimationPlayer.play("stop_beam")
	
func set_hiding(is_true):
	hiding = is_true

func _physics_process(_delta):
	if path_finding:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed
	for body in $UfoBeam/Area2D.get_overlapping_bodies():
		if body.name == "You":
			_on_area_2d_body_entered(body)
	move_and_slide()

func set_sprite(sprite_name):
	sprite.play(sprite_name)

func makepath() -> void:
	nav_agent.target_position = Vector2(player.global_position.x, player.global_position.y-380)

func _process(_delta):
	if buzz:
		if db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("JENNA MODE"))) < 0.0002:
			if !$Buzz.playing:
				$Buzz.play()
		else:
			if !$JENNA_Buzz.playing:
				$JENNA_Buzz.play()
	if swirl and !$Swirl.playing:
		if db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("JENNA MODE"))) < 0.0002:
			if !$Swirl.playing:
				$Swirl.play()
		else:
			if !$JENNA_Swirl.playing:
				$JENNA_Swirl.play()
	if whoosh and !$Whoosh.playing:
		if db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("JENNA MODE"))) < 0.0002:
			if !$Whoosh.playing:
				$Whoosh.play()
		else:
			if !$JENNA_Whoosh.playing:
				$JENNA_Whoosh.play()

func play_sound(sound):
	if sound == "buzz":
		buzz = true
	if sound == "swirl":
		swirl = true
	if sound == "whoosh":
		whoosh = true

func stop_sound(sound):
	if sound == "buzz":
		buzz = false
	if sound == "swirl":
		swirl = false
	if sound == "whoosh":
		whoosh = false
	
	
#beam has been entered
func _on_area_2d_body_entered(body) -> void:
	if $UfoBeam.visible and visible and !hiding and $UfoBeam.modulate.a > 0.5:
		if body.name =="You":
			emit_signal("beam_player")
	
	
func _on_hurtbox_area_entered(body):
	var actual_damage = receive_damage(body.damage)
	
	if body.is_in_group("Projectile"):
		healthBar.visible = true
		body.destroy()
	
	if !dead:
		receive_knockback(body.global_position, actual_damage)
		spawn_effect(EFFECT_HIT)
		spawn_dmgIndicator(actual_damage)

func set_path_find(is_path_finding):
	path_finding = is_path_finding

func _on_timer_timeout() -> void:
	if path_finding:
		makepath()

func get_speed():
	return speed

func get_dead():
	return dead

func show_emote(emotion):
	if emotion == "surprise":
		$Exclamation.visible = true
		$EmotionIndicator.play()
		await get_tree().create_timer(2).timeout
		$Exclamation.visible = false
