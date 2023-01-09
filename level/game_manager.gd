class_name GameManager extends Node

var BugScene: PackedScene = preload("res://character/bug/bug.tscn")

export var bush_path: NodePath
export var arena_path: NodePath
export var player_path: NodePath

export var guts_multiplier := 100.0

var berries_harvested := 0
var current_berries := 0

var arena: Arena
var bush: Bush
var player: Player

func _ready():
    bush = get_node(bush_path)
    arena = get_node(arena_path)
    player = get_node(player_path)
    
    var _on_berry = bush.connect("berry_created", self, "on_berry_created")
    var _on_bug_killed = arena.connect("bug_killed", self, "on_bug_killed")
    
    var _on_hit = player.connect("hit", self, "on_player_hit")
    var _on_attack = player.connect("attack", self, "on_player_attack")
    
    update_berry_label()
    update_health_label()
    
    $BackgroundMusic.play()
    
    
func _physics_process(delta):
    if randf() < 0.003:
        spawn_bug()
    
    
func on_berry_created(berry: Berry):
    var _harvested = berry.connect("harvested", self, "on_berry_harvested")
    var _eaten = berry.connect("eaten", self, "on_berry_eaten")
    
    
func on_berry_harvested(berry: Berry):
    berries_harvested += 1
    current_berries += 1
    $BerryPickupAudio.play()
    
    update_berry_label()
    
    
func on_berry_eaten(berry: Berry, bug: Bug):
    print("Berry eaten!")
    

func on_bug_killed(bug: Bug):
    var should_play_sound = randf() < 0.25
    bush.grow(guts_multiplier / bug.inv_mass)
    
    if should_play_sound:
        stop_player_attack_sounds()
        
    var audios = $AudioPlayersOnKill.get_children()
    var audio = audios[randi() % audios.size()]
    
    if no_player_sound_effects_playing():
        audio.play()
    
    
func on_player_hit(_bugs: Array):
    update_health_label()
        
    var audios = $AudioPlayersOnHit.get_children()
    var audio = audios[randi() % audios.size()]
    
    if no_player_sound_effects_playing():
        audio.play()
        

func on_player_attack():
    var audios = $AudioPlayersOnAttack.get_children()
    var audio = audios[randi() % audios.size()]
    
    if no_player_sound_effects_playing():
        audio.play()
        
        
func on_bug_hit():
    $BugHitAudio.play()
    

func spawn_bug():
    var pos = Math.random_unit_vector() * arena.radius
    var size = rand_range(0.5, 2.0)
    var color = Math.random_color(0.5, 1.0)
    
    var bug = BugScene.instance()
    bug.position = pos + arena.global_position
    bug.scale = Math.Vector2f(size)
    bug.modulate = color
    bug.inv_mass /= sqrt(size)
    
    var _on_hit = bug.connect("hit", self, "on_bug_hit")
    
    get_parent().add_child(bug)


func update_berry_label():
    $HUD/BerryLabel.text = str(current_berries)
    

func update_health_label():
    $HUD/HealthLabel.text = "%s/%s" % [player.health, player.max_health]
    

func stop_player_attack_sounds():
    for audio in $AudioPlayersOnAttack.get_children():
        audio.stop()
    

func no_player_sound_effects_playing() -> bool:        
    for audio in $AudioPlayersOnHit.get_children():
        if audio.playing:
            return false
            
    for audio in $AudioPlayersOnKill.get_children():
        if audio.playing:
            return false    
              
    for audio in $AudioPlayersOnAttack.get_children():
        if audio.playing:
            return false
            
    return true
