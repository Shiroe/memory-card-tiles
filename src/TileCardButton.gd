extends TextureButton

var cardBack = preload('res://NinjaAdventure/HUD/Dialog/card-back.png');
var isFound: bool = false;
var isRevealed: bool = false;
var cardTexture: Texture2D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.texture_disabled = cardBack;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isFound:
		self.texture_normal = cardTexture;
	elif isRevealed:
		self.texture_normal = cardTexture;
	else:
		self.texture_normal = cardBack;

