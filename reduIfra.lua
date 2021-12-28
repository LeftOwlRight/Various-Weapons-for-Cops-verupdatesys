if StreamHeist then
	return
end

function PlayerDamage:_chk_dmg_too_soon(damage, ...)
	local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
	local t = managers.player:player_timer():time()
	if damage <= self._last_received_dmg + 0.01 and next_allowed_dmg_t > t then
		self._old_last_received_dmg = nil
		self._old_next_allowed_dmg_t = nil
		return true
	end
	if next_allowed_dmg_t > t then
		self._old_last_received_dmg = self._last_received_dmg
		self._old_next_allowed_dmg_t = next_allowed_dmg_t
	end
end

local _calc_armor_damage_original = PlayerDamage._calc_armor_damage
function PlayerDamage:_calc_armor_damage(attack_data, ...)
	if VariousWeaponForCops and VariousWeaponForCops.settings.Reduce_Iframe then
	attack_data.damage = attack_data.damage - (self._old_last_received_dmg or 0)
	self._next_allowed_dmg_t = self._old_next_allowed_dmg_t and Application:digest_value(self._old_next_allowed_dmg_t, true) or self._next_allowed_dmg_t
	self._old_last_received_dmg = nil
	self._old_next_allowed_dmg_t = nil
    end
    return _calc_armor_damage_original(self, attack_data, ...)
end

local _calc_health_damage_original = PlayerDamage._calc_health_damage
function PlayerDamage:_calc_health_damage(attack_data, ...)
	if VariousWeaponForCops and VariousWeaponForCops.settings.Reduce_Iframe then
	attack_data.damage = attack_data.damage - (self._old_last_received_dmg or 0)
	self._next_allowed_dmg_t = self._old_next_allowed_dmg_t and Application:digest_value(self._old_next_allowed_dmg_t, true) or self._next_allowed_dmg_t
	self._old_last_received_dmg = nil
	self._old_next_allowed_dmg_t = nil
    end
    return _calc_health_damage_original(self, attack_data, ...)
end