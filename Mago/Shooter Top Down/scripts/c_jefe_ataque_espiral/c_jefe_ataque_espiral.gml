
function c_jefe_ataque_espiral()
{
    // Inicia una secuencia de 3 oleadas espirales rotativas manejadas en el Step del jefe
    if (instance_exists(o_jefe)) {
        o_jefe.espiral_bursts = 3;
        o_jefe.espiral_timer  = 1; // Dispara la primera oleada inmediatamente
    }
}
