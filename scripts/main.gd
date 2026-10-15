extends Node2D

@onready var player = get_node("Play")
@onready var asteroid = get_node("Asteroid")
@onready var enemy = $Enemy
@onready var enemies: Node2D = $Enemies
@onready var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

var count: int = 10
var lifetime_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	asteroid.colided.connect(player.damaged)

	# Создание надписи со временем жизни корабля
	lifetime_label = Label.new()
	lifetime_label.position = Vector2(20, 20)
	lifetime_label.add_theme_font_size_override("font_size", 24)
	lifetime_label.text = "Время жизни: 0 сек."
	add_child(lifetime_label)

	for i in count:
		var enemy_instance = enemy_scene.instantiate()
		enemy_instance.scale = Vector2(0.5, 0.5)
		enemies.add_child(enemy_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# отображение времени жизни корабля
	lifetime_label.text = "Время жизни: %d сек." % int(player.lifetime)

	# отдельный враг кружит вокруг корабля
	enemy.orbit(player.position, delta)

	for child in enemies.get_children():
		child.alignment(enemies)
		#child.separate(enemies)
