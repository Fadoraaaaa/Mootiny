extends Node2D

signal anim_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("fade_in")
	await anim_done
	$AnimationPlayer.play("scene_1")
	await anim_done
	$AnimationPlayer.play("fade_out")
	await anim_done
	get_tree().change_scene_to_file("res://level2/level_2_part2.tscn")
	print("changed scene?")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func animation_over():
	emit_signal("anim_done")
