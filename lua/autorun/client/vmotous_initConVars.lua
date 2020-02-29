CreateClientConVar("vmotus_vg", "male01")
cvars.AddChangeCallback(
    "vmotus_vg",
    function(cvar)
        sendString(cvar)
    end
)

function sendString(var)
    net.Start(var)
    net.WriteString(GetConVar(var):GetString())
    net.SendToServer()
end

timer.Simple(
    3,
    function()
        sendString("vmotus_vg")
    end
)