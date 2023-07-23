extends Area2D

func _on_body_entered(body):
	if body.name == "player":
		var character = get_parent()
		character.position += Vector2(100, -70)
