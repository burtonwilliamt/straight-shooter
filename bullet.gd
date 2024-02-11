extends Area2D

@export var speed: int = 500
var velocity: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position +=  velocity * speed * delta
