// =============================================
// o_shot_lanzero  |  Step Event
// Rota el sprite en la dirección de vuelo.
// Se destruye al salir del room.
// =============================================

// Rotar el sprite en la dirección de vuelo
image_angle = direction;

// Destruir al salir del room
if (x < -32 || x > room_width + 32 || y < -32 || y > room_height + 32)
{
    instance_destroy();
}
