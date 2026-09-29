// =============================================
// o_game_controller  |  Step Event
// Límite exterior dinámico: destruye enemigos que superen destroy_buffer.
// =============================================

// ──────────────────────────────────────────────────────────────────
// NOTA: Todas las distancias son RELATIVAS al borde de la cámara.
// destroy_buffer es píxeles más allá del viewport, NO del mapa.
// ──────────────────────────────────────────────────────────────────

// --- PASO 1: Obtener posición y dimensiones actuales de la cámara ---
// camera_get_view_* devuelve la posición de la esquina superior-izquierda
// del viewport en coordenadas del mapa (cambia cada frame con el jugador).
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);
var _buf   = destroy_buffer; // relativo al borde de cámara

// --- PASO 2: Calcular el rectángulo rojo de destrucción ---
// Estos límites se mueven con la cámara cada frame (siguen al jugador).
// Son DESPLAZAMIENTOS desde el borde del viewport, no posiciones fijas del mapa.
var _dl = _cam_x - _buf;          // Límite izquierdo  (cam_x - 220 px relativos)
var _dr = _cam_x + _cam_w + _buf; // Límite derecho    (cam_x + 960 + 220 px relativos)
var _dt = _cam_y - _buf;          // Límite superior   (cam_y - 220 px relativos)
var _db = _cam_y + _cam_h + _buf; // Límite inferior   (cam_y + 540 + 220 px relativos)

// --- PASO 3: Destruir enemigos fuera del límite exterior ---
with (o_enemy)
{
    // EL JEFE ES INMUNE A DESAPARECER POR ESTAR FUERA DE PANTALLA
    if (object_index == o_jefe) continue;

    if (x < _dl || x > _dr || y < _dt || y > _db)
    {
        instance_destroy(); // el Alarm[0] del controlador repone el faltante
    }
}

// Actualizar timer
timer_frames++;

// --- TRIGGER DEL JEFE (3 Minutos Exactos) ---
// 3 minutos = 180 segundos = 10800 frames (a 60 FPS)
if (timer_frames >= 10800 && !jefe_invocado) {
    jefe_invocado = true;
    
    // Matar a todos los enemigos actuales limpiamente
    with (o_enemy) {
        if (object_index != o_jefe) instance_destroy();
    }
    
    // Iniciar la cinemática (fix defensivo: obtener layer por ID en caso de que el nombre no resuelva)
    var _layer = layer_get_id("Instances");
    if (_layer == -1) _layer = layer_create(0, "Instances");
    instance_create_layer(0, 0, _layer, o_cinematica_jefe);
}

