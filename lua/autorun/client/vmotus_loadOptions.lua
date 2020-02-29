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
                local cb_gender = panel:ComboBox("Voice Gender", "vmotus_vg")
                cb_gender:AddChoice("Male", "male01")
                cb_gender:AddChoice("Female", "female01")
            end
        )
    end
)
