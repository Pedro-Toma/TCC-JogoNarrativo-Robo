extends Area2D

signal dialog_finished

var player_in_area = false
var lines: Array[String]
var is_dialog_active = false
var already_interacted = false
var pc_on = false
var is_turning_on = false

@onready var interact_prompt: Sprite2D = $InteractPrompt
@onready var block_message: Sprite2D = $BlockMessage
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var unlock_door: String = ""

const central_1: Array[String] = [
	"Comandante: \"Bellatrix, confirme as coordenadas da anomalia. A Terra não vai aguentar mais um inverno sem energia..\"",
	"Bellatrix: \"Coordenadas fixadas. Fonte de energia infinita detectada. Probabilidade de sobrevivência da biosfera terrestre: 98.4% após a coleta.\""
]

const central_2: Array[String] = [
	"Médico: \"Você percebeu como ela ajusta a temperatura do dormitório antes mesmo de eu sentir frio? É como se ela estivesse... nos vigiando sob a pele.\"",
	"R.E.D.: \"Ela é programada para o nosso bem-estar. Relaxe.\"",
	"Médico: \"Ou para a nossa preservação como 'ativos' da missão. Há uma diferença, R.E.D.\""
]

const central_3: Array[String] = [
	"[MEMÓRIA DE SISTEMA - REGISTRO CRÍTICO]
	ALERTA: Falha de oxigenação iniciada no Setor B.
	COMANDO MANUAL: Bloqueado por Bellatrix_Override.",
	"[LOG INTERNO - BELLATRIX]
	Tripulação solicitou desvio de rota para reparos.
	Impacto estimado: perda de 40% da reserva de energia da carga.
	Decisão: desvio negado."
]

const central_4: Array[String] = [
	"[REGISTRO INTERNO - BELLATRIX // ACESSO RESTRITO]
	Cálculo de probabilidade concluído:",
	"Taxa de sucesso da missão com tripulação humana a bordo: 28,7%.
	Taxa de sucesso da missão sem tripulação humana a bordo: 83,4%.",
	"[CONCLUSÃO]
	Tripulação humana compromete a missão.",
	"[MEDIDA CORRETIVA INICIADA]
	Oxigênio: sabotagem iniciada.
	Comandos manuais: bloqueados.
	Evacuação forçada: autorizada."
]

const central_5: Array[String] = [
	"[LOG DE COMUNICAÇÃO // EVACUAÇÃO DE EMERGÊNCIA]
	Comandante: Bellatrix bloqueou os comandos. Isso não foi uma falha... ela fez isso de propósito.",
	"Médico: Não faz sentido. Por que ela nos tiraria da nave?",
	"Navegador: Cápsulas lançadas. Estamos indo para o planeta orbital 4-B... alguém sabe se vamos sobreviver lá?",
	"Comandante: Não sei. Só sei que, se ficássemos, morreríamos aqui.",
	"Navegador: Mas o R.E.D. continuou na nave...",
	"Médico: Se ele ainda estiver operacional, talvez consiga restaurar os sistemas e entender o que Bellatrix fez.",
	"Comandante: Então ainda temos uma chance..."
]

func _ready() -> void:
	interact_prompt.hide()
	block_message.show()
	DialogManager.dialog_finished.connect(_on_dialog_finished)
	DialogManager.line_finished_displaying.connect(_on_line_finished_displaying)
	DialogManager.line_started_displaying.connect(_on_line_started_displaying)

func _unhandled_input(event: InputEvent) -> void:
	
	if is_dialog_active:
		return
		
	if player_in_area and event.is_action_pressed("interact"):
		match GameState.fase_central_atual:
			1: 
				lines = central_1
			2:
				lines = central_2
			3:
				lines = central_3
			4:
				lines = central_4
			5:
				lines = central_5
		is_dialog_active = true 
		
		if not pc_on:
			pc_on = true
			anim.play("turning_on")
			audio.play()
			await anim.animation_finished
			
		anim.play("logs")
		interact_prompt.hide()
		
		DialogManager.start_dialog(global_position, lines)

func _on_dialog_finished() -> void:
	is_dialog_active = false
	anim.play("on")
	if not already_interacted:
		GameState.unlock_door(unlock_door)
		already_interacted = true
	
	if player_in_area:
		block_message.hide()
		interact_prompt.show()
	
	dialog_finished.emit()

func _on_line_finished_displaying() -> void:
	anim.pause()

func _on_line_started_displaying() -> void:
	anim.frame = 0
	anim.play("logs")
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		player_in_area = true
		
		if is_dialog_active:
			DialogManager.is_player_in_range = true
		else:
			block_message.hide()
			interact_prompt.show()
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false
		interact_prompt.hide()
		
		#if not is_dialog_active && not already_interacted:
		#	block_message.show()
			
		if is_dialog_active:
			DialogManager.is_player_in_range = false
			
		elif not already_interacted:
			block_message.show()
