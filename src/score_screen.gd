extends Node2D

@onready var TitleLabel = $Panel/HBoxContainer/VBoxContainer/Label
@onready var MovesLabel = $Panel/HBoxContainer/VBoxContainer/Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TitleLabel.text = "Level  " + str(Game.statistics.level) + "  completed!";
	MovesLabel.text = "Solved in  " + str(Game.statistics.moves) + "  moves";


func _on_level_selection_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LevelSelection.tscn");
