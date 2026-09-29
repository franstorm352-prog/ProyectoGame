// =============================================
// o_dano_area_venom  |  Step Event
// Aplica 1 HP de daño al jugador cada tick_interval frames
// si está dentro del área de colisión, hasta max_damage_total.
// Se destruye cuando se agota lifetime o se alcanza el tope de daño.
// =============================================

// Contar tiempo de vida
lifetime--;
if (lifetime <= 0)
{
    instance_destroy();
    exit;
}

// Fade suave hacia el final de la vida
if (lifetime < 60)
{
    image_alpha = 0.7 * (lifetime / 60);
}

// Si ya hizo el máximo de daño posible, solo esperar a morir
if (damage_dealt >= max_damage_total) exit;

if (!instance_exists(o_player_mago)) exit;

// Verificar si el jugador está sobre el charco
if (place_meeting(x, y, o_player_mago))
{
    // Si el cooldown del charco está listo
    if (tick_timer <= 0)
    {
        // Solo dañar si el jugador no está en iframes
        if (o_player_mago.hit_timer <= 0)
        {
            o_player_mago.hp -= dmg_per_tick;
            damage_dealt     += dmg_per_tick;

            // Activar iframes breves para el jugador
            o_player_mago.hit_timer = 20;

            if (o_player_mago.hp <= 0)
            {
                ir_a_resultado(false);
            }
        }
        
        // Reiniciar el cooldown de este charco independientemente de si hizo daño o no,
        // para evitar que se acumulen charcos "esperando" a que el jugador termine sus iframes.
        tick_timer = tick_interval;
    }
    else
    {
        // Si el charco está en cooldown, descontar el tiempo
        tick_timer--;
    }
}
else
{
    // Si el jugador no lo está pisando, preparar el charco para que 
    // su primer golpe sea instantáneo cuando lo pise
    tick_timer = 0;
}
