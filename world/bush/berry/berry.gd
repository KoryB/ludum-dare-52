class_name Berry extends Area2D


export var ripen_time := 5.0
export var max_health := 10.0

const MaxArea := PI * 16.0 * 16.0

onready var health := max_health

var ripen_timer = 0.0


var is_dead := false
    

func _physics_process(delta: float):
    ripen_timer += delta

    if is_dead:
        on_die()


# Returns if the berry is dead after the damage
func damage(amount: float) -> bool:
    max_health -= amount
    if max_health < 0:
        is_dead = true
        
    return is_dead
    

func on_die():
    queue_free()


func is_ripe() -> bool:
    return ripen_timer >= ripen_time
