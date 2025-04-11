extends Node2D

@onready var text = $Message
@onready var death_count = 0
var death_messages = ["",
"That was unfortunate", 
"Maybe you should rethink that", 
"I wouldn't have done that if I were you...", 
"Maybe you should take a break and come  back...",
"Maybe you should just quit the game",
"Why are you playing this?",
"Wow",
"Now that's just pathetic",
"Maybe you should try a Youtube tutorial",
"...That tutorial didn't work huh",
"Hand the controller to somebody else please",
"That's it, you don't get death messages",
"...again"]
@export var reset_path = ""
signal anim_done()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	death_count = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if death_count <= 10:
		text.text = death_messages[death_count]
	else:
		text.text = death_messages[-1]

func death():
	show()
	death_count += 1
	$AnimationPlayer.play("death")
	get_parent().get_node("GameOver").show()
	$Death_Sound.play()

func add_to_death_count():
	death_count += 1
