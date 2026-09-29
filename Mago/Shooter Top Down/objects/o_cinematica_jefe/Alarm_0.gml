// =============================================
// o_cinematica_jefe  |  Alarm_0 Event
// =============================================

// Termina el temblor y spawnea al jefe
if (instance_exists(o_player_mago)) {
    var _cam = view_camera[0];
    
    // Restaurar cámara suavemente (evitar que quede chueca)
    var _cam_w_half = camera_get_view_width(_cam) / 2;
    var _cam_h_half = camera_get_view_height(_cam) / 2;
    var _base_x = clamp(o_player_mago.x - _cam_w_half, 0, room_width - camera_get_view_width(_cam));
    var _base_y = clamp(o_player_mago.y - _cam_h_half, 0, room_height - camera_get_view_height(_cam));
    camera_set_view_pos(_cam, _base_x, _base_y);
    
    // Calcular punto de aparición: lado derecho de la pantalla, centrado verticalmente.
    // El jefe siempre entra por el lado derecho de la cámara.
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    
    var _spawn_x = _cam_x + _cam_w * 0.80; // 80% del ancho (lado derecho)
    var _spawn_y = _cam_y + _cam_h * 0.50;  // Centro vertical
    
    // Clampear al mapa por si estamos en un borde
    _spawn_x = clamp(_spawn_x, 64, room_width - 64);
    _spawn_y = clamp(_spawn_y, 64, room_height - 64);
    
    // Asegurarse de que el jugador tenga todas las runas en al menos nivel 1 para la pelea
    if (!o_player_mago.has_rocks) { o_player_mago.has_rocks = true; o_player_mago.powLevel_rocks = 1; }
    if (!o_player_mago.has_blood) { o_player_mago.has_blood = true; o_player_mago.powLevel_blood = 1; }
    if (!o_player_mago.has_ice)   { o_player_mago.has_ice   = true; o_player_mago.powLevel_ice   = 1; }

    instance_create_layer(_spawn_x, _spawn_y, "Instances", o_jefe);
}

instance_destroy();
