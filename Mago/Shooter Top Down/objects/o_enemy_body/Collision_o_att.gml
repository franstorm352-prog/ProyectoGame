hp -= other.dmg;

if (other.slow_amount > 0)
{
	enemy_speed = base_speed * other.slow_amount;
	slow_timer = other.slow_duration;
}

if (other.lifesteal > 0)
{
	o_player_mago.hp = min(o_player_mago.hp + other.lifesteal, 100);
}

if (other.stun_chance > 0 and random(100) < other.stun_chance)
{
	stun_timer = other.stun_duration;
}

with (other) instance_destroy();
