// =============================================
// o_ruleta  |  Step Event
// =============================================

if (estado == "girando")
{
    cambio_timer--;
    if (cambio_timer <= 0)
    {
        // Pasar a la runa siguiente (si se pasa de la última, vuelve a la primera)
        indice++;
        if (indice >= n_runas) indice = 0;

        if (cambio_t < cambio_max)
        {
            // Todavía girando: el próximo cambio tarda un poco más
            cambio_t++;
        }
        else if (indice == runa_ganador_idx)
        {
            // Ya está lento y cayó en la runa ganadora: se detiene
            estado = "parado";
        }

        cambio_timer = cambio_t;
    }
}
else if (estado == "parado")
{
    if (!reward_applied)
    {
        stop_timer--;
        if (stop_timer <= 0)
        {
            reward_applied = true;

            // --- Aplicar la runa ganadora ---
            var _tipo = runas_tipo[runa_ganador_idx];
            var _ctrl = o_game_controller;

            if (_tipo == "rocks") {
                o_player_mago.has_rocks = true;
                _ctrl.runas_dadas[0]    = true;
                runa_nombre_ganada      = "ROCAS";
            } else if (_tipo == "blood") {
                o_player_mago.has_blood = true;
                _ctrl.runas_dadas[1]    = true;
                runa_nombre_ganada      = "SANGRE";
            } else if (_tipo == "ice") {
                o_player_mago.has_ice   = true;
                _ctrl.runas_dadas[2]    = true;
                runa_nombre_ganada      = "HIELO";
            }

            _ctrl.cofre_activo_idx++;

            if (_ctrl.cofre_activo_idx >= 3) {
                _ctrl.cofres_completados = true;
                if (instance_exists(o_flecha_cofre))
                    with (o_flecha_cofre) instance_destroy();
            }
        }
    }
    else
    {
        stop_timer--;
        if (stop_timer <= -90)
            instance_destroy();
    }
}
