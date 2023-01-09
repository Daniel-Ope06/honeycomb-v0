extends Node2D

const COLOR_CODE: Dictionary = {"ORANGE": 0, "YELLOW": 1, "PURPLE": 2, "GREEN": 3, "LIME": 4}
const PLAYER_NUMBERS: Dictionary = {0: 9, 1: 0, 2: 1}
const COMPUTER_NUMBERS: Dictionary = {0: 19, 1: 10, 2: 11}

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func setColour(colour: String) -> void:
	$"Hexagon Sprite".frame = COLOR_CODE[colour]

func setNumber(number: int, controller: String) -> void:
	match controller:
		"PLAYER": $"Number Sprite".frame = PLAYER_NUMBERS[number]
		"COMPUTER": $"Number Sprite".frame = COMPUTER_NUMBERS[number]

func setPosition(pos: Vector2) -> void:
	position = pos
