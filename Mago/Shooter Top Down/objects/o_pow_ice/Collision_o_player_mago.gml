// Solo mejora el arma si el jugador ya la tiene desbloqueada
if (other.has_ice and other.powLevel_ice < 3)
{
	other.powLevel_ice += 1;
}
instance_destroy();
