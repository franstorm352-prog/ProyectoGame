// =============================================
// o_orbe_escudo  |  Step Event
// =============================================

// Si el jefe murió, destruirse
if (!instance_exists(o_jefe)) {
    instance_destroy();
    exit;
}

// Orbitar alrededor del jefe
var _angulo_base = (orbita_idx / orbita_total) * 360;
var _angulo      = _angulo_base + (current_time * 0.06); // rotación continua
x = o_jefe.x + lengthdir_x(orbita_radio, _angulo);
y = o_jefe.y + lengthdir_y(orbita_radio, _angulo);
