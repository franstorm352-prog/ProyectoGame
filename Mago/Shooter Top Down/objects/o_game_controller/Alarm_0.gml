// =============================================
// o_game_controller  |  Alarm[0] Event
// Repone enemigos hasta alcanzar spawn_max_enemies.
// =============================================

// ──────────────────────────────────────────────────────────────────
// NOTA: Las posiciones de spawn son RELATIVAS al borde de la cámara.
// NO son coordenadas absolutas del mapa 4096×4096.
// Los spawners se distribuyen en la franja entre spawn_inner y spawn_outer
// px fuera del viewport (zona verde de la imagen de referencia).
//
// Franja de spawn relativa al viewport 960×540:
//   spawn_inner = 30  px → mínimo más allá del borde azul (cámara)
//   spawn_outer = 180 px → máximo más allá del borde azul, dentro del rojo
//
// Los círculos amarillos de la imagen representan POSIBLES puntos de spawn,
// no posiciones fijas: cada ciclo se elige un lado al azar y una posición
// aleatoria a lo largo de ese borde.
// ──────────────────────────────────────────────────────────────────

// Seguridad: no spawnear si el jugador no existe
if (!instance_exists(o_player_mago))
{
    alarm[0] = spawn_interval;
    exit;
}

// Si el jefe ya fue invocado, detener completamente el spawn de enemigos básicos
if (o_game_controller.jefe_invocado) {
    exit;
}

// --- PASO 1: Obtener posición y tamaño actuales de la cámara ---
// Estas variables se actualizan cada Alarm, no son fijas.
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);

// --- PASO 2: Calcular cuántos enemigos faltan ---
var _actuales = instance_number(o_enemy_body);
var _faltan   = spawn_max_enemies - _actuales;

// --- PASO 3: Spawnear los enemigos faltantes ---
// Cada iteración elige uno de los 4 lados de la cámara al azar
// y un desplazamiento aleatorio dentro de la franja [spawn_inner, spawn_outer].
repeat (_faltan)
{
    // Elegir lado: 0=arriba  1=derecha  2=abajo  3=izquierda
    var _lado   = irandom(3);

    // Desplazamiento aleatorio dentro de la franja de spawn
    // (relativo al borde de la cámara, no al mapa)
    var _offset = spawn_inner + irandom(spawn_outer - spawn_inner);

    var _sx, _sy; // coordenadas de spawn (absolutas en el mapa, calculadas dinámicamente)

    switch (_lado)
    {
        case 0: // ── Borde SUPERIOR de la cámara ──────────────────────────────
            // X: posición aleatoria a lo largo del ancho del viewport
            //    → spawn_inner..spawn_outer px POR ENCIMA del borde azul
            _sx = _cam_x + irandom(_cam_w);
            _sy = _cam_y - _offset;   // _offset px encima del borde superior de cámara
        break;

        case 1: // ── Borde DERECHO de la cámara ───────────────────────────────
            // _offset px a la DERECHA del borde derecho del viewport
            _sx = _cam_x + _cam_w + _offset;
            _sy = _cam_y + irandom(_cam_h);
        break;

        case 2: // ── Borde INFERIOR de la cámara ──────────────────────────────
            // _offset px POR DEBAJO del borde inferior del viewport
            _sx = _cam_x + irandom(_cam_w);
            _sy = _cam_y + _cam_h + _offset;
        break;

        case 3: // ── Borde IZQUIERDO de la cámara ─────────────────────────────
            // _offset px a la IZQUIERDA del borde izquierdo del viewport
            _sx = _cam_x - _offset;
            _sy = _cam_y + irandom(_cam_h);
        break;
    }

    // Clampear al interior del room para no spawnear fuera del mapa 4096×4096
    _sx = clamp(_sx, 16, room_width  - 16);
    _sy = clamp(_sy, 16, room_height - 16);

    // --- PASO 4: Elegir tipo y crear el enemigo ---
    // Empieza siendo basic. Cada tipo tira su propio dado con su probabilidad (%)
    // y, si le sale, reemplaza al anterior (el último que sale es el que gana).
    tipo = o_enemy_basic;
    if (random(100) < heavy_chance)    tipo = o_enemy_heavy;
    if (random(100) < poison_chance)   tipo = o_enemy_poison_woman;
    if (random(100) < kamikaze_chance) tipo = o_enemy_chulupi_kamikaze;
    if (random(100) < lanzero_chance)  tipo = o_enemy_lanzero;
    if (random(100) < venom_chance)    tipo = o_enemy_venom;

    instance_create_layer(_sx, _sy, "Instances", tipo);
}

// --- Progresión de dificultad ---
// Cascada: heavy → poison → kamikaze → lanzero → venom
if (heavy_chance < heavy_chance_max)
{
    heavy_chance += heavy_chance_step;
}
else if (poison_chance < poison_chance_max)
{
    poison_chance += poison_chance_step;
}
else if (kamikaze_chance < kamikaze_chance_max)
{
    kamikaze_chance += kamikaze_chance_step;
}
else if (lanzero_chance < lanzero_chance_max)
{
    lanzero_chance += lanzero_chance_step;
}
else if (venom_chance < venom_chance_max)
{
    venom_chance += venom_chance_step;
}

// --- Reprogramar el próximo ciclo de revisión ---
alarm[0] = spawn_interval;
