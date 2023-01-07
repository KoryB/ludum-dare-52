extends Node2D


export var impulse_power := 10000.0
export var impulse_multiplier := 1.0
export var sweetspot_multiplier := 2.0

export var is_active := false
export var is_interruptable := false


var processed_bodies := []


func _ready():
    visible = false
    
    
func _physics_process(_delta: float):
    if is_active:
        var normal_bodies = $Anchor/Blade.get_overlapping_bodies()
        var sweetspot_bodies = $Anchor/SweetspotBlade.get_overlapping_bodies()
        
        for body in normal_bodies:
            try_hit_body(body, false)
            
        for body in sweetspot_bodies:
            try_hit_body(body, true)


func attack():
    processed_bodies = []
    $Anchor/AnimationPlayer.stop()
    $Anchor/AnimationPlayer.play("Attack")


func can_attack():
    return is_interruptable or !$Anchor/AnimationPlayer.is_playing()
    

func try_hit_body(body, is_sweetspot):
    if not processed_bodies.has(body):
        if is_sweetspot:
            print("Sweetspot!")
            
        body.apply_impulse(get_attack_power(is_sweetspot) * get_hit_direction(body))
        processed_bodies.append(body)
    

func get_hit_direction(body) -> Vector2:
    return (body.global_position - $Anchor.global_position).normalized()


func get_attack_power(is_sweetspot: bool) -> float:
    return impulse_power * impulse_multiplier * (sweetspot_multiplier if is_sweetspot else 1.0)