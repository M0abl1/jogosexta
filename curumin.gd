extends CharacterBody2D

# --- Constantes de Física ---
# (Você precisará ajustar estes valores para seu jogo)
const VELOCIDADE_ANDAR: float = 150.0
const FORCA_PULO: float = -300.0
const GRAVIDADE: float = 800.0

# --- Variáveis de Estado ---
var vida_max: int = 3
var vida_atual: int = 3
var ultimo_checkpoint_pos: Vector2

# --- Referências de Nós ---
# (Pega os nós filhos para acesso rápido)
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox_ataque: Area2D = $HitboxAtaque

# --- Sinais ---
# Sinal emitido para a HUD saber que a vida mudou
signal saude_mudou(vida_atual: int)

# Chamado assim que a cena entra na árvore (quando o jogo começa)
func _ready():
	# Define a vida atual para a vida máxima
	vida_atual = vida_max
	# Define a posição inicial de checkpoint
	ultimo_checkpoint_pos = global_position
	print("Personagem pronto!")

# Chamado a cada frame de física (o coração da lógica do jogo)
func _physics_process(delta: float):
	
	# --- Gravidade ---
	# Aplica gravidade se não estiver no chão
	if not is_on_floor():
		velocity.y += GRAVIDADE * delta

	# --- Lógica de Pulo ---
	# Verifica se a ação "pular" (Barra de Espaço) foi pressionada
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = FORCA_PULO

	# --- Lógica de Movimento (Esquerda/Direita) ---
	# Pega a entrada do jogador (-1 para esquerda, 1 para direita, 0 parado)
	var direcao = Input.get_axis("esquerda", "direita")
	velocity.x = direcao * VELOCIDADE_ANDAR
	
	# --- Lógica de Animação ---
	# Atualiza a animação com base no estado
	if not is_on_floor():
		sprite.play("pulando")
	elif direcao != 0:
		sprite.play("andando")
	else:
		sprite.play("parado")
	
	# Vira o sprite para a direção correta
	if direcao > 0:
		sprite.flip_h = false # Olhando para a direita
	elif direcao < 0:
		sprite.flip_h = true # Olhando para a esquerda
	
	# --- Lógica de Ataque ---
	# (Ainda não vamos implementar o dano, só a animação)
	if Input.is_action_just_pressed("atacar"):
		sprite.play("atacando")
		# Em um passo futuro, ativaremos a hitbox aqui
		# hitbox_ataque.monitoring = true 
		# (e usaremos um Timer para desativá-la)

	# Aplica o movimento
	move_and_slide()


# --- Funções de Combate (Plano) ---

# Chamada por inimigos ou armadilhas
func levar_dano(dano: int):
	vida_atual -= dano
	
	# Emite o sinal para a HUD se atualizar
	saude_mudou.emit(vida_atual)
	
	print("Personagem tomou dano! Vidas restantes: ", vida_atual)

	if vida_atual <= 0:
		morrer()

# Chamada quando a vida chega a zero
func morrer():
	print("PERSONAGEM MORREU!")
	# O jeito mais simples de resetar a fase
	get_tree().reload_current_scene()
