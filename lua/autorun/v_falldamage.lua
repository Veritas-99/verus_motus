include("cvars.lua")

if SERVER then
	hook.Add("PlayerPostThink", "v_motus_ppt_falldamage", function(ply)
		if v_motus_falldamage(ply) then
			local tr = util.QuickTrace(ply:GetPos(), Vector(0, 0, -10000), ply)
			local newRelativeSpeed = ply:GetVelocity().z - tr.Entity:GetVelocity().z
			ply.v_motus_relativeSpeed = newRelativeSpeed != 0 && newRelativeSpeed || relativeSpeed
		end
	end)

	hook.Add("GetFallDamage", "v_motus_gfd", function(ply, speed)
		if speed > 530 then
			if v_motus_falldamage(ply) then
				local fallDamage = (-1 * ply.v_motus_relativeSpeed / v_motus_falldamagedivider(ply))

				if ply.v_motus_roll then
					if speed > 900 then
						return fallDamage * 0.85
					elseif speed > 800 then
						return fallDamage * 0.8
					elseif speed > 700 then
						return fallDamage * 0.5
					elseif speed > 650 then
						return fallDamage * 0.25
					else
						return 0
					end
				else
					return fallDamage
				end
			else
				if ply.v_motus_roll then
					if speed > 900 then
						return 10 * 0.85
					elseif speed > 800 then
						return 10 * 0.8
					elseif speed > 700 then
						return 10 * 0.5
					elseif speed > 650 then
						return 10 * 0.25
					else
						return 0
					end
				else
					return 10
				end
			end
		end
	end)
end