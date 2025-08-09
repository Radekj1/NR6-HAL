class CfgPatches
{
	class NR6_AirReinforcements
	{
		author="NinjaRider600";
		name="NR6_AirReinforcements";
		units[]=
		{

		};
		requiredVersion=4.11;
		requiredAddons[]=
		{

		};
		version="4.11";
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
	class NR6_AirReinforcements_MODULES: NO_CATEGORY
	{
		displayName="NR6 Air Reinforcements";
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

	class NR6_AirReinfA_Module: Module_F
	{
		scope=2;
		displayName="Air/Land Reinforcements Mode A";
		author="NinjaRider600";
		vehicleClass="Modules";
		category="NR6_AirReinforcements_MODULES";
		function="NR6_fnc_ARA";
		icon = "\NR6_AirReinforcements\icons\NR6_AIRREINFA_PIN.paa";
		functionPriority=3;
		isGlobal=0;
		isTriggerActivated=1;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class _side
			{
				displayName="Side";
				description="Selects the side of spawned forces.";
				class values
				{
					class west
					{
						name="BLUFOR";
						value="west";
						default=1;
					};
					class east
					{
						name="OPFOR";
						value="east";
					};
					class resistance
					{
						name="INDEPENDENT";
						value="resistance";
					};
					class civilian
					{
						name="CIVILIAN";
						value="civilian";
					};
				};
			};

			class _HalReinf
			{
				displayName="Disable Type";
				description="Select the way the reinforcements module will stop working when players enter the range";
				class values 
				{
					class vanilla
					{
						name="Disable temporarily - players only - [Nearby Objective Detection]";
						value="vanilla";
						default=1;	
					};
					class KillSwitch
					{
						name="Disable completely - players only";
						value="KillSwitch";
					};
					class ReCapture
					{
						name="Commander needs to recapture the area - AI and players";
						value="ReCapture";
					};
				};
			};

			class _PlayerFriend
			{
				displayName="Allow Spawn If Friendly Player";
				description="Allows reinforcements to spawn at point if a friendly player is within the 'player or enemy disable range' but not if an enemy one is within that range.";
				typeName="BOOL";
				defaultValue = "true";
			};

			class _sidetick
			{
				displayName="Pool Size";
				description="Amount of available aircraft.";
				typeName="NUMBER";
				defaultValue = "15";
			};

			class _faction
			{
				displayName="Faction";
				description="Faction of the aircraft to spawn. The variety of factions is limited to what is configured in the pack (which in this case is almost nothing) so I recommend using custom";
				typeName="STRING";
				defaultValue = "custom";
			};

			class _Threshold
			{
				displayName="Threshold";
				description="Coefficient applied to the number of included aircraft at start below which the system will spawn new aircraft to replenish forces. Recommended '1'";
				typeName="NUMBER";
				defaultValue = "1";
			};

			class _playerRange
			{
				displayName="Player or Enemy Disable Range";
				description="Range in meters within which the script pauses itself if a player or enemy unit is present (to prevent immersion breaking).";
				typeName="NUMBER";
				defaultValue = "500";
			};

			class _TickTime
			{
				displayName="Delay";
				description="Delay in seconds between checks for replacing disabled aircraft";
				typeName="NUMBER";
				defaultValue = "15";
			};

			class _ExtraArgs
			{
				displayName="Arguments";
				description="Code that will be applied to the group leader of the spawned group. ('_this' represents the group leader unit). ex: (group _this) setBehaviour 'STEALTH'";
				typeName="STRING";
				defaultValue = "";
			};
			class _Pool
			{
				displayName="Custom Pool";
				description="If the faction has been set to custom, add here an array of all the aircraft options you want to use for your custom faction. Note these do not use group arrays, it is simply an array of the classnames you want to use.";
				typeName="ARRAY";
				defaultValue = "[]";
			};
			class _flight
			{
				displayName="Flight/Convoy Sizes";
				description="Pool of number of vehicles per group to be spawned. Add here all the options you want to be used in terms of groups";
				typeName="Array";
				defaultValue = "[1,2]";
			};
			class _DontLand
			{
				displayName="No Land RTB";
				description="Aircraft will not land on RTB from HAL missions if this is set to true.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class _Airborne
			{
				displayName="Spawn Airborne";
				description="Aircraft will spawn airborne.";
				typeName="BOOL";
				defaultValue = "False";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Spawns dynamic air reinforcements that come as flights and are added to HAL control. Useful for spawning fighters/bombers outside of the map and making them provide support for a side. Works with any air vehicle.";
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

	class NR6_AirReinfB_Module: Module_F
	{
		scope=2;
		displayName="Air Reinforcements Mode B";
		author="NinjaRider600";
		vehicleClass="Modules";
		category="NR6_AirReinforcements_MODULES";
		function="NR6_fnc_ARB";
		icon = "\NR6_AirReinforcements\icons\NR6_AIRREINFB_PIN.paa";
		functionPriority=3;
		isGlobal=0;
		isTriggerActivated=1;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class _side
			{
				displayName="Side";
				description="Selects the side of spawned forces.";
				class values
				{
					class west
					{
						name="BLUFOR";
						value="west";
						default=1;
					};
					class east
					{
						name="OPFOR";
						value="east";
					};
					class resistance
					{
						name="INDEPENDENT";
						value="resistance";
					};
					class civilian
					{
						name="CIVILIAN";
						value="civilian";
					};
				};
			};

			class _Threshold
			{
				displayName="Threshold";
				description="Number of aircraft that will be active at once";
				typeName="NUMBER";
				defaultValue = "1";
			};

			class _TickTime
			{
				displayName="Delay";
				description="Delay in seconds between checks for replacing disabled aircraft";
				typeName="NUMBER";
				defaultValue = "15";
			};

			class _ExtraArgs
			{
				displayName="Arguments";
				description="Code that will be applied to the group leader of the spawned group. ('_this' represents the group leader unit). ex: (group _this) setBehaviour 'STEALTH'";
				typeName="STRING";
				defaultValue = "";
			};
			
			class _DontLand
			{
				displayName="No Land RTB";
				description="Aircraft will not land on RTB from HAL missions if this is set to true.";
				typeName="BOOL";
				defaultValue = "False";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Uses synchronized parked air vehicles as pool of instead of spawning new ones. Useful for jets parked inside of hangars that will teleport out of those to a defines set of positions ready for departure. Crew is also only added at teleportation and included to HAL control.";
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
	class NR6_AirReinfC_Module: Module_F
	{
		scope=2;
		displayName="Air Reinforcements Mode C";
		author="NinjaRider600";
		vehicleClass="Modules";
		category="NR6_AirReinforcements_MODULES";
		function="NR6_fnc_ARC";
		icon = "\NR6_AirReinforcements\icons\NR6_AIRREINFB_PIN.paa";
		functionPriority=3;
		isGlobal=0;
		isTriggerActivated=1;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class _side
			{
				displayName="Side";
				description="Selects the side of spawned forces.";
				class values
				{
					class west
					{
						name="BLUFOR";
						value="west";
						default=1;
					};
					class east
					{
						name="OPFOR";
						value="east";
					};
					class resistance
					{
						name="INDEPENDENT";
						value="resistance";
					};
					class civilian
					{
						name="CIVILIAN";
						value="civilian";
					};
				};
			};

			class _Threshold
			{
				displayName="Threshold";
				description="Number of aircraft that will be active at once";
				typeName="NUMBER";
				defaultValue = "1";
			};

			class _TickTime
			{
				displayName="Delay";
				description="Delay in seconds between checks for replacing disabled aircraft";
				typeName="NUMBER";
				defaultValue = "15";
			};

			class _ExtraArgs
			{
				displayName="Arguments";
				description="Code that will be applied to the group leader of the spawned group. ('_this' represents the group leader unit). ex: (group _this) setBehaviour 'STEALTH'";
				typeName="STRING";
				defaultValue = "";
			};
			class _DontLand
			{
				displayName="No Land RTB";
				description="Aircraft will not land on RTB from HAL missions if this is set to true.";
				typeName="BOOL";
				defaultValue = "False";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Uses synchronized parked air vehicles as pool instead of spawning new ones but adds their crew right away and does not move them to any pad. Useful for having an airfield full of assets that will only be used as others are disabled (for example, you could have 10 attack helicopters ready to depart but only 2 of them will have their crew inside of the vehicle and will be ready for tasking, the rest will have their crew waiting outside of their helicopter until the active assets are destroyed or disabled).";
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
			class ARA
			{
				description="ARA";
				file="\NR6_AirReinforcements\AReinforcementsNR6A.sqf";
			};

			class ARB
			{
				description="ARB";
				file="\NR6_AirReinforcements\AReinforcementsNR6B.sqf";
			};

			class ARC
			{
				description="ARC";
				file="\NR6_AirReinforcements\AReinforcementsNR6C.sqf";
			};

			class ARAi
			{
				description="ARAi";
				file="\NR6_AirReinforcements\ARInitNR6A.sqf";
				preinit=1;
			};

			class ARBi
			{
				description="ARBi";
				file="\NR6_AirReinforcements\ARInitNR6B.sqf";
				preinit=1;
			};

			class ARCi
			{
				description="ARCi";
				file="\NR6_AirReinforcements\ARInitNR6C.sqf";
				preinit=1;
			};
		};	
	};
};

