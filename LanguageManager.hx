package;

import flash.display.GraphicsStroke;
import openfl.Assets;
import openfl.system.Capabilities;

class LanguageManager
{
	public static var NAME : String = "LANGUAGE";
	
	//Languages 
	public static var SPANISH : String 		= "es";
	public static var ENGLISH : String 		= "en";
	public static var GERMAN : String 		= "de";
	public static var JAPANESE : String 		= "jp";
	public static var ITALIAN : String 		= "it";
	public static var FRENCH : String 		= "fr";
	public static var CHINESE : String 		= "zh";
	
	
	private static var instance : LanguageManager;
	
	private static var languagesPath : String;
	
	private static var languageData : Map<String,String>;
	
	private static var availableLanguages : Array<String>;
	
	private static var currentLanguage : String;
	
	private static var defaultLanguage : String;
	
	public static function InitInstance(path : String,defaultLang : String = "", availableLanguages : Array<String> = null, language : String = ""): LanguageManager
	{
		if (instance == null)
			instance = new LanguageManager(path,defaultLang,availableLanguages,language);
				
		return instance;
	}
	
	/*
	 * Creates and returns a screen manager instance if it's not created yet.
	 * Returns the current instance of this class if it already exists.
	 */
	public static function GetInstance(): LanguageManager
	{
		if ( instance == null )
			throw "Language is not initialized. Use function 'InitInstance'";
		
		return instance;
	}
	
	/*
	 * Constructor
	 */
	private function new(path : String, defaultLang : String, availLanguages : Array<String>, language : String) 
	{
		languagesPath = path;
		defaultLanguage = defaultLang == "" ? ENGLISH : defaultLang;
		availableLanguages = availLanguages == null ? [defaultLanguage] : availLanguages;
		currentLanguage = (language == "") ? defaultLanguage : language;
		languageData = new Map<String,String>();
	}
	
	public static function SetDefaultLanguage(lan : String) : Void
	{
		defaultLanguage = lan;
	}
	
	public static function SetAvailableLanguages(languages : Array<String>) : Void
	{
		availableLanguages = languages;
	}
	
	public static function Translate(name : String) : String
	{	
		return languageData.get(name.toLowerCase());
	}
	
	public static function ChangeLanguage(lang : String) : Void
	{
		currentLanguage = lang;
		LoadXML();
	}
	
	public static function GetCurrentLanguage() : String
	{
		return currentLanguage;
	}
	
	public static function LoadXML(filename : String = "") : Void
	{
		var path, str, name, translation : String;
		var xml : Xml;
		
		filename = filename == "" ? currentLanguage : filename;
		path = languagesPath + filename + ".xml";
		
		try
		{
			str = Assets.getText(path);
			xml = Xml.parse(str).firstElement();
			
			if (xml.nodeName.toLowerCase() == "language")
			{	
				for (e in xml.elements())
				{
					name = e.get("name").toLowerCase();
					translation = e.get("translation");
					languageData.set(name, translation);
				}
			}
		}
		catch (e : String)
		{
			trace(e);
		}
	}
	
	public static function GetDeviceLanguage() : String
	{
		var lang, devLang : String;
		
		lang = Capabilities.language;
		devLang = defaultLanguage;
		
		if (availableLanguages != null)
		{
			//Spanish
			if (~/es/.match(lang) && availableLanguages.indexOf(SPANISH) != -1)
				devLang = SPANISH;
			
			//English
			if (~/en/.match(lang) && availableLanguages.indexOf(ENGLISH) != -1)
				devLang = ENGLISH;
				
			//Japanese
			if (~/ja/.match(lang) && availableLanguages.indexOf(JAPANESE) != -1)
				devLang = JAPANESE;
				
			//Chinese
			if (~/zh/.match(lang) && availableLanguages.indexOf(CHINESE) != -1)
				devLang = CHINESE;
		}
			
		return devLang;
	}
}