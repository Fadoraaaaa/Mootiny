extends Node2D

signal anim_done()
var death = false
var hiding = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.current_location = 5
	$AnimationPlayer.play("scene_1")
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
	
	pass # Replace with function body.

func set_level():
	$You.allow_attacking(true)
	$You.position = Vector2i(300,700)
	$You.visible = true
	$UFO.set_path_find(false)
	$UFO.position = Vector2i(-371, 198)
	death =  false
	$GameOver.hide()
	$You.set_gravity(25)
	$Deathscreen.hide()
	$TileMap.set_cell(2, Vector2i(52,-2), 0, Vector2i(2, 28), 0)
	$You.pause = true

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
	
	#setting tile to an OPEN staircase
	$TileMap.set_cell(2, Vector2i(52,-2), 0, Vector2i(8, 32), 0)

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Deathscreen.position = Vector2($You.position.x - 510, $You.position.y-765)
	pass

func animation_over():
	emit_signal("anim_done")


func _on_void_of_death_body_entered(body: CharacterBody2D) -> void:
	if body.name == "You":
		death = true
		$Deathscreen.death()
		$You.set_gravity(0)
		$You.velocity.y = 0
	pass # Replace with function body.


func beam_collide(body):
	if body.name == "You" and !death and !hiding:
		$UFO.get_node("Whoosh").play()
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

	pass


func _on_safe_area_body_entered(body: Node2D) -> void:
	if body.name == "You":
		hiding = true
		print("HIDING")
	pass # Replace with function body.


func _on_safe_area_body_exited(body: Node2D) -> void:
	hiding = false
	print("NOT HIDING")
	pass # Replace with function body.
	
