--; ============================================================
--; Lua Skins
--; ============================================================

insertSkin = {
	["Typeface"] = {
		skinInsert = "ExecuteBatch 1"
	},
	["Color Code"] = {
		skinInsert = "ExecuteBatch 1"
	}
}

function setTypeface(selectedTypeface)
	SKIN:Bang('!CommandMeasure MeterSkinInputTypeface "' .. insertSkin[selectedTypeface]['skinInsert'] .. '"')

end

function setColor(selectedColor)
	SKIN:Bang('!CommandMeasure MeterSkinInputColor "' .. insertSkin[selectedColor]['skinInsert'] .. '"')

end

function setSkinApply()
	SKIN:Bang('!RefreshGroup Suite')

end
