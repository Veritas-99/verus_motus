require("helper/IntToBool")

function vmotus_rfd()
    return IntToBool(GetConVar("vmotus_rfd"):GetInt())
end

function vmotus_rfdNum()
    return GetConVar("vmotus_rfdNum"):GetFloat()
end

function vmotus_rdr()
    return IntToBool(GetConVar("vmotus_rdr"):GetInt())
end

function vmotus_scream()
    return IntToBool(GetConVar("vmotus_scream"):GetInt())
end

if SERVER then
    local player_gender = {}

    util.AddNetworkString("vmotus_vg")

    net.Receive(
        "vmotus_vg",
        function(len, ply)
            player_gender[ply] = net.ReadString()
        end
    )

    hook.Add(
        "PlayerDisconnected",
        "vmotus_pd",
        function(ply)
            player_gender[ply] = nil
        end
    )

    function vmotus_vg(ply)
        return player_gender[ply]
    end
end
