// =============================================
// o_enemy_venom  |  Step Event
// Se mueve hacia el jugador lentamente (lo hace o_enemy_body).
// Cada summon_cooldown frames invoca charcos de veneno
// en posiciones aleatorias dentro del viewport actual.
// =============================================

event_inherited(); // muerte, slow, stun, movimiento y volteo

if (hp <= 0 or stun_timer > 0 or !instance_exists(o_player_mago)) exit;

// ---- Temporizador de invocación de veneno ----
if (summon_timer > 0)
{
    summon_timer--;
}
else
{
    // Obtener posición y dimensiones actuales de la cámara
    var _cam_x = camera_get_view_x(view_camera[0]);
    var _cam_y = camera_get_view_y(view_camera[0]);
    var _cam_w = camera_get_view_width(view_camera[0]);
    var _cam_h = camera_get_view_height(view_camera[0]);

    // Margen interior: no invocar en el borde exacto de pantalla
    var _margin = 48;

    // Invocar 3 charcos en posiciones aleatorias DENTRO del viewport
    var _num_charcos = 3;
    repeat (_num_charcos)
    {
        var _px = _cam_x + _margin + irandom(_cam_w - _margin * 2);
        var _py = _cam_y + _margin + irandom(_cam_h - _margin * 2);
        instance_create_layer(_px, _py, "Instances", o_dano_area_venom);
    }

    summon_timer = summon_cooldown;
}
