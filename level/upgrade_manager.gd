extends Node


var is_first_frame := true
var game_manager: GameManager

var scythe_size_prices := [1, 5, 10, 20, 50, 1000]
var scythe_power_prices := [1, 5, 10, 20, 50, 1000]
var move_speed_prices := [10, 20, 50, 100, 1000]

var scythe_size := 0
var scythe_power := 0
var move_speed := 0

var increase_multiplier := 1.2


func _physics_process(delta: float):
    if is_first_frame:
        is_first_frame = false        
        game_manager = get_node("/root/TestLevel/GameManager")
        update_ui()
    
    $CanvasLayer.visible = PauseManager.is_paused


func update_ui():
    $CanvasLayer/Shop/Title/Shop/ScytheSizeButton/Label.text = str(scythe_size_prices[scythe_size])
    $CanvasLayer/Shop/Title/Shop/ScythePowerButton/Label.text = str(scythe_power_prices[scythe_power])
    $CanvasLayer/Shop/Title/Shop/MoveSpeedButton/Label.text = str(move_speed_prices[move_speed])
    
    game_manager.update_berry_label()


func _on_ScytheSizeButton_pressed():
    var cost = scythe_size_prices[scythe_size]
    
    if game_manager.current_berries >= cost:
        game_manager.current_berries -= cost
        scythe_size += 1
        game_manager.player.get_node("ScythePosition").scale *= increase_multiplier
        
    update_ui()


func _on_ScythePowerButton_pressed():
    var cost = scythe_power_prices[scythe_power]
    
    if game_manager.current_berries >= cost:
        game_manager.current_berries -= cost
        scythe_power += 1
        game_manager.player.get_node("ScythePosition/Scythe1").impulse_power *= increase_multiplier
        
    update_ui()


func _on_MoveSpeedButton_pressed():
    var cost = move_speed_prices[move_speed]
    
    if game_manager.current_berries >= cost:
        game_manager.current_berries -= cost
        move_speed += 1
        game_manager.player.move_speed *= increase_multiplier
        game_manager.player.dash_speed *= increase_multiplier
        
    update_ui()
