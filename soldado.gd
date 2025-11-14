extends CharacterBody2D

# --- Variáveis de Patrulha ---
@export var speed = 100.0

# var gravity = 400 # ✅ REMOVIDO
var direction = -1      # Começa andando para a direita

# --- Variáveis de Combate ---
var vida: int = 1 # O inimigo tem 3 pontos de vida

# --- Referências de Nós ---
@onready var sprite: AnimatedSprite2D = $Sprite
#@onready var detector_parede: RayCast2D = $detector_parede
# @onready var detector_abismo: RayCast2D = $detector_abismo # ✅ REMOVIDO (Não faz sentido sem gravidade)


# --- Funções de Combate ---
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
	
	# Verificação de segurança
	# if sprite == null or detector_parede == null:
		#print("ERRO: Um dos nós (Sprite ou detector_parede) não foi encontrado. Verifique os nomes na cena!")
		# return
	
	# 1. Aplicar Gravidade
	# ✅ REMOVIDO
	# if not is_on_floor():
	# 	velocity.y += gravity * delta
	
	# ✅ NOVO: Garantir que a velocidade Y seja 0 (para não flutuar para cima/baixo)

	# 2. Lógica para Virar (Ajuste de Sprite e Sensores)
	if direction == 1: # Indo para a direita
		sprite.flip_h = false
	#	detector_parede.target_position.x = 5 # Aponta o raio de parede para a direita
	else: # Indo para a esquerda
		sprite.flip_h = true
	#	detector_parede.target_position.x = 5 # Aponta o raio de parede para a esquerda

	# 3. Checar Sensores e Mudar Direção
	# ✅ ATUALIZADO: Agora só vira se bater na parede.
#	if detector_parede.is_colliding():
#		direction *= -1 # Inverte a direção (1 vira -1, -1 vira 1)

	# 4. Definir Velocidade Horizontal
	velocity.x = speed * direction

	# 5. Mover o Inimigo
	move_and_slide()
	
func _on_zona_de_morte_body_entered(body):
	
	# Verificamos se o corpo que entrou está no grupo "jogador"
	# (Lembre-se que definimos este grupo no guia_cena_personagem.md)
	if body.is_in_group("jogador"):
		
		# Se for o jogador, chamamos a função "morrer()"
		# que já existe no script do Personagem.
		print("Jogador caiu na Zona de Morte!")
		body.morrer()
		

# --- Sinais Conectados (do guia_cena_soldado.md) ---

func _on_hitbox_dano_body_entered(body):
	if body.is_in_group("jogador"):
		body.levar_dano(1)

func _on_hurtbox_area_entered(area):
	if area.name == "HitboxAtaque":
		levar_dano(1)
