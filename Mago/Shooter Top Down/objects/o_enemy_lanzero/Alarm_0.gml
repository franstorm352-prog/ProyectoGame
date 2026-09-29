// =============================================
// o_enemy_lanzero  |  Alarm[0] Event
// Dispara 2 flechas en forma de Y:
//   - Una flecha central apuntando al jugador
//   - Dos flechas laterales con ±25° de desviación
// Total: 2 disparos formando una horquilla (Y) cerca del jugador.
// =============================================

if (instance_exists(o_player_mago))
{
    var _dir_base = point_direction(x, y, o_player_mago.x, o_player_mago.y);

    // Flecha izquierda de la Y (-25°)
    var _shot1 = instance_create_layer(x, y - 8, "Instances", o_shot_lanzero);
    _shot1.direction = _dir_base - 25;

    // Flecha derecha de la Y (+25°)
    var _shot2 = instance_create_layer(x, y - 8, "Instances", o_shot_lanzero);
    _shot2.direction = _dir_base + 25;
}

// Volver al estado de caminar y recargar
state       = "walk";
sprite_index = walk_sprite;
image_speed = 1;
shoot_timer = shoot_cooldown;
