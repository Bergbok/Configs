--; ============================================================
--; Lua Language
--; ============================================================

langSelect = {
	["English (US)"] = {
		langLocal = "English",
		langWeather = "en-US",
		unitTemp = "F",
		unitVis = "Mi",
		unitWind = "Mph",
		varUnitTemp = "Fahrenheit",
		varUnitVis = "Miles",
		varUnitWind = "Mph"
	},
	["English (GB)"] = {
		langLocal = "English",
		langWeather = "en-GB",
		unitTemp = "C",
		unitVis = "Mi",
		unitWind = "Mph",
		varUnitTemp = "Celcius",
		varUnitVis = "Miles",
		varUnitWind = "Mph"
	},
	["English (World)"] = {
		langLocal = "English",
		langWeather = "en-CA",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Croatian"] = {
		langLocal = "Croatian",
		langWeather = "hr-HR",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Czech"] = {
		langLocal = "Czech",
		langWeather = "cs-CZ",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Danish"] = {
		langLocal = "Danish",
		langWeather = "da-DK",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Dutch"] = {
		langLocal = "Dutch",
		langWeather = "nl-NL",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["French"] = {
		langLocal = "French",
		langWeather = "fr-FR",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["German"] = {
		langLocal = "German",
		langWeather = "de-DE",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Greek"] = {
		langLocal = "Greek",
		langWeather = "el-GR",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Hungarian"] = {
		langLocal = "Hungarian",
		langWeather = "hu-HU",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Italian"] = {
		langLocal = "Italian",
		langWeather = "it-IT",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Polish"] = {
		langLocal = "Polish",
		langWeather = "pl-PL",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Portuguese"] = {
		langLocal = "Portuguese",
		langWeather = "pt-PT",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Russian"] = {
		langLocal = "Russian",
		langWeather = "ru-RU",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Spanish"] = {
		langLocal = "Spanish",
		langWeather = "es-ES",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Swedish"] = {
		langLocal = "Swedish",
		langWeather = "sv-SE",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Turkish"] = {
		langLocal = "Turkish",
		langWeather = "tr-TR",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	},
	["Ukrainian"] = {
		langLocal = "Ukrainian",
		langWeather = "uk-UA",
		unitTemp = "C",
		unitVis = "Km",
		unitWind = "Kmh",
		varUnitTemp = "Celcius",
		varUnitVis = "Kilometre",
		varUnitWind = "Km/h"
	}
}

function setLanguage(selectedLanguage)
	SKIN:Bang('!WriteKeyValue Variables Language "' .. langSelect[selectedLanguage]['langLocal'] .. '" "#@#Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables LangLoc "' .. langSelect[selectedLanguage]['langWeather'] .. '" "#@#Measures\\Weather\\Weather Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables TempUnits "' .. langSelect[selectedLanguage]['unitTemp'] .. '" "#@#Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables VisUnits "' .. langSelect[selectedLanguage]['unitVis'] .. '" "#@#Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables WindUnits "' .. langSelect[selectedLanguage]['unitWind'] .. '" "#@#Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables VarTempUnits "' .. langSelect[selectedLanguage]['varUnitTemp'] .. '" "#@#Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables VarVisUnits "' .. langSelect[selectedLanguage]['varUnitVis'] .. '" "#@#Variables.inc"')
	SKIN:Bang('!WriteKeyValue Variables VarWindUnits "' .. langSelect[selectedLanguage]['varUnitWind'] .. '" "#@#Variables.inc"')

	SKIN:Bang('!RefreshGroup Suite')

end
