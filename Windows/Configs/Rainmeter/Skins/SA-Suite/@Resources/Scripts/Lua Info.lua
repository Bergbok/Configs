--; ============================================================
--; Lua Info
--; ============================================================

infoSelect = {
	["Author"] = {
		infoLink = "https://www.deviantart.com/akiyama4809"
	},
	["Creative Commons"] = {
		infoLink = "https://creativecommons.org/licenses/by-nc-sa/4.0"
	},
	["Credit1"] = {
		infoLink = "https://fonts.google.com/specimen/Merienda"
	},
	["Credit2"] = {
		infoLink = "https://www.behance.net/gallery/37133365/TT-Squares-Condensed"
	},
	["Credit3"] = {
		infoLink = "https://fonts.google.com/specimen/Roboto"
	},
	["Credit4"] = {
		infoLink = "https://www.lua.org/"
	},
	["Credit5"] = {
		infoLink = "https://github.com/khanhas/spicetify-cli"
	},
	["Credit6"] = {
		infoLink = "https://github.com/tjhrulz/WebNowPlaying"
	},
	["Credit7"] = {
		infoLink = "https://github.com/orgs/rainmeter/people"
	}
}

function setInfo(selectedInfo)
	SKIN:Bang('' .. infoSelect[selectedInfo]['infoLink'] .. '')

end --ends setInfo
