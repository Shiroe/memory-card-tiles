extends Node2D

var level: Dictionary = {};
var levelIdx: int = 0;

@onready var levelLabel = $HUD/HBoxContainer/VBoxContainer/Label as Label
@onready var tileCard: PackedScene = load("res://scenes/Tile_Card.tscn")
@onready var grid = $HUD/Control/GridContainer as GridContainer
@onready var faces := [
	preload('res://NinjaAdventure/Actor/Characters/BlackNinjaMage/Faceset.png'), 
	preload('res://NinjaAdventure/Actor/Characters/BlackSorcerer/Faceset.png'), 
	preload('res://NinjaAdventure/Actor/Characters/BlueNinja/Faceset.png'), 
	preload('res://NinjaAdventure/Actor/Characters/BlueSamurai/Faceset.png'), 
	preload('res://NinjaAdventure/Actor/Characters/Cavegirl2/Faceset.png'), 
	preload('res://NinjaAdventure/Actor/Animals/Cat/Faceset.png')
] as Array[Texture2D]

var isRevealed = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initializeLevel()
	print("Starting level: \n", level)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#test.rotate(delta)



func initializeLevel():
	level = Game.getSelectedLevel();
	levelIdx = Game.getSelectedLevelIndex()
	
	# get card textures
	var files = [];
	Utils.get_all_files('res://NinjaAdventure/Actor/', files, ['png'])
	#print('FILES: \n', files);
	
	# setup HUD
	levelLabel.text = "Level:  " + str(levelIdx)
	
	# setup cards
	var gridRect = grid.get_global_rect()
	print('grid rect: ', gridRect.position)
	print('grid pos: ', gridRect)
	var xx = float(floor(grid.global_position.x))
	var xy = float(floor(grid.global_position.x + gridRect.size.x))
	var yx = float(floor(grid.global_position.y))
	var yy = float(floor(grid.global_position.y + gridRect.size.y))
	print('xx: ', xx, ' | xy: ', xy, ' | yx: ', yx, ' yy: ', yy)
	var cards: Array = files.slice(0, level.number / 2)
	cards = cards + cards
	cards.shuffle()
	print('cards size', cards.size())
	print('Viewport: ', get_viewport().size)
	var viewport = get_viewport().size
	for card in range(0, cards.size()):
		var texture = load(cards[card]) as Texture2D
		var gutter = 5
		var scale = 1
		var textureSize = texture.get_size().x
		var temp = tileCard.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		print('textSize:- ', textureSize)
		#temp = Vector2(scale, scale)
		var pos = Vector2(
			(((textureSize * scale) + gutter) * int(card % int(level.width))) - (textureSize * scale),
			(((textureSize * scale) + gutter) * int(card % int(level.height))) - (textureSize * scale)
		)
		print('children', temp.get_children(true)[0])
		
		temp.get_children(true)[0].texture = load(cards[card]);
		grid.add_child(temp)
		grid.get_child(card).position = pos #Vector2((38. * card * 2.0) - (38. * 2.), 0.)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pass
			#print('pos', testsprite.global_position)
			#isWithin(testsprite, event.position)
			#if isWithin(testsprite, event.position):
				#print("A click!", testsprite.position)
				
				#var tween = create_tween()
				#if not isRevealed:
					#tween.tween_property(shaderMat, 'shader_parameter/reveal_progress', 1, 1)
				#else:
					#tween.tween_property(shaderMat, 'shader_parameter/reveal_progress', 0, 1)
				#isRevealed = !isRevealed



func isWithin(sprite: Sprite2D, mouseLocation):
	#print('relative: ', )

	var size = { x= 38, y= 38 }
	var pos = sprite.global_position
	var xL = pos.x - (size.x / 2.0)
	var xR = pos.x + (size.x / 2.0)
	var yL = pos.y - (size.y / 2.0)
	var yR = pos.y + (size.y / 2.0)
	print('xL: ', xL, ' xR: ', xR, ' yL: ', yL, ' yR: ', yR)
	print("is within ", xL <= mouseLocation.x && xR >= mouseLocation.x && yL <= mouseLocation.y && yR >= mouseLocation.y)
	print('MOUSE POS:- ', mouseLocation.x, ', ', mouseLocation.y)
	return xL <= mouseLocation.x && xR >= mouseLocation.x && yL <= mouseLocation.y && yR >= mouseLocation.y
	
	
