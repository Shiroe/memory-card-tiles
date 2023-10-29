extends Node2D

var level: Dictionary = {};
var levelIdx: int = 0;


@onready var movesLabel = $HUD/HBoxContainer/VBoxContainer/Moves as Label
@onready var pairsFoundLabel = $HUD/HBoxContainer/VBoxContainer/PairsFound as Label
@onready var levelLabel = $HUD/HBoxContainer/VBoxContainer/Label as Label
@onready var cardButton: PackedScene = load("res://scenes/TileCardButton.tscn");
@onready var grid = $HUD/Control/GridContainer as GridContainer

var isRevealed = false;
var cardsInRevelation: Array = []; 

var movesTaken = 0;
var pairsFound = 0;
var totalPairs = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initializeLevel()
	pairsFoundLabel.text = "Pairs: " + str(pairsFound) + "/" + str(totalPairs);
	print("Starting level: \n", level)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func initializeLevel():
	level = Game.getSelectedLevel();
	levelIdx = Game.getSelectedLevelIndex()
	
	# get card textures
	var files = [];
	Utils.get_all_files('res://NinjaAdventure/Actor/', files, ['png'])
	
	# setup HUD
	levelLabel.text = "Level:  " + str(levelIdx)
	
	totalPairs = level.number / 2
	
	# setup grid based on columns to separate
	grid.columns = level.columns
	
	# setup card pool
	var cards: Array = files.slice(0, level.number / 2)
	cards = cards + cards
	cards.shuffle()
	print('cards size', cards.size())
	
	# get card back texture to re-use
	var cardBackText = Texture.new();
	cardBackText = load('res://NinjaAdventure/HUD/Dialog/card-back.png');
	
	for card in range(0, cards.size()):
		# get specific card from pool
		var texture = load(cards[card]) as Texture2D
		
		var cardButtonElement = cardButton.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE);
		cardButtonElement.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;
		
		var cardText = Texture.new();
		cardText = load(cards[card]);
		cardButtonElement.cardTexture = cardText;
		
		cardButtonElement.pressed.connect(func(): onCardPress(cardButtonElement))
		
		grid.add_child(cardButtonElement);



func onCardPress(card):
	print("Pressed card:", card);
	if cardsInRevelation.size() == 2:
		pass
	elif card.isRevealed or card.isFound:
		pass
	else:
		card.isRevealed = true;
		cardsInRevelation.append(card);
		if cardsInRevelation.size() == 2:
			checkIfFound()
	


func checkIfFound():
	print("Currect selection ", cardsInRevelation);
	if cardsInRevelation[0].cardTexture == cardsInRevelation[1].cardTexture:
		cardsInRevelation[0].isFound = true;
		cardsInRevelation[1].isFound = true;
		cardsInRevelation.clear();
		pairsFound += 1;
		pairsFoundLabel.text = "Pairs: " + str(pairsFound) + "/" + str(totalPairs)
		checkGameOver();
	else:
		await get_tree().create_timer(1.0).timeout
		#var timer = Timer.new();
		#timer.wait_time = 3.0;
		#timer.start()
		#timer.connect('timeout', func(): resetRevealedCards())
		resetRevealedCards()

	print('\n cards in revelation: ',  cardsInRevelation);
	movesTaken += 1;
	movesLabel.text = "Moves: " + str(movesTaken);


func resetRevealedCards():
	cardsInRevelation[0].isRevealed = false;
	cardsInRevelation[1].isRevealed = false;
	cardsInRevelation.clear();


func checkGameOver():
	if pairsFound == totalPairs:
		get_tree().change_scene_to_file("res://scenes/LevelSelection.tscn");

