package;

import openfl.Assets;

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
	
	
	private static var instance : LanguageManager;
	
	private static var languagesPath : String;
	
	private static var languageData : Map<String,String>;
	
	private static var currentLanguage : String;
	
	public static function InitInstance(path : String, language : String = ""): LanguageManager
	{
		if (instance == null)
			instance = new LanguageManager(path,language);
				
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
	private function new(path : String, language : String) 
	{
		languagesPath = path;
		currentLanguage = (language == "") ? ENGLISH : language;
		languageData = new Map<String,String>();
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
}