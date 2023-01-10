extends Node2D

const HEXAGON: Object = preload("res://Scenes/Hexagon.tscn")
const START_POS: Vector2 = Vector2(410, 180)
const SHIFT_ALONG_ROW: Vector2 = Vector2(48, 28)
const SHIFT_ALONG_COL: Vector2 = Vector2(-48, 28)

var rng: Object = RandomNumberGenerator.new()

func _ready() -> void:
	createBoard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func createHexagon(colour: String, number: int, pos: Vector2) -> void:
	var hexagon: Object = HEXAGON.instance()
	add_child(hexagon)
	hexagon.setColour(colour)
	hexagon.setNumber(number, "PLAYER")
	hexagon.setPosition(pos)

func createBoard() -> void:
	var boardArray: Array = createBoardArray()
	for i in range(6):
		var current_row: Vector2 = START_POS + (i * SHIFT_ALONG_COL)
		for j in range(6):
			var hexagonDict: Dictionary = boardArray[i][j]
			var value: int = hexagonDict["value"]
			var colour: String = hexagonDict["colour"]
			createHexagon(colour, value, current_row + (j*SHIFT_ALONG_ROW))

func createBoardArray() -> Array:
	var boardArray: Array = [
		[null, null, null, null, null, null],
		[null, null, null, null, null, null],
		[null, null, null, null, null, null],
		[null, null, null, null, null, null],
		[null, null, null, null, null, null],
		[null, null, null, null, null, null]
	]
	
	for i in range(6):
		for j in range(6):
			boardArray[i][j] = guessHexagon()
			#if (not( ))
	
	return boardArray

func guessHexagon() -> Dictionary:
	var hexagonDict: Dictionary = {
		"value": (rng.randi_range(0, 3)),
		"colour": guessColour()
	}
	return hexagonDict

func isHexagonValid(hexagonDict: Dictionary, index: Vector2) -> bool:
	if ("YELLOW".casecmp_to(hexagonDict["colour"])):
		pass
	
	return true

func guessColour() -> String:
	var colours: Array = ["ORANGE", "YELLOW"]
	return colours[(rng.randi_range(0, 1))]
