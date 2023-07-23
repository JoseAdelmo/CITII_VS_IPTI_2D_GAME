extends Area2D

const JUMP_POWER = 70
const RED_TIME = 0.41

var character
var sprite
var red_timer = 0.0
var hit_count = 0  # Variável para contar os impactos

func _ready():
	character = get_parent()
	sprite = character.get_node("AnimatedSprite2D")  # Substitua "AnimatedSprite2D" pelo nome correto do nó do sprite do inimigo

func _on_body_entered(body):
	if body.name == "player":
		character.position += Vector2(100, -70)
		owner.modulate = Color(1, 0, 0, 1)
		red_timer = RED_TIME

		# Incrementa o contador de impactos
		hit_count += 1

		# Verifica se atingiu 15 impactos
		if hit_count >= 99:
			owner.queue_free()

func _process(delta):
	if red_timer > 0.0:
		red_timer -= delta
		if red_timer <= 0.0:
			owner.modulate = Color(1, 1, 1, 1)
