include("v_motus_cvars.lua")

if SERVER then
	hook.Add("PlayerButtonDown", "v_motus_pbd", function(ply, btn)
		if btn == v_motus_key(ply) then
			ply.v_motus = true
		end
	end)

	hook.Add("PlayerButtonUp", "v_motus_pbu", function(ply, btn)
		if btn == v_motus_key(ply) then
			ply.v_motus = false
		end
	end)
end