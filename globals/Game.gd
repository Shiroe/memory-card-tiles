extends Node

var _Levels: Array[Dictionary] = []
var _SelectedLevel := {};
var _SelectedLevelIndex = 0;

var statistics = {
	level = '1',
	moves = 0,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func getLevels() -> Array[Dictionary]:
	return _Levels;

func setLevels(levels: Array[Dictionary]) -> void:
	_Levels = levels


func getSelectedLevel() -> Dictionary:
	return _SelectedLevel;

func setSelectedLevel(level: Dictionary):
	_SelectedLevel = level;


func getSelectedLevelIndex():
	return _SelectedLevelIndex;

func setSelectedLevelIndex(idx):
	_SelectedLevelIndex = idx;
