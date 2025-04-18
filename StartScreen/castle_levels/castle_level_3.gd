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
	$AnimationPlayer.play("scene_1")
	await $Dialog.finished
	$AnimationPlayer.play("scene_2")
	$Danger.play()
	await anim_done
	$UFO.show_beam()
	$You.pause = false
	$UFO.set_path_find(true)
	$You.allow_attacking(true)
	game_started = false
	
	await $UFO.died
	print("UFO has died!!!")

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

func animation_over():
	emit_signal("anim_done")
