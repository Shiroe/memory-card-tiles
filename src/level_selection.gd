extends Node2D


@export var rangeStart: float = 6.0;
@export var rangeEnd: float = 128.0;
@export var minRatio: float = 0.75;
@export var maxRatio: float = 1.33;

@onready var gridContainer = $Control/GridContainer as GridContainer;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setupGridLevels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func selectLevel(idx, lvl):
	Game.setSelectedLevel(lvl)
	Game.setSelectedLevelIndex(idx)

	get_tree().change_scene_to_file("res://scenes/level.tscn")
	print("Level selected: ", lvl)


func setupGridLevels():
	# first calculate the valid levels for the specified number range
	var levels := Utils.findNumbersWithAspectRatios(rangeStart, rangeEnd, minRatio, maxRatio);
	levels.sort_custom(Utils.sortByNumber)

	Game.setLevels(levels)

	gridContainer.columns = 5

	var idx = 1;
	for level in Game.getLevels():
		# use of texture button so we can have pressed signal
		var buttonWithTexture = TextureButton.new()
		var texture = Texture2D.new()
		var label = Label.new()

		# Set texture with papyrous scroll asset
		texture = load("res://NinjaAdventure/Items/Scroll/ScrollEmpty.png")

		# setup button with texture and callback func
		buttonWithTexture.custom_minimum_size.x = 80
		buttonWithTexture.custom_minimum_size.y = 80
		buttonWithTexture.set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)
		buttonWithTexture.texture_normal = texture
		buttonWithTexture.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		buttonWithTexture.size_flags_vertical = Control.SIZE_EXPAND_FILL
		buttonWithTexture.pressed.connect(func(): selectLevel(idx, level))

		# Set label styles and text
		label.text = str(idx)
		#label.position.x += 2
		#label.position.y = 3
		label.set_position(Vector2(2, 3))
		var fontSize = floor((gridContainer.size.x / 6 ) * 0.25) + 5
		
		label.add_theme_font_override('font', load('res://NinjaAdventure/NormalFont.ttf'))
		label.add_theme_font_size_override('font_size', fontSize)
		
		#label.add_theme_color_override('font_shadow_color', Color('#8f3e56'))
		label.add_theme_constant_override('shadow_offset_x', -1)
		label.add_theme_constant_override('shadow_offset_y', 2)
		
		label.set_anchors_preset(Control.PRESET_FULL_RECT)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		# add stuff to ui
		buttonWithTexture.add_child(label)
		gridContainer.add_child(buttonWithTexture);
		idx += 1

