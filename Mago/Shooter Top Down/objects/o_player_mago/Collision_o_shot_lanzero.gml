// =============================================
// o_player_mago  |  Collision con o_shot_lanzero
// La flecha del lanzero daña al jugador (12 HP).
// Mismo sistema de iframes que Collision_o_shot_enemy_snake.
// =============================================

if (hit_timer <= 0)
{
    hp -= other.dmg;
    hit_timer = iframe_duration;

    if (hp <= 0)
    {
        ir_a_resultado(false);
    }
}

with (other) instance_destroy();
