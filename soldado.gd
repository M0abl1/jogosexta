extends CharacterBody2D

# --- Variáveis de Patrulha ---
@export var speed = 40.0

# ✅ CORREÇÃO AQUI: Damos um valor à gravidade
var gravity = 1000.0
var direction = -1 # Começa andando para a esquerda

# --- Variáveis de Combate ---
var vida: int = 3 # O inimigo tem 3 pontos de vida

# --- Referências de Nós ---
@onready var sprite = $AnimatedSprite2D # Mude se o nome do seu sprite for outro
@onready var detector_parede = $detector_parede
@onready var detector_abismo = $detector_abismo


# --- Funções de Combate ---

# Chamada pelo "Hurtbox" do inimigo quando for atingido
func levar_dano(dano: int):
	vida -= dano
	print("Inimigo tomou dano! Vida restante: ", vida)
	
	if vida <= 0:
		morrer()

func morrer():
	print("Inimigo derrotado!")
	queue_free() # Remove o inimigo da cena


# --- Lógica de Física (Patrulha) ---

func _physics_process(delta):
	# 1. Aplicar Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Lógica para Virar (Checar *antes* de mover)
	
	# Ajusta os sensores e o sprite para a direção atual
	if direction == 1: # Indo para a direita
		sprite.flip_h = false
		# ✅ CORREÇÃO AQUI: Removido o caractere fantasma
		detector_parede.target_position.x = 16
		detector_abismo.position.x = 16
	else: # Indo para a esquerda
		sprite.flip_h = true
		detector_parede.target_position.x = -16
		detector_abismo.position.x = -16

	# 3. Checar Sensores e Mudar Direção
	# Só vira se estiver no chão E (bater na parede OU não achar chão na frente)
	if is_on_floor() and (detector_parede.is_colliding() or not detector_abismo.is_colliding()):
		direction *= -1 # Inverte a direção

	# 4. Definir Velocidade Horizontal
	velocity.x = speed * direction

	# 5. Mover o Inimigo
	move_and_slide()
