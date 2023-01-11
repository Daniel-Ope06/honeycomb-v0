class_name GameInterface extends Control

const GAME_BOARD: Object = preload("res://Scenes/Game Board.tscn")

func _ready() -> void:
	setUpBoard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func setUpBoard() -> void:
	var gameBoard: Object = GAME_BOARD.instance()
	add_child(gameBoard)




