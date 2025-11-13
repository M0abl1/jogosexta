extends CharacterBody2D

# --- Variáveis ---
@export var speed = 40.0
@export var gravity = 1000.0

# 1 para direita, -1 para esquerda
var direction = -1

@onready var sprite = $AnimatedSprite2D # Mude para $Sprite2D se for o caso
@onready var detector_parede = $detector_parede
@onready var detector_abismo = $detector_abismo


func _physics_process(delta):
	# 1. Aplicar Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Lógica para Virar (Checar *antes* de mover)
	
	# Ajusta os sensores e o sprite para a direção atual
	if direction == 1: # Indo para a direita
		sprite.flip_h = false
		detector_parede.target_position.x = 16  # Mude 16 para a borda do seu sprite
		detector_abismo.position.x = 16
	else: # Indo para a esquerda
		sprite.flip_h = true
		detector_parede.target_position.x = -16 # Mude -16 para a borda do seu sprite
		detector_abismo.position.x = -16

	# 3. Checar Sensores e Mudar Direção
	# Só vira se estiver no chão E (bater na parede OU não achar chão na frente)
	if is_on_floor() and (detector_parede.is_colliding() or not detector_abismo.is_colliding()):
		direction *= -1 # Inverte a direção

	# 4. Definir Velocidade Horizontal
	# Usa a direção (que pode ter acabado de ser invertida)
	velocity.x = speed * direction

	# 5. Mover o Inimigo
	move_and_slide()
