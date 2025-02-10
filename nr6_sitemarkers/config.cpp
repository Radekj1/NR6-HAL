class CfgPatches
{
	class NR6_SiteMarkers
	{
		author="NinjaRider600";
		name="NR6_SiteMarkers";
		units[]=
		{

		};
		requiredVersion=4.02;
		requiredAddons[]=
		{

		};
		version="4.02";
		authors[]=
		{
			"NinjaRider600"
		};
		weapons[]={};
	};
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class NR6_SiteMarkers_MODULES: NO_CATEGORY
	{
		displayName="NR6 Site Markers";
	};
};

class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class ArgumentsBaseUnits;
		class ModuleDescription;
		class AttributeValues;
		
	};

//General Modules

	class NR6_SiteMarker_Module: Module_F
	{
		scope=2;
		displayName="Dynamic Marker";
		author="NinjaRider600";
		vehicleClass="Modules";
		category="NR6_SiteMarkers_MODULES";
		function="NR6_fnc_sitemarker";
//		icon = "\NR6_Sites\icons\NR6_SITE_PIN.paa";
		functionPriority=1;
		isGlobal=0;
		isTriggerActivated=1;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class _objradius
			{
				displayName="Site Radius";
				description="Radius of the site used for detection of troops.";
				typeName="NUMBER";
				defaultValue = "150";
			};

			class _BluforType
			{
				displayName="Name Of BLUFOR Side";
				description="Name used in the notifications for the side.";
				typeName="STRING";
				defaultValue = "BLUFOR";
			};

			class _OpforType
			{
				displayName="Name Of OPFOR Side";
				description="Name used in the notifications for the side.";
				typeName="STRING";
				defaultValue = "OPFOR";
			};

			class _IndepType
			{
				displayName="Name Of INDEPENT Side";
				description="Name used in the notifications for the side.";
				typeName="STRING";
				defaultValue = "INDEPENDENT";
			};
			class _campName
			{
				displayName="Site Name";
				description="Name of the site/objective used in the marker and the notifications.";
				typeName="STRING";
				defaultValue = "";
			};
			class _mrkSize
			{
				displayName="Marker Size";
				description="Size of the marker.";
				typeName="NUMBER";
				defaultValue = "1";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Spawns a dynamic marker that changes according to the presence of different sides.";
		};
	};
};


class CfgFunctions
{
	class NR6
	{
		class Modules
		{
			class sitemarker
			{
				description="Sitemarker";
				file="\NR6_SiteMarkers\SiteMarkNR6.sqf";
			};

		};	
	};
};

class CfgNotifications
	{
		class NR6_Objective_B
		{
			title = "%1";
			iconPicture = "\A3\ui_f\data\map\Markers\NATO\b_installation.paa";
			description = "%2";
			priority = 7;
			duration = 5;
			color[] = {0,0,1,1};
			difficulty[] = {};
		};
		class NR6_Objective_O
		{
			title = "%1";
			iconPicture = "\A3\ui_f\data\map\Markers\NATO\o_installation.paa";
			description = "%2";
			priority = 7;
			duration = 5;
			color[] = {0.6,0,0,1};
			difficulty[] = {};
		};
		class NR6_Objective_I
		{
			title = "%1";
			iconPicture = "\A3\ui_f\data\map\Markers\NATO\n_installation.paa";
			description = "%2";
			priority = 7;
			duration = 5;
			color[] = {0,0.5,0,1};
			difficulty[] = {};
		};
		class NR6_Objective_N
		{
			title = "%1";
			iconPicture = "\A3\ui_f\data\map\Markers\NATO\n_installation.paa";
			description = "%2";
			priority = 7;
			duration = 5;
			color[] = {0.5,0.5,0.5,1};
			difficulty[] = {};
		};
	};
