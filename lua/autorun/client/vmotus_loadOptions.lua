hook.Add(
    "AddToolMenuCategories",
    "AddToolMenuCategories",
    function()
        spawnmenu.AddToolCategory("Options", "VerusMotus", "#VerusMotus")
    end
)

hook.Add(
    "PopulateToolMenu",
    "PopulateToolMenu",
    function()
        spawnmenu.AddToolMenuOption(
            "Options",
            "VerusMotus",
            "Verus_Motus",
            "#VerusMotus",
            "",
            "",
            function(panel)
                panel:ClearControls()
                panel:CheckBox("Realistic Fall Damage", "vmotus_rfd")
                panel:NumSlider("Fall Damage Divider", "vmotus_rfdNum", 0, 25, 1)
                panel:CheckBox("Rolling", "vmotus_rdr")
            end
        )
    end
)
