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
