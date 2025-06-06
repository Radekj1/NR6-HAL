class CfgPatches
{
	class NR6_Reinforcements
	{
		author="NinjaRider600";
		name="NR6_Reinforcements";
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
	class NR6_Reiforcements_MODULES: NO_CATEGORY
	{
		displayName="NR6 Forces";
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

	class NR6_Reiforcements_Module: Module_F
	{
		scope=2;
		displayName="Reinforcements";
		author="NinjaRider600";
		vehicleClass="Modules";
		category="NR6_Reiforcements_MODULES";
		function="NR6_fnc_reinf";
		icon = "\NR6_Reinforcements\icons\NR6_REINF_PIN.paa";
		functionPriority=3;
		isGlobal=0;
		isTriggerActivated=1;
		isDisposable=0;
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
				defaultValue = "false";
			};
			
			class _rStrgt
			{
				displayName="Spawns Per Wave";
				description="Number of groups that will spawn at once each time side forces are below the threshold.";
				typeName="NUMBER";
				defaultValue = "1";
			};

			class _SpawnRadius
			{
				displayName="Spawn Radius";
				description="Radius for spawning groups.";
				typeName="NUMBER";
				defaultValue = "300";
			};

			class _sidetick
			{
				displayName="Pool Size";
				description="Number of groups that can be spawned in reserve.";
				typeName="NUMBER";
				defaultValue = "10";
			};
			class _faction
			{
				displayName="Faction";
				description="Faction of the reinforcements. The variety of factions is limited to what is configured in the pack. Use 'custom' to set the group pool (see below).";
				typeName="STRING";
				defaultValue = "BLU_F";
			};
			class _Threshold
			{
				displayName="Threshold";
				description="Coefficient applied to the total number of units of the side at start below which the system will spawn new groups to replenish forces.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class _playerRange
			{
				displayName="Player or Enemy Disable Range";
				description="Range in meters within which the script pauses itself if a player or enemy unit is present (to prevent immersion breaking).";
				typeName="NUMBER";
				defaultValue = "1000";
			};
			class _Pool
			{
				displayName="Custom Pool";
				description="If the faction has been set to 'custom', add here an array of all the group options you want to use for your custom faction.";
				typeName="ARRAY";
				defaultValue = "[]";
			};
			class _TDecay
			{
				displayName="Threshold Decay";
				description="Decay of the threshold per spawn.";
				typeName="NUMBER";
				defaultValue = "-1";
			};
			class _RejoinPoint
			{
				displayName="Rally Point";
				description="Rally position.";
				typeName="ARRAY";
				defaultValue = "";
			};
			class _ExtraArgs
			{
				displayName="Arguments";
				description="Code that will be applied to the group leader of the spawned group. ('_this' represents the group leader unit). ex: (group _this) setBehaviour 'STEALTH'";
				typeName="STRING";
				defaultValue = "";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Spawns dynamic reinforcements based on side unit count. Reinforcements can be disabled around players  and new groups can be automatically added to the control of a HAL commander. Synchronize to HAL commander module to include troops under commander's control.";
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

	class NR6_ReqPoint_Module: Module_F
	{
		scope=2;
		displayName="Request Point";
		author="NinjaRider600";
		vehicleClass="Modules";
		category="NR6_Reiforcements_MODULES";
		function="NR6_fnc_reqPt";
		icon = "\NR6_Reinforcements\icons\NR6_SPAWN_PIN.paa";
		functionPriority=3;
		isGlobal=0;
		isTriggerActivated=1;
		isDisposable=0;
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
				};
			};
			class _Pool
			{
				displayName="Custom Pool";
				description="Array of all the unit options you want to have available for spawning via the request point. Asset compiler overrides this value if synced to the module.";
				typeName="ARRAY";
				defaultValue = "[]";
			};
			class NR6Supplies
			{
				displayName="Supplies At Point";
				description="Number of supplies at start. Nearby reinforcements module overrides this value by using its available spawns x10 in terms of supplies.";
				typeName="NUMBER";
				defaultValue = "100";
			};
			class NR6ManCost
			{
				displayName="Infantry Unit Cost";
				description="Cost of unit type in supplies.";
				typeName="NUMBER";
				defaultValue = "5";
			};
			class NR6CarCost
			{
				displayName="Car Vehicle Cost";
				description="Cost of unit type in supplies.";
				typeName="NUMBER";
				defaultValue = "25";
			};
			class NR6OtherCost
			{
				displayName="Other Vehicle Cost";
				description="Cost of unit type in supplies.";
				typeName="NUMBER";
				defaultValue = "50";
			};
			class NR6EmptySpawn
			{
				displayName="Spawn Vehicles Empty";
				description="Spawns vehicles without crew.";
				typeName="BOOL";
				defaultValue = "true";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="";
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

	class NR6_ReqPointCost_Module: Module_F
	{
		scope=2;
		displayName="Set Req Pt Class Cost";
		author="NinjaRider600";
		vehicleClass="Modules";
		category="NR6_Reiforcements_MODULES";
		function="NR6_fnc_reqPtCost";
		icon = "\NR6_Reinforcements\icons\NR6_SPAWN_PIN.paa";
		functionPriority=1;
		isGlobal=0;
		isTriggerActivated=1;
		isDisposable=0;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class NR6UnitClassCost
			{
				displayName="Cost Of Unit Class";
				description="Cost, in supplies, of unit class for use via the request point.";
				typeName="NUMBER";
				defaultValue = "5";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="";
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
	
	class NR6_Spawn_Module: Module_F
	{
		scope=2;
		displayName="Spawn Forces";
		author="NinjaRider600";
		vehicleClass="Modules";
		category="NR6_Reiforcements_MODULES";
		function="NR6_fnc_reinf";
		icon = "\NR6_Reinforcements\icons\NR6_SPAWN_PIN.paa";
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

			class _rStrgt
			{
				displayName="Spawns At Once";
				description="Number of groups that will spawn at once.";
				typeName="NUMBER";
				defaultValue = "1";
			};

			class _SpawnRadius
			{
				displayName="Spawn Radius";
				description="Radius for spawning groups.";
				typeName="NUMBER";
				defaultValue = "300";
			};
			class _faction
			{
				displayName="Faction";
				description="Faction of the reinforcements. The variety of factions is limited to what is configured in the pack. Use 'custom' to set the group pool (see below).";
				typeName="STRING";
				defaultValue = "BLU_F";
			};
			class _Pool
			{
				displayName="Custom Pool";
				description="If the faction has been set to 'custom', add here an array of all the group options you want to use for your custom faction.";
				typeName="ARRAY";
				defaultValue = "[]";
			};
			class _playerRange
			{
				displayName="Player Disable Range";
				description=" Range in meters within which the script pauses itself if a player is present (to prevent immersion breaking). In this case, it will wait until players are away to spawn the groups";
				typeName="NUMBER";
				defaultValue = "0";
			};
			class _ExtraArgs
			{
				displayName="Arguments";
				description="Code that will be applied to the group leader of the spawned group. ('_this' represents the group leader unit). ex: (group _this) setBehaviour 'STEALTH'";
				typeName="STRING";
				defaultValue = "";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Uses the code from NR6 Reinforcements to spawn a one-time batch of troops, useful for quickly adding randomized forces from a pool that will automatically be added to a Leader’s control. Can also wait until all players are away to spawn forces. Reinforcements can be disabled around players  and new groups can be automatically added to the control of a HAL commander. Synchronize to HAL commander module to include troops under commander's control.";
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
			class reinf
			{
				description="REINF";
				file="\NR6_Reinforcements\ReinforcementsNR6.sqf";
			};

			class reinfi
			{
				description="REINF1";
				file="\NR6_Reinforcements\RInitNR6.sqf";
				preinit=1;
			};

			class reqPt
			{
				description="reqPt";
				file="\NR6_Reinforcements\RequestPointNR6.sqf";
			};

			class reqPtCost
			{
				description="reqPtCost";
				file="\NR6_Reinforcements\RequestPointCostNR6.sqf";
			};
		};	
	};
};

