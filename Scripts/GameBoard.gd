extends Node2D

# Member varaibles
var random: Object = RandomNumberGenerator.new()
var numberFrequency: Dictionary = {0: 0, 1: 0, 2: 0, 3: 0}
var boardArray: Array = [
	[null, null, null, null, null, null,],
	[null, null, null, null, null, null,],
	[null, null, null, null, null, null,],
	[null, null, null, null, null, null,],
	[null, null, null, null, null, null,],
	[null, null, null, null, null, null,]
]

# Constants
enum COLOUR_SET {ORANGE, YELLOW}
enum CONTROLLER_SET {COMPUTER, PLAYER}
const START_POSITION: Vector2 = Vector2(410, 180)
const SHIFT_ALONG_ROW: Vector2 = Vector2(48, 28)
const SHIFT_ALONG_COL: Vector2 = Vector2(-48, 28)

# Scenes
const HEXAGON: Object = preload("res://Scenes/Hexagon.tscn")


func _ready() -> void:
	random.randomize()
	generateBoard()
	print(boardArray[0][1].pixelToGrid())


func generateBoard() -> void:
	for i in range(6):
		for j in range(6):
			var hexagon: Object = generateHexagon(Vector2(i,j))
			while (not(hexagon.isHexagonValid(boardArray))):
				hexagon = generateHexagon(Vector2(i,j))
			boardArray[i][j] = hexagon

func generateHexagon(gridPosition: Vector2) -> Object:
	var hexagon: Object = HEXAGON.instance()
	hexagon.controller = CONTROLLER_SET.COMPUTER
	hexagon.hexagonColour = random.randi_range(0, 1)
	hexagon.hexagonNumber = random.randi_range(0, 3)
	hexagon.position = gridToPixel(gridPosition)
	add_child(hexagon)
	return hexagon

func gridToPixel(gridPosition: Vector2) -> Vector2:
	var pixelPosition: Vector2 = START_POSITION + (gridPosition.x * SHIFT_ALONG_ROW) + (gridPosition.y * SHIFT_ALONG_COL)
	return pixelPosition
