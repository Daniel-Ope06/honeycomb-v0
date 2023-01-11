extends Control

var title_text: Object
var centre_pos: Vector2
var transition_time: float

func _ready() -> void:
	title_text = $"Title Text"
	centre_pos = Vector2(264,20)
	transition_time = 0.6

func animtaeTitle() -> void:
	var tween: Object = create_tween()
	tween.tween_property(title_text, "rect_position", centre_pos, transition_time)

func _on_RestartBtn_pressed() -> void:
	animtaeTitle()
	yield(get_tree().create_timer(transition_time), "timeout")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Game Interface.tscn")
