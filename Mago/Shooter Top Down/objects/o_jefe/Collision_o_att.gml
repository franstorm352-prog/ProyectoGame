// =============================================
// o_jefe  |  Collision con o_att (proyectiles del jugador)
// Sobreescribe o_enemy_body: inmunidad por orbes, interrupción de carga, núcleo expuesto
// =============================================

// Ignorar si ya está muriendo
if (estado_muerto) {
    with (other) instance_destroy();
    exit;
}

// ── INMUNIDAD: Mientras haya orbes activos, el jefe no recibe daño ──
if (orbes_activos > 0) {
    with (other) instance_destroy();
    exit;
}

// ── INTERRUPCIÓN DE CARGA: Hielo durante la carga la cancela ────────
if (other.es_hielo && cargando) {
    cargando       = false;
    carga_timer    = 0;
    carga_cooldown = 0;
    enemy_speed    = base_speed;
    image_blend    = c_white;
    nucleo_expuesto = true;
    nucleo_timer    = 180; // 3 segundos de núcleo expuesto
    stun_timer      = 180; // El jefe queda aturdido visual y mecánicamente durante este tiempo
}

// ── DAÑO CON MULTIPLICADOR DE NÚCLEO ────────────────────────────────
var _dmg = other.dmg;
if (nucleo_expuesto) {
    if (other.es_sangre) _dmg = _dmg * 3; // Sangre hace x3 en núcleo
    else                 _dmg = _dmg * 2; // Resto hace x2 en núcleo
}
hp -= _dmg;

// ── EFECTOS SECUNDARIOS DEL PROYECTIL ───────────────────────────────
if (other.slow_amount > 0) {
    enemy_speed = base_speed * other.slow_amount;
    slow_timer  = other.slow_duration;
}
if (other.lifesteal > 0) {
    o_player_mago.hp = min(o_player_mago.hp + other.lifesteal, 100);
}

// El jefe es inmune al aturdimiento aleatorio normal, solo se aturde al interrumpir su carga.


with (other) instance_destroy();
