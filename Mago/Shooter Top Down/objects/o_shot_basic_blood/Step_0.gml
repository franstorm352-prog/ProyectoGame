// Rota el sprite para apuntar en la dirección de vuelo
image_angle = direction - 90;

// Se destruye al salir del room
if (x < -32 || x > room_width + 32 || y < -32 || y > room_height + 32)
{
	instance_destroy();
}