// =============================================
// o_shot_jefe_basico  |  Collision con o_player_mago
// =============================================

if (o_player_mago.hit_timer <= 0)
{
    o_player_mago.hp -= dmg;
    o_player_mago.hit_timer = o_player_mago.iframe_duration;

    if (o_player_mago.hp <= 0)
    {
        ir_a_resultado(false);
    }
}

instance_destroy();
