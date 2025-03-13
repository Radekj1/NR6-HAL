class CfgPatches
{
	class NR6_ZBE_CACHE
	{
		author="NinjaRider600";
		name="NR6_ZBE_CACHE";
		units[]=
		{

		};
		requiredVersion=2.18;
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
	class NR6_zbecache_MODULES: NO_CATEGORY
	{
		displayName="NR6 ZBE Caching";
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

	class NR6_Cache_Module: Module_F
	{
		scope=2;
		displayName="Caching System";
		author="NinjaRider600";
		vehicleClass="Modules";
		category="NR6_zbecache_MODULES";
		function="NR6_fnc_cache";
		functionPriority=1;
		isGlobal=0;
		isTriggerActivated=1;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class zbe_aiCacheDist
			{
				displayName="AI Caching Distance";
				description="";
				typeName="NUMBER";
				defaultValue = "1500";
			};

			class zbe_debug
			{
				displayName="Debug";
				description="";
				typeName="BOOL";
				defaultValue = "False";
			};

			class zbe_vehicleCacheDistCar
			{
				displayName="Vehicle Car Dist";
				description="";
				typeName="NUMBER";
				defaultValue = "2000";
			};

			class zbe_vehicleCacheDistAir
			{
				displayName="Vehicle Air Dist";
				description="";
				typeName="NUMBER";
				defaultValue = "3000";
			};

			class zbe_vehicleCacheDistBoat
			{
				displayName="Vehicle Boat Dist";
				description="";
				typeName="NUMBER";
				defaultValue = "3000";
			};
			class zbe_ObjCache
			{
				displayName="Experimental Object Cache";
				description="DO NOT USE";
				typeName="BOOL";
				defaultValue = "False";
			};
			class zbe_ObjCacheLite
			{
				displayName="Experimental Object Cache Lite";
				description="DO NOT USE";
				typeName="BOOL";
				defaultValue = "False";
			};
			class zbe_NoHideMode
			{
				displayName="Disable Hide Mode (Non-hosts)";
				description="";
				typeName="BOOL";
				defaultValue = "False";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Activates HAL. Can be synchronized to a trigger for late activation.";
			sync[]=
			{
				"LocationArea_F"
			};
			class LocationArea_F
			{
				position=0;
				optional=0;
				duplicate=1;
				synced[]=
				{
					"Anything"
				};
			};
		};
	};
};


class CfgFunctions
{
	class NR6
	{
		class Modules
		{
			class cache
			{
				description="Nothing";
				file="\NR6_zbe_cache\main.sqf";
			};
		};
	};
};

