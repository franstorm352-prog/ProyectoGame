// =============================================
// o_enemy_poison_woman  |  Step Event
// Se mueve hacia el jugador (lo hace o_enemy_body).
// Cuando puede, se detiene a apuntar y dispara veneno en Alarm[0].
// =============================================

event_inherited(); // muerte, slow, stun, movimiento y volteo

if (hp <= 0 or stun_timer > 0 or !instance_exists(o_player_mago)) exit;

// Lógica de ataque
if (state == "walk")
{
    if (shoot_timer > 0)
    {
        shoot_timer--;
    }
    else
    {
        if (point_distance(x, y, o_player_mago.x, o_player_mago.y) < 400)
        {
            state = "aim";
            sprite_index = att_sprite;
            alarm[0] = 60;
        }
    }
}
