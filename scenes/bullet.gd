extends Area2D

@export var speed = 1200
var direction = Vector2.UP
signal bullet_hit(bullet, body)

func _process(delta):
	position += direction * speed * delta



func _on_body_entered(body):
	bullet_hit.emit(self,body)
