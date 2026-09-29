// Si el jugador ya tiene esta runa al máximo, el drop no sirve → desaparecer
if (instance_exists(o_player_mago)) {
    if (o_player_mago.has_rocks and o_player_mago.powLevel_rocks >= 3) {
        instance_destroy();
    }
}
