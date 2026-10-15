extends Node2D


var speed: float = 0
var max_speed: float = 500
var velocity: Vector2 = Vector2(0,0) # текущая скорость в определенном напрвлении

@onready var speedLabel: Label = get_node("speedometer")
@onready var sprite: Sprite2D = get_node("shift_sprite/shield")
@onready var ship_area: Area2D = get_node("shipArea")

var shield_restoration: float = 0
var lifetime: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship_area.area_entered.connect(_on_ship_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime += delta

	if Input.is_action_pressed("ui_up"):
		speed += 500 * delta
		if speed > max_speed:
			speed = max_speed
	if Input.is_action_pressed("ui_down"):
		speed -= 500 * delta
		if speed < 0:
			speed = 0
	if Input.is_action_pressed("ui_left"):
		rotation -= 5 * delta
	if Input.is_action_pressed("ui_right"):
		rotation += 5 * delta
		
	# система полярных координат
	var x = 0.1 * cos(rotation + PI / 2)
	var y = 0.1 * sin(rotation + PI / 2) 
	
	velocity = speed * delta * Vector2(x, y).normalized()
	speedLabel.text = ("%d" %velocity.length())
	speedLabel.rotation = velocity.angle_to(Vector2(0,1))
	position += velocity
	
	if shield_restoration > 0:
		shield_restoration -= delta
	if shield_restoration <= 0:
		sprite.visible = true
			
			
func damaged():
	lifetime = 0.0
	sprite.visible = false
	shield_restoration = 1.0
	
	
func _on_ship_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"):
		damaged()	
