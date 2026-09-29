// =============================================
// o_enemy_lanzero  |  Step Event
// Camina hacia el jugador (lo hace o_enemy_body) hasta entrar en attack_range,
// entonces se queda quieto y espera el Alarm[0] para disparar.
// =============================================

event_inherited(); // muerte, slow, stun, movimiento (solo en "walk") y volteo

if (hp <= 0 or stun_timer > 0 or !instance_exists(o_player_mago)) exit;

if (state == "walk")
{
    // Bajar el cooldown del disparo
    if (shoot_timer > 0)
    {
        shoot_timer--;
    }
    else if (point_distance(x, y, o_player_mago.x, o_player_mago.y) < attack_range)
    {
        // Ya recargó y está cerca: se detiene y avisa que va a disparar
        state = "aim";
        sprite_index = att_sprite;
        image_index = 0;
        image_speed = 1;
        alarm[0] = 60; // se queda quieto 1 segundo antes de disparar
    }
}
else if (state == "aim")
{
    // Pausa en el último frame para que se vea la pose de ataque
    if (image_index >= image_number - 1)
    {
        image_speed = 0;
        image_index = image_number - 1;
    }
}
