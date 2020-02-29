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
                panel:AddControl( "Header", { Description = "Falling\n" }  )
                panel:CheckBox("Realistic Fall Damage", "vmotus_rfd")
                panel:NumSlider("Fall Damage Divider", "vmotus_rfdNum", 0, 25, 1)
                panel:CheckBox("Rolling", "vmotus_rdr")
                panel:CheckBox("Screaming", "vmotus_scream")
                local cb_gender = panel:ComboBox("Voice Gender", "vmotus_vg")
                cb_gender:AddChoice("Male", "male01")
                cb_gender:AddChoice("Female", "female01")
                panel:AddControl( "Header", { Description = "\nWall Running\n" }  )
                panel:NumSlider("Wall Run Steps", "vmotus_wrs", 0, 20, 0)
                panel:NumSlider("Wall Run Step Force", "vmotus_wrsf", 0, 500, 0)
                panel:NumSlider("Wall Jump Step Refresh", "vmotus_wjs", 0, 20, 0)
            end
        )
    end
)
