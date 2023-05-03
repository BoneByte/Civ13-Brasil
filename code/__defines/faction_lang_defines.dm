//factions only
#define PIRATES "PIRATES"
#define CIVILIAN "CIVILIAN"
#define INDIANS "INDIANS"
#define BRITISH "Britanico"
#define ROMAN "ROMAN"
#define AMERICAN "AMERICAN"

// used for languages only
#define ENGLISH "ENGLISH"
#define CARIB "CARIB"
#define LATIN "LATIN"
#define UKRAINIAN "UKRAINIAN"
#define CHINESE "CHINESE"
#define HEBREW "HEBREW"
#define SWAHILI "SWAHILI"
#define ZULU "ZULU"
#define AINU "AINU"
#define GAELIC "GAELIC"
#define ITALIAN "ITALIAN"
#define CHEROKEE "CHEROKEE"
#define INUIT "INUIT"
#define OLDNNORSE "OLDNORSE"
#define EGYPTIAN "EGYPTIAN"
#define IROQUOIS "IROQUOIS"

//used for languages & factions
#define SPANISH "SPANISH"
#define PORTUGUESE "PORTUGUESE"
#define FRENCH "FRENCH"
#define DUTCH "DUTCH"
#define JAPANESE "JAPANESE"
#define RUSSIAN "RUSSIAN"
#define CHECHEN "CHECHEN"
#define FINNISH "FINNISH"
#define NORWEGIAN "NORWEGIAN"
#define SWEDISH "SWEDISH"
#define DANISH "DANISH"
#define GREEK "GREEK"
#define ARAB "ARAB"
#define GERMAN "GERMAN"
#define VIETNAMESE "VIETNAMESE"
#define KOREAN "KOREAN"
#define FILIPINO "FILIPINO"
#define POLISH "POLISH"

/proc/faction_const2name(constant,age = 0)

	if (constant == PIRATES)
		return "Pirates"

	if (constant == BRITISH)
		if (age >= 6)
			return "Reino Únido"
		else
			return "Império Britanico"

	if (constant == CIVILIAN)
		if (map.ID == "TSARITSYN")
			return "Red Army"
		else if (map.ID == "YELTSIN")
			return "Militia"
		else if (map.ID == "AFRICAN_WARLORDS")
			return "Yellowagwana Wartribe"
		else if (map.ID == "TADOJSVILLE")
			return "United Nations Peacekeepers"
		else if (map.ID == "WHITERUN")
			return "Stormcloaks"
		else if (map.ID == "CAPITOL_HILL")
			return "Rioters"
		else if (map.ID == "WACO")
			return "Branch Davidians"
		else if (map.ID == "MISSIONARY_RIDGE")
			return "Confederates"
		else if (map.ID == "TANTIVEIV")
			return "Rebels"
		else if (map.ID == "RUHR_UPRISING")
			return "Ruhr Red Army"
		else if (map.ID == "MAGISTRAL")
			return "DRA Army"
		else if (map.ID == "BANK_ROBBERY" || map.ID == "DRUG_BUST")
			return "Police Department"
		else if (map.ID == "LONG_MARCH")
			return "Red Army"
		else if (map.ID == "EFT_FACTORY")
			return "Scavs"
		else
			if (age >= 6)
				return "Civilians"
			else
				return "Colonos"

	if (constant == INDIANS)
		if (map.ID == "AFRICAN_WARLORDS")
			return "Blugisi Wartribe"
		else if (map.ID == "TADOJSVILLE")
			return "Mercenary Warbands"
		else if (map.ID == "EAST_LOS_SANTOS")
			return "Torcida Jovem do Flamengo"
		else
			return "Native Tribe"

	if (constant == PORTUGUESE)
		return "Império Francês"

	if (constant == SPANISH)
		return "Império Espanhol"

	if (constant == FRENCH)
		if (age >= 4)
			return "República Francesa"
		else
			return "Império Francês"

	if (constant == DUTCH)
		if (age >= 6)
			return "Monarquia Holandesa"
		else
			return "República Holandesa"

	if (constant == JAPANESE)
		return "Império Japonês"

	if (constant == RUSSIAN)
		if (map.ID == "YELTSIN")
			return "Exército Russo"
		else if (map.ID == "GROZNY")
			return "Forças Federais Russas"
		else if (map.ID == "TSARITSYN")
			return "Exército Branco"
		else if (map.ID == "BANK_ROBBERY")
			return "Assaltantes"
		else if (map.ID == "DRUG_BUST")
			return "Rednikov Mobsters"
		else if (map.ID == "EFT_FACTORY")
			return "BEAR"
		else
			if (age == 6 || age == 7)
				return "União Sovietica"
			else if (age >= 8)
				return "Federação Russa"
			else
				return "Império Russo"

	if (constant == ROMAN)
		if (map.ID == "WHITERUN")
			return "Exército Imperial"
		else
			return "República Romana"

	if (constant == CHECHEN)
		return "República Tcheca de Ichkeria"

	if (constant == FINNISH)
		return "República da Finlandia"

	if (constant == NORWEGIAN)
		if (map.ID == "CLASH")
			return "Bear Clan"
		else
			return "Reino da Noruega"

	if (constant == SWEDISH)
		return "Reino da Suécia"

	if (constant == DANISH)
		if (map.ID == "CLASH")
			return "Raven Clan"
		else
			return "Reino da Dinamarca"

	if (constant == GERMAN)
		if (age == 6)
			return "Terceiro Reich"
		else if (age >= 7)
			return "República Federal da Alemanha"
		else if (map.ID == "RUHR_UPRISING")
			return "República de Weimar"
		else
			return "Império Alemão"
	if (constant == GREEK)
		return "Estados Gregos"

	if (constant == ARAB)
		if (age >= 6)
			if (map.ID == "ARAB_TOWN")
				return "Hezbollah"
			else if (map.ID == "SOVAFGHAN" || map.ID == "HILL_3234" || map.ID == "MAGISTRAL")
				return "Mujahideen"
			else
				return "Insurgentes"
		else
			return "Califado Árabe"

	if (constant == AMERICAN)
		if (map.ID == "ARAB_TOWN")
			return "IDF"
		else if (map.ID == "CAPITOL_HILL")
			return "Governo Americano"
		else if (map.ID == "WACO")
			return "ATF"
		else if (map.ID == "TANTIVEIV")
			return "Imperiais"
		else if (map.ID == "EAST_LOS_SANTOS")
			return "Gavioes da Fiel"
		else if (map.ID == "EFT_FACTORY")
			return "USEC"
		else
			return "Estados Unidos"

	if (constant == VIETNAMESE)
		return "Vietnamita"

	if (constant == POLISH)
		if (map.ID == "WARSAW")
			return "Exército Polonês"
		else
			return "Polonês"

	if (constant == CHINESE)
		if (map.ID == "LONG_MARCH")
			return "Exército Nacional"
		else
			return "Chinês"

	if (constant == EGYPTIAN)
		return "Egípcio"

	if (constant == KOREAN)
		return "Coreano"

	if (constant == IROQUOIS)
		return "Iroquois"

	if (constant == FILIPINO)
		return "Filipino"
