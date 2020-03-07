//ConVar accessibility
v_motus_serverside = "v_motus_serverside"

function serverside()
	return cvarGetBool(v_motus_serverside)
end

v_motus_steps_l = "v_motus_steps_l"
v_motus_steps_g = "v_motus_steps_g"

function v_motus_steps(ply)
	if serverside() then
		return cvarGetInt(v_motus_steps_g)
	else
		return cvarGetInt(v_motus_steps_l, ply)
	end
end

v_motus_step_force_l = "v_motus_step_force_l"
v_motus_step_force_g = "v_motus_step_force_g"

function v_motus_step_force(ply)
	if serverside() then
		return cvarGetInt(v_motus_step_force_g)
	else
		return cvarGetInt(v_motus_step_force_l, ply)
	end
end

//ConCommands & ConVars
concommand.Add("+v_motus", function(ply)
	ply.v_motus = true
end)

concommand.Add("-v_motus", function(ply)
	ply.v_motus = false
end)

CreateConVar(v_motus_serverside, "1")
//
CreateClientConVar(v_motus_steps_l, "3", true, true)
CreateConVar(v_motus_steps_g, "3")
//
CreateClientConVar(v_motus_step_force_l, "275", true, true)
CreateConVar(v_motus_step_force_g, "275")

//ConVar utilities
function cvarGetBool(var, ply)
	if ply != nil then
		local val = ply:GetInfoNum(var, -1)

		if val == 1 then
			return true
		elseif val == 0 then
			return false
		else
			return nil
		end
	else
		if ConVarExists(var) then
			return GetConVar(var):GetBool()
		else
			return nil
		end
	end
end

function cvarGetInt(var, ply)
	if ply != nil then
		local val = ply:GetInfoNum(var, -1)

		return val
	else
		if ConVarExists(var) then
			return GetConVar(var):GetInt()
		else
			return nil
		end
	end
end