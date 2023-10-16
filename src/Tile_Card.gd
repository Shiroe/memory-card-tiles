extends Node2D

@onready var sprite := $Sprite2D as Sprite2D
@onready var cardBackSprite := $CardBack as Sprite2D

var shaderMat: ShaderMaterial;
var shader: Shader;

var isRevealed = false;
var isFound = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader = preload('res://src/shaders/tileCard.gdshader').duplicate() as Shader
	shaderMat = preload('res://src/shaders/tileCard.tres').duplicate() as ShaderMaterial
	shaderMat.shader = shader
	sprite.material = shaderMat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isFound:
		cardBackSprite.visible = false;
		shaderMat.set_shader_parameter('reveal_progress', 1)


func _input(event):
	if event is InputEventMouseButton and not isFound:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print('pos', sprite.get_rect().has_point(event.position))

			if isWithin(sprite, event.position):
				var tween = create_tween()
				if not isRevealed:
					tween.parallel().tween_property(cardBackSprite, 'visible', false, 0.1).set_ease(Tween.EASE_IN_OUT)
					tween.parallel().tween_property(shaderMat, 'shader_parameter/reveal_progress', 1.0, 0.4)
					#shaderMat.set_shader_parameter('reveal_progress', 1.0)
				else:
					#shaderMat.set_shader_parameter('reveal_progress', 0.0)
					tween.parallel().tween_property(shaderMat, 'shader_parameter/reveal_progress', 0.0, 0.3)
					tween.parallel().tween_property(cardBackSprite, 'visible', true, 0.4).set_ease(Tween.EASE_IN_OUT)
				isRevealed = !isRevealed



func isWithin(_sprite: Sprite2D, mouseLocation):
	print('sprite size: ', _sprite.get_rect().size)
	var size = _sprite.get_rect().size
	var pos = _sprite.global_position
	var xL = pos.x - (size.x / 2.0)
	var xR = pos.x + (size.x / 2.0)
	var yL = pos.y - (size.y / 2.0)
	var yR = pos.y + (size.y / 2.0)
	#print('xL: ', xL, ' xR: ', xR, ' yL: ', yL, ' yR: ', yR)
	#print("is within ", xL <= mouseLocation.x && xR >= mouseLocation.x && yL <= mouseLocation.y && yR >= mouseLocation.y)
	#print('MOUSE POS:- ', mouseLocation.x, ', ', mouseLocation.y)
	return xL <= mouseLocation.x && xR >= mouseLocation.x && yL <= mouseLocation.y && yR >= mouseLocation.y
