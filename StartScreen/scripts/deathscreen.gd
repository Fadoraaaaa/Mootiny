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
"Who are you?",
"Hand the controller to somebody else please",
"That's it, you aren't even worth death messages",
"...again"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	death_count = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if death_count <= 10:
		text.text = death_messages[death_count]
	else:
		text.text = death_messages[-1]

func death():
	death_count += 1
	$AnimationPlayer.play("death")
