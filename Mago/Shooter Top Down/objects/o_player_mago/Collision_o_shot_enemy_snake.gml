
if (hit_timer <= 0)
{
    hp -= 10;
    hit_timer = iframe_duration; 

    if (hp <= 0)
    {
        ir_a_resultado(false);
    }
}

with (other) instance_destroy();
