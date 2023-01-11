extends Node2D

# Member variables
export (int, "ORANGE", "YELLOW", "PURPLE", "GREEN", "LIME") var hexagonColour = 1
export (int, "COMPUTER", "PLAYER") var controller = 1
export (int, 3) var hexagonNumber = 2

# Constants
const PLAYER_NUMBERS: Dictionary = {0: 9, 1: 0, 2: 1, 3: 2} # number: frame
const COMPUTER_NUMBERS: Dictionary = {0: 19, 1: 10, 2: 11, 3: 12} # number: frame
const START_POSITION: Vector2 = Vector2(410, 180)
const SHIFT_ALONG_ROW: Vector2 = Vector2(48, 28)
const SHIFT_ALONG_COL: Vector2 = Vector2(-48, 28)

func _ready() -> void:
	$"Hexagon Sprite".frame = hexagonColour
	
	match controller:
		0: $"Number Sprite".frame = COMPUTER_NUMBERS[hexagonNumber]
		1: $"Number Sprite".frame = PLAYER_NUMBERS[hexagonNumber]

func isHexagonValid(boardArray: Array) -> bool:
	# check conditions
	return true


func pixelToGrid(pixelPosition: Vector2) -> Vector2:
	var gridPosition: Vector2 = Vector2.ZERO
	gridPosition.x = ((SHIFT_ALONG_COL.x * (START_POSITION.y - pixelPosition.y))  +  (SHIFT_ALONG_COL.y * (pixelPosition.x - START_POSITION.x))) / ((SHIFT_ALONG_ROW.x * SHIFT_ALONG_COL.y) - (SHIFT_ALONG_ROW.y * SHIFT_ALONG_COL.x))
	gridPosition.y = ((SHIFT_ALONG_ROW.y * (pixelPosition.x - START_POSITION.x)) + (SHIFT_ALONG_ROW.x * (START_POSITION.y - pixelPosition.y))) / ((SHIFT_ALONG_COL.x * SHIFT_ALONG_ROW.y) - (SHIFT_ALONG_COL.y * SHIFT_ALONG_ROW.x))
	return gridPosition


