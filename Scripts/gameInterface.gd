extends Control

const HEXAGON: Object = preload("res://Scenes/Hexagon.tscn")
const START_POS: Vector2 = Vector2(410, 180)
const SHIFT_ALONG_ROW: Vector2 = Vector2(48, 28)
const SHIFT_ALONG_COL: Vector2 = Vector2(-48, 28)

func _ready() -> void:
	createBoard()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func createHexagon(colour: String, number: int, isNumberVisible: bool, pos: Vector2) -> void:
	var hexagon: Object = HEXAGON.instance()
	$"Game Board".add_child(hexagon)
	hexagon.setColour(colour)
	hexagon.setNumber(number, "PLAYER")
	hexagon.setPosition(pos)

func createBoard() -> void:
	for i in range(6):
		var current_row: Vector2 = START_POS + (i * SHIFT_ALONG_COL)
		createHexagon("YELLOW", 2, true, current_row)
		
		for j in range(6):
			createHexagon("YELLOW", 2, true, current_row + (j*SHIFT_ALONG_ROW))




