class_name Math

static func random_unit_vector() -> Vector2:
    var angle = rand_range(0, 2 * PI)
    
    return Vector2(cos(angle), -sin(angle))
    
    
static func random_vector_polar(min_radius: float, max_radius: float):
    var dir = random_unit_vector()
    
    return dir * rand_range(min_radius, max_radius)


static func Vector2f(value: float):
    return Vector2(value, value)
