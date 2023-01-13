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
const POSSIBLE_VALUES: Array = [
	{"NUMBER":0, "COLOUR":COLOUR_SET.YELLOW}, 
	{"NUMBER":1, "COLOUR":COLOUR_SET.YELLOW}, 
	{"NUMBER":2, "COLOUR":COLOUR_SET.YELLOW}, 
	{"NUMBER":3, "COLOUR":COLOUR_SET.YELLOW}, 
	{"NUMBER":0, "COLOUR":COLOUR_SET.ORANGE},
	{"NUMBER":1, "COLOUR":COLOUR_SET.ORANGE},
	{"NUMBER":2, "COLOUR":COLOUR_SET.ORANGE},
	{"NUMBER":3, "COLOUR":COLOUR_SET.ORANGE}
]
const START_POSITION: Vector2 = Vector2(410, 180)
const SHIFT_ALONG_ROW: Vector2 = Vector2(48, 28)
const SHIFT_ALONG_COL: Vector2 = Vector2(-48, 28)

# Scenes
const HEXAGON: Object = preload("res://Scenes/Hexagon.tscn")


func _ready() -> void:
	random.randomize()
	
	# Test Board: Puzzle 1
#	boardArray[1][1] = createHexagon(Vector2(1,1), 3, COLOUR_SET.YELLOW)
#	boardArray[1][2] = createHexagon(Vector2(1,2), 2, COLOUR_SET.YELLOW)
#	boardArray[1][5] = createHexagon(Vector2(1,5), 3, COLOUR_SET.YELLOW)
#	boardArray[2][0] = createHexagon(Vector2(2,0), 1, COLOUR_SET.YELLOW)
#	boardArray[2][5] = createHexagon(Vector2(2,5), 1, COLOUR_SET.YELLOW)
#	boardArray[3][3] = createHexagon(Vector2(3,3), 0, COLOUR_SET.YELLOW)
#	boardArray[4][1] = createHexagon(Vector2(4,1), 2, COLOUR_SET.YELLOW)
#	boardArray[5][3] = createHexagon(Vector2(5,3), 0, COLOUR_SET.YELLOW)
	
	generateSolvedBoard()
	printBoardArray()
	#print(boardArray[3][5].pixelToGrid())
	#boardArray[gridPosition.x + direction.x][gridPosition.y + direction.y]
	
	#print(boardArray[0][5].hexagonNumber)
	#print(boardArray[5][0].hexagonNumber)
	


func generateSolvedBoard() -> bool:
	for i in range(6):
		for j in range(6):
			if (boardArray[i][j] == null):
				var hexagon: Object = generateHexagon(Vector2(i,j))
				for value in POSSIBLE_VALUES:
					hexagon.hexagonNumber = value["NUMBER"]
					hexagon.hexagonColour = value["COLOUR"]
					if (hexagon.isHexagonValid(boardArray)):
						add_child(hexagon)
						boardArray[i][j] = hexagon
						if (generateSolvedBoard()):
							return true
						print("No Solution")
						boardArray[i][j] = null
						#remove_child(hexagon)
						hexagon.queue_free()
				#print(String(boardArray[i][j].hexagonNumber) + "|" + String(boardArray[i][j].hexagonColour) + "|" + String(boardArray[i][j].pixelToGrid()))
				return false
	return true

func generateHexagon(gridPosition: Vector2) -> Object:
	var hexagon: Object = HEXAGON.instance()
	hexagon.controller = CONTROLLER_SET.PLAYER
	#hexagon.hexagonColour = random.randi_range(0, 1)
	#hexagon.hexagonNumber = random.randi_range(0, 3)
	hexagon.position = gridToPixel(gridPosition)
	return hexagon

func createHexagon(gridPosition: Vector2, hexagonNumber: int, hexagonColour: int) -> Object:
	var hexagon: Object = HEXAGON.instance()
	hexagon.controller = CONTROLLER_SET.COMPUTER
	hexagon.hexagonColour = hexagonColour
	hexagon.hexagonNumber = hexagonNumber
	hexagon.position = gridToPixel(gridPosition)
	return hexagon


func gridToPixel(gridPosition: Vector2) -> Vector2:
	var pixelPosition: Vector2 = START_POSITION + (gridPosition.x * SHIFT_ALONG_COL) + (gridPosition.y * SHIFT_ALONG_ROW)
	return pixelPosition

func printBoardArray():
	for i in range(6):
		print(
			String(boardArray[i][0].hexagonNumber) + "|" + String(boardArray[i][0].hexagonColour) + " " +
			String(boardArray[i][1].hexagonNumber) + "|" + String(boardArray[i][1].hexagonColour) + " " + 
			String(boardArray[i][2].hexagonNumber) + "|" + String(boardArray[i][2].hexagonColour) + " " +
			String(boardArray[i][3].hexagonNumber) + "|" + String(boardArray[i][3].hexagonColour) + " " +
			String(boardArray[i][4].hexagonNumber) + "|" + String(boardArray[i][4].hexagonColour) + " " +
			String(boardArray[i][5].hexagonNumber) + "|" + String(boardArray[i][5].hexagonColour) + " "
		)


