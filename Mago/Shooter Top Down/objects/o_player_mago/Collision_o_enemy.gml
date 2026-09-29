// Solo recibir daño si no estamos en iframes
if (hit_timer <= 0)
{
    if (other.object_index == o_enemy_chulupi_kamikaze and other.state != "explode")
    {
        // El kamikaze explota al tocarlo: daño masivo, se autodestruye con su propia animación
        other.state = "explode";
        other.sprite_index = s_explode_kamikaze;
        other.image_index = 0;

        hp -= 30;
        hit_timer = iframe_duration;

        if (hp <= 0)
        {
            ir_a_resultado(false);
        }
    }
    else
    {
        hp -= 10;
        hit_timer = iframe_duration; 

        if (hp <= 0)
        {
            ir_a_resultado(false);
        }
    }
}