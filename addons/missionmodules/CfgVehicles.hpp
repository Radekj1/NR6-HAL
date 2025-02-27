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

	class GVAR(Core_Module): Module_F
	{
		scope=2;
		displayName="HAL Core";
		author="NinjaRider600";
		vehicleClass="Modules";
		category= QGVAR(core);
		function = QEFUNC(core,init);
		icon = QPATHTOF(icons\HALCOREPIN.paa);
		functionPriority=1;
		isGlobal=0;
		isTriggerActivated=1;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_Wait
			{
				displayName="Startup Delay";
				description="Time in seconds that HAL will wait before initializing.";
				typeName="NUMBER";
				defaultValue = "15";
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

	class GVAR(GenSettings_Module): Module_F
	{
		scope=2;
		displayName="HAL General Settings";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(core);
		function= QFUNC(generalSettings);
		icon = QPATHTOF(icons\HALGENSETPIN.paa);
		functionPriority=1;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydxHQ_ReconCargo
			{
				displayName="Enable Cargo Recon";
				description="Recon orders will use provided lifts.";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydxHQ_SynchroAttack
			{
				displayName="Synchronized/Planned Attacks";
				description="Attacks will be timed and synchronized among squads attacking the same target.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydxHQ_HQChat
			{
				displayName="Commander Chat Orders";
				description="Commander orders visivle in side chat.";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydxHQ_AIChatDensity
			{
				displayName="Radio Comms Presence";
				description="Chance for a communication between AI and commander to be visible and audible.";
				typeName="NUMBER";
				defaultValue = "100";
			};
			class RydxHQ_AIChat_Type
			{
				displayName="Radio Comms Profile";
				description="Changes the lines used in radio communications to better fit certain contexts for modded content.";
				class values
				{
					class NONE
					{
						name="Default (Original recordings from Hetman Artificial Commander)";
						value="NONE";
						default=1;
					};
					class SILENT_M
					{
						name="Only Radio Static (+ Rewritten lines)";
						value="SILENT_M";
					};
					class 40K_IMPERIUM
					{
						name="Imperium Of Man (Warhammer 40K)";
						value="40K_IMPERIUM";
					};
				};
			};
			class RydxHQ_InfoMarkersID
			{
				displayName="Add Group ID for BFT";
				description="Friendly forces will have their Squad ID show up on info markers.";
				typeName="BOOL";
				defaultValue = "true";
			};
			class RydxHQ_Actions
			{
				displayName="Squad Leader Actions";
				description="Player squad leaders will have HAL actions enabled.";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydxHQ_ActionsMenu
			{
				displayName="Actions Menu";
				description="Player squad leaders will have HAL actions enabled as a menu.";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydxHQ_TaskActions
			{
				displayName="Tasking Actions (Deprecated)";
				description="Player squad leaders will have tasking related actions. Deprecated by menu.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydxHQ_SupportActions
			{
				displayName="Support Actions (Deprecated)";
				description="Player squad leaders will have support related actions. Deprecated by menu.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydxHQ_ActionsAceOnly
			{
				displayName="Only Use ACE Actions";
				description="Player squad leaders will only use ACE self-interactions for their HAL actions.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydxHQ_NoRestPlayers
			{
				displayName="Disable Withdraw For Players Squad Leader";
				description="Players will not receive forced retreat orders (Recommended).";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydxHQ_NoCargoPlayers
			{
				displayName="Disable Cargo Players Squad Leaders";
				description="Players will not be provided with forced lifts (Recommended).";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQx_PlayerCargoCheckLoopTime
			{
				displayName="Player Transport Check Time";
				description="Upon request for air or ground transport by player, time (in minutes) during which an AI commander will keep looking for an available transport to assign to the player before aborting the request if no transport is found.";
				typeName="NUMBER";
				defaultValue = "2";
			};
			class RydxHQ_DisembarkRange
			{
				displayName="Infantry Disembark Upon Enemy Contact";
				description="Infantry will dismount their transport upon making contact with enemy within this radius from them. Note that certain orders will always have their infantry disembark when meeting nearby enemy to counterattack and re-evaluate.";
				typeName="NUMBER";
				defaultValue = "200";
			};
			class RydxHQ_CargoObjRange
			{
				displayName="Distance To Use Transport";
				description="Distance beyond which infantry will make use of dispatched transports to get a lift. Too low values will result in problematic behaviour.";
				typeName="NUMBER";
				defaultValue = "1500";
			};
			class RydxHQ_LZ
			{
				displayName="Enable LZ System";
				description="System that will place invisible helipads when helicopter transport is issued to improve the selection of landing sites by AI pilots.";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydxHQ_GarrisonV2
			{
				displayName="NR6 Sites Garrisons";
				description="Uses the NR6 Sites CBA based defensive script for garrison orders instead of stock HAL.";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydxHQ_NEAware
			{
				displayName="Squad Info Share Range";
				description="How far do squads communicate enemy positions to other nearby squads. Set to 0 to disable.";
				typeName="NUMBER";
				defaultValue = "500";
			};
			class RydxHQ_SlingDrop
			{
				displayName="Sling Load Ammo Drop";
				description="(Feature inconsistent at this time)";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydxHQ_RHQAutoFill
			{
				displayName="RHQ Auto Mode";
				description="Classifies units to be used by HAL automatically";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydxHQ_PathFinding
			{
				displayName="Pathfinding Increments";
				description="Set to 0 to disable. Adds several waypoints to squads instead of a single straight line waypoint to account for terrain. May cause more issues with mobility. (Recommended disabled)";
				typeName="NUMBER";
				defaultValue = "0";
			};
			class RydxHQ_MagicHeal
			{
				displayName="Supports Magic Heal (ACE only)";
				description="Enables magic healing around ambulances upon support request as a workaround for ACE medical.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydxHQ_MagicRepair
			{
				displayName="Supports Magic Repair";
				description="Enables magic repairs around repair vehicles upon support request as a workaround for ACE repair limitations.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydxHQ_MagicRearm
			{
				displayName="Supports Magic Rearm";
				description="Enables magic vehicle rearming around ammo vehicles upon support request as a workaround for ACE rearming limitations.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydxHQ_MagicRefuel
			{
				displayName="Supports Magic Refuel";
				description="Enables magic refueling around refuel vehicles upon support request as a workaround for ACE refuel limitations.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydART_Safe
			{
				displayName="Base Artillery Danger Close Range";
				description="Base distance, in meters, from which artillery missions will be calculated as far enough from friendly forces. This value is shared by all commanders as it is a base value that is affected by several other factors such as commander personaility, weather, environment, etc.";
				typeName="NUMBER";
				defaultValue = "250";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="General settings shared by all commanders.";
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

//Commander Modules

	class GVAR(Leader_Module): Module_F
	{
		scope = 2;
		displayName = "HAL Commander";
		author = "NinjaRider600";
		vehicleClass = "Modules";
		category = QGVAR(leader);
		function = QFUNC(addLeader);
		icon = QPATHTOF(icons\HALCOPIN.paa);
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		isDisposable = 0;
		is3DEN = 0;
		class Arguments: ArgumentsBaseUnits
		{
			class LeaderType
			{
				displayName = "AI Commander Selection";
				description = "Selects which AI leader slot will be selected for the synchronized unit (or virtually created for non-synchronized).";
				typeName = "STRING";
				class values
				{
					class A
					{
						name="Leader A";
						value="LeaderHQ";
						default = 1;
					};
					class B
					{
						name="Leader B";
						value="LeaderHQB";
					};
					class C
					{
						name="Leader C";
						value="LeaderHQC";
					};
					class D
					{
						name="Leader D";
						value="LeaderHQD";
					};
					class E
					{
						name="Leader E";
						value="LeaderHQE";
					};
					class F
					{
						name="Leader F";
						value="LeaderHQF";
					};
					class G
					{
						name="Leader G";
						value="LeaderHQG";
					};
					class H
					{
						name="Leader H";
						value="LeaderHQH";
					};
				};
			};

			class LeaderSide
			{
				displayName="AI Leader Side";
				description="Selects the side of the AI Leader if virtual.";
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

			class HQname
			{
				displayName="AI HQ Callsign";
				description="Selects the group name (callsign) for AI leader";
				typeName="STRING";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Adds an AI commander. Synchronize to a unit to set it to be the AI commander or do not for a virtual HQ";
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

	class GVAR(Leader_Settings_Module): Module_F
	{
		scope=2;
		displayName="Commander Settings";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(leader);
		function= QFUNC(leaderSettings);
		icon = QPATHTOF(icons\HALCOSETPIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_Fast
			{
				displayName="Fast Orders";
				description="Makes commander issue orders before the end of its waiting period between order cycles. Can cause clashing orders and heavy CPU load.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_CommDelay
			{
				displayName="Communication Delay";
				description="Coefficient of speed for orders dispatching. (ex: 2 for double delay) Avoid values under 1.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_ChatDebug
			{
				displayName="Map Radio Messages";
				description="Show radio messages on map as markers.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_ExInfo
			{
				displayName="Ext Enemy Reports";
				description="Makes commander receive information about enemies from non-controlled groups.";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_ResetTime
			{
				displayName="Cycle Duration";
				description="Waiting time between each cycle of orders.";
				typeName="NUMBER";
				defaultValue = "150";
			};
			class RydHQ_ResetOnDemand
			{
				displayName="Cycles On Demand";
				description="Only advance to next order cycle when ((group LeaderHQ) setVariable ['RydHQ_ResetNow',true]) has been set to true for the concerned commander.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_SubAll
			{
				displayName="Control All Side Groups";
				description="Add all from the same side as the commander under his control.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_SubSynchro
			{
				displayName="Control Sync Groups";
				description="Units synchronized to the commander unit will be added to his control (Non Virtual CO).";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_KnowTL
			{
				displayName="Commander KnownE Share";
				description="All known enemy targets will be shared to controlled players";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_GetHQInside
			{
				displayName="Commander Shelter Seek";
				description="Commanders will seek for shelter everytime they relocate (For Relocating Mode).";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_CamV
			{
				displayName="Remote Cam";
				description="Setting broken with caching. Supposed to add a camera to see what other squad leaders can see";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_InfoMarkers
			{
				displayName="BFT Markers";
				description="Enables BFT markers with known enemy positions refreshed each cycle.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_ArtyMarks
			{
				displayName="Artillery Markers";
				description="Enables artillery markers for fire missions.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_SecTasks
			{
				displayName="Objective Status Tasks";
				description="Enables tasks added to all groups that inform players about the ownership/status of objectives. NOTE: May cause an error. It is a bug on BI's side linked to a task function for groups and can be ignored.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_Debug
			{
				displayName="Debug";
				description="Enables debug mode for the commander.";
				typeName="BOOL";
				defaultValue = "False";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Sets settings for the synchronized commander module.";
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

	class GVAR(Leader_BehSettings_Module): Module_F
	{
		scope=2;
		displayName="Commander Behaviour Settings";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(leader);
		function= QFUNC(leaderBehaviourSettings);
		icon = QPATHTOF(icons\HALCOSETBEHPIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_Smoke
			{
				displayName="Smoke For Retreat";
				description="Squads will use smoke grenades or request smoke shells to cover their retreat.";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_Flare
			{
				displayName="Flares On Enemies";
				description="Squads will use flares or request flare shells to mark or exposed enemies (At night).";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_GarrVehAb
			{
				displayName="Garr Disembark (only Stock)";
				description="Makes garrisoned squads disembark their vehicle when using the stock garrison mode (not compatible with NR6 Sites mode).";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_IdleOrd
			{
				displayName="Idle Orders";
				description="Squads will wander and patrol around their position when waiting for orders";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_IdleDef
			{
				displayName="Patrol Orders";
				description="When used with Idle Orders, squads will patrol between captured objectives instead of idling when waiting for orders";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_Flee
			{
				displayName="Fleeing Behaviour";
				description="Enables fleeing for overwhelmed squads";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_Surr
			{
				displayName="Surrender Behaviour";
				description="Enables surrendering for overwhelmed squads";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_Muu
			{
				displayName="Morale Coefficient";
				description="Coefficient of how much morale is affected by events on the battlefield. The higher this is, the more likely troops will stop fighting.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_Rush
			{
				displayName="Rush Mode";
				description="Squads will always run to their objectives (even in patrols).";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_Withdraw
			{
				displayName="Withdrawal Coefficient";
				description="Coefficient of how likely troops will be withdrawn. The higher this is, the more likely troops will run.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_AirDist
			{
				displayName="Max Air Asset Dist";
				description="Idle air assets beyond this distance from their starting position will return to that position. Useful for planes running away from the map when not issued any waypoints.";
				typeName="NUMBER";
				defaultValue = "4000";
			};
			class RydHQ_DynForm
			{
				displayName="Dynamic Formations";
				description="Squads will change their formation according to the situation (Updated every minute).";
				typeName="BOOL";
				defaultValue = "True";
			};

			class RydHQ_DefRange
			{
				displayName="Defend Position Radius Mult";
				description="Multiplier for how far from the defense point defense orders will be assigned. Useful for keeping a tight defensive formation or opening it up.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_GarrRange
			{
				displayName="Garrison Radius Mult";
				description="Multiplier for how far garrisonned squads will look around for buildings and static weapons from their garrison point.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_AttInfDistance
			{
				displayName="Inf Attack Radius Mult";
				description="Multiplier for how far from the target's position the initial waypoint will be placed during infantry attack orders.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_AttArmDistance
			{
				displayName="Armor Attack Radius Mult";
				description="Multiplier for how far from the target's position the initial waypoint will be placed during armor attack orders.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_AttSnpDistance
			{
				displayName="Sniper Attack Radius Mult";
				description="Multiplier for how far from the target's position the initial waypoint will be placed during sniper attack orders.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_FlankDistance
			{
				displayName="Flanking Radius Mult";
				description="Multiplier for how far from the target's position the initial waypoint will be placed during flanking attack orders.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_AttSFDistance
			{
				displayName="Specops Attack Radius Mult";
				description="Multiplier for how far from the target's position the initial waypoint will be placed during specops attack orders.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_ReconDistance
			{
				displayName="Recon Radius Mult";
				description="Multiplier for how far from the recon position the initial waypoint will be placed during recon orders.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_CaptureDistance
			{
				displayName="Capture Radius Mult";
				description="Multiplier for how far from the objective's position the initial waypoint will be placed during capture orders.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_UAVAlt
			{
				displayName="UAV Deploy Altitude";
				description="Altitude at which carried UAVs will fly during recon orders. Set to 0 to disable.";
				typeName="NUMBER";
				defaultValue = "150";
			};
			class RydHQ_Combining
			{
				displayName="Exhausted Squads Combine";
				description="Enables withdrawing or disabled squads to join forces with other squads to continue fighting. WIP setting.";
				typeName="BOOL";
				defaultValue = "False";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Sets behaviour settings for the synchronized commander module";
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

	class GVAR(Leader_PersSettings_Module): Module_F
	{
		scope=2;
		displayName="Commander Personality Settings";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(leader);
		function= QFUNC(leaderPersonalitySettings);
		icon = QPATHTOF(icons\HALCOSETPERSPIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_MAtt
			{
				displayName="Manual Personality";
				description="";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_Personality
			{
				displayName="Select Personality";
				description="Squads will use flares or request flare shells to mark or expose enemies (At night).";
				typeName="STRING";
				class values
				{
					class A
					{
						name="Ideal";
						value="GENIUS";
					};
					class B
					{
						name="Worst";
						value="IDIOT";
					};
					class C
					{
						name="Chaotic";
						value="CHAOTIC";
					};
					class D
					{
						name="Competent";
						value="COMPETENT";
						default=1;
					};
					class E
					{
						name="Eager";
						value="EAGER";
					};
					class F
					{
						name="Hesitant";
						value="DILATORY";
					};
					class G
					{
						name="Schemer";
						value="SCHEMER";
					};
					class H
					{
						name="Aggressive";
						value="BRUTE";
					};
					class I
					{
						name="Randomized Values";
						value="OTHER";
					};
				};
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Sets behaviour settings for the synchronized commander module";
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

	class GVAR(Leader_SupSettings_Module): Module_F
	{
		scope=2;
		displayName="Commander Support Settings";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(leader);
		function= QFUNC(leaderSupportSettings);
		icon = QPATHTOF(icons\HAL_COSETSUP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_CargoFind
			{
				displayName="Cargo Find Range";
				description="Range around an infantry squad within which the squad will look for a transport vehicle. If no vehicle is found, commander will try to provide a lift for the squad. To only use commander dispatched lifts, set to a very small value. Set to 0 to disable.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_NoAirCargo
			{
				displayName="Disable Air Cargo";
				description="Disable aerial transportation.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_NoLandCargo
			{
				displayName="Disable Land Cargo";
				description="Disable ground transportation.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_SMed
			{
				displayName="Medical Support";
				description="Controlled groups will receive medical support (See magic workaround in HAL general settings for usage with ACE).";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_SFuel
			{
				displayName="Fuel Support";
				description="Controlled groups will receive refueling support (See magic workaround in HAL general settings for usage with ACE).";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_SAmmo
			{
				displayName="Ammo Support";
				description="Controlled groups will receive rearming support (See magic workaround in HAL general settings for usage with ACE).";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_SRep
			{
				displayName="Repair Support";
				description="Controlled groups will receive repairing support (See magic workaround in HAL general settings for usage with ACE).";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_SupportWP
			{
				displayName="Support Waypoints";
				description="Support orders will use support waypoints.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_ArtyShells
			{
				displayName="Arty Ord Coef";
				description="Coefficient of how many shells should be dropped every round.";
				typeName="NUMBER";
				defaultValue = "1";
			};
			class RydHQ_AirEvac
			{
				displayName="Air Evac";
				description="Enables retreat orders to use air evac.";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_SupportRTB
			{
				displayName="Support RTB";
				description="Makes support vehicles/groups return to their strating point uppon completion of their mission";
				typeName="BOOL";
				defaultValue = "True";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Sets support settings for the synchronized commander module";
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

	class GVAR(Leader_ObjSettings_Module): Module_F
	{
		scope=2;
		displayName="Commander Objectives Settings";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(leader);
		function= QFUNC(leaderObjectivesSettings);
		icon = QPATHTOF(icons\HALCOSETOBJPIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_Order
			{
				displayName="Forced Defense Mode";
				description="Commander will never go into offensive mode.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_Berserk
			{
				displayName="Forced Attack Mode";
				description="Commander will never go into defensive mode.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_SimpleMode
			{
				displayName="Simple Mode";
				description="Default mode. Activates simple mode and disables the old HAL 4 objectives system.";
				typeName="BOOL";
				defaultValue = "True";
			};
			class RydHQ_UnlimitedCapt
			{
				displayName="Never Capture";
				description="Commander will keep sending troops to an objective and it will never be considered captured.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_CaptLimit
			{
				displayName="Capture Strength";
				description="Number of units that must be at the objective to capture it.";
				typeName="NUMBER";
				defaultValue = "10";
			};
			class RydHQ_GarrR
			{
				displayName="Garrison Attack Range";
				description="How far can attack orders be isued for a garrisoned squad.";
				typeName="NUMBER";
				defaultValue = "500";
			};
			class RydHQ_ObjHoldTime
			{
				displayName="Time To Capture Objective";
				description="Capture orders will stay active for squads this long after they have reached the objective.";
				typeName="NUMBER";
				defaultValue = "60";
			};
			class RydHQ_ObjRadius1
			{
				displayName="Friendly Capture Radius";
				description="Friendly forces must be within this radius from an objective to capture it.";
				typeName="NUMBER";
				defaultValue = "300";
			};
			class RydHQ_ObjRadius2
			{
				displayName="Enemy Capture Radius";
				description="Enemy forces must be within this radius from an objective for the commander to consider it lost.";
				typeName="NUMBER";
				defaultValue = "500";
			};
			class RydHQ_LRelocating
			{
				displayName="Relocating Commander";
				description="Commander will move to the latest captured objective each time. Only works in legacy mode.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_NoRec
			{
				displayName="Chance Skip Recon";
				description="Chance to skip recon stage for capturing objectives on each cycle. Percentage affected by leader personality. Set well above 100 to guarantee skipping (like 1000)";
				typeName="NUMBER";
				defaultValue = "10";
			};
			class RydHQ_RapidCapt
			{
				displayName="Chance Fast Capture";
				description="Chance for the commander to focus on capturing objectives instead of engaging hostiles on each cycle. Percentage affected by leader personality. Set well above 100.";
				typeName="NUMBER";
				defaultValue = "10";
			};
			class RydHQ_DefendObjectives
			{
				displayName="Def Ownership Size";
				description="Sets how many squads must be around an objective for the commander to consider it a defensive point. Only works in legacy mode.";
				typeName="NUMBER";
				defaultValue = "4";
			};
			class RydHQ_ReconReserve
			{
				displayName="Recon Reserve Ratio";
				description="Coefficient of how many squads will be reserved for recon. Choose a number from 0 to 1.";
				typeName="NUMBER";
			};
			class RydHQ_AttackReserve
			{
				displayName="Att Reserve Ratio";
				description="Coefficient of how many squads will be reserved for advanced attack orders like flanking orders. Choose a number from 0 to 1.";
				typeName="NUMBER";
			};
			class RydHQ_CRDefRes
			{
				displayName="Def Reserve Ratio";
				description="Coefficient of how many squads will be reserved for advanced defend orders like patrol orders. Choose a number from 0 to 1.";
				typeName="NUMBER";
				defaultValue = "0.4";
			};
			class RydHQ_AAO
			{
				displayName="All At Once";
				description="Will allow commander to capture objectives all at once and out of order.  Only works in legacy mode.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_ForceAAO
			{
				displayName="Force AAO";
				description="Will force the commander to capture objectives all at once.  Only works in legacy mode.";
				typeName="BOOL";
				defaultValue = "False";
			};
			class RydHQ_BBAOObj
			{
				displayName="Objectives At Once (HC mode)";
				description="Set the max number of objectives to capture at once.  Only works in high-command + legacy mode.";
				typeName="NUMBER";
				defaultValue = "4";
			};
			class RydHQ_MaxSimpleObjs
			{
				displayName="Objectives At Once (Simple mode)";
				description="Set the max number of objectives to capture at once in simple mode.";
				typeName="NUMBER";
				defaultValue = "5";
			};
			class RydHQ_ObjectiveRespawn
			{
				displayName="Create Objective Player Respawn Points";
				description="Creates a player respawn position for every taken objective.";
				typeName="BOOL";
				defaultValue = "False";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Sets objective settings for the synchronized commander module";
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

	class GVAR(Leader_IdleDecoy_Module): Module_F
	{
		scope=2;
		displayName="Idle Rally Point";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(utilities);
		function= QFUNC(idleDecoy);
		icon = QPATHTOF(icons\HAL_COIDLE_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_IDChance
			{
				displayName="Chance Of Rally (%)";
				description="Chance that an idle squad will use this position as a rally point.";
				typeName="NUMBER";
				defaultValue = "True";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Sets rally point for the synchronized commander module";
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
	class GVAR(Leader_WithdrawDecoy_Module): Module_F
	{
		scope=2;
		displayName="Withdrawal Rally Point";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(utilities);
		function=QFUNC(restDecoy);
		icon = QPATHTOF(icons\HAL_CORETREAT_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_RDChance
			{
				displayName="Chance Of Rally (%)";
				description="Chance that a retreating squad will use this position as a rally point.";
				typeName="NUMBER";
				defaultValue = "True";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Sets rally point for the synchronized commander module";
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
	class GVAR(Leader_SuppDecoy_Module): Module_F
	{
		scope=2;
		displayName="Supports Rally Point";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(utilities);
		function = QFUNC(SuppDecoy);
		icon = QPATHTOF(icons\HAL_COSUPPORT_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_SDChance
			{
				displayName="Chance Of Rally (%)";
				description="Chance that a support squad will use this position as a rally point (%).";
				typeName="NUMBER";
				defaultValue = "True";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Sets rally point for the synchronized commander module";
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

	class GVAR(Leader_Front_Module): Module_F
	{
		scope=2;
		displayName="Commander Front";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(utilities);
		function= QFUNC(front);
		icon = QPATHTOF(icons\HAL_COFRONT_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		canSetArea=1;
		class AttributeValues
		{
			size3[]={500,500,-1};
			IsRectangle=0;
		};
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_Front
			{
				displayName="Enable Front";
				description="Enables the usage of a limited area of operations for a commander. This module will serve as the front area.";
				typeName="BOOL";
				defaultValue = "True";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Sets objective settings for the synchronized commander module";
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


	class GVAR(Leader_Objective_Module): Module_F
	{
		scope=2;
		displayName="Objective (Legacy Mode)";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(objectives);
		function = QFUNC(objective);
		icon = QPATHTOF(icons\HAL_OBJLEG_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class ObjType
			{
				displayName="Objective";
				description="Sets which legacy HAL objective this module will represent.";
				typeName="STRING";
				class values
				{
					class Obj1
					{
						name="Objective 1";
						value="Obj1";
						default=1;
					};
					class Obj2
					{
						name="Objective 2";
						value="Obj2";
					};
					class Obj3
					{
						name="Objective 3";
						value="Obj3";
					};
					class Obj4
					{
						name="Objective 4";
						value="Obj4";
					};
				};
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Adds an objective for the synchronized commander module";
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

	class GVAR(Leader_SimpleObjective_Module): Module_F
	{
		scope=2;
		displayName="Objective (Simple Mode)";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(objectives);
		function= QFUNC(simpleObjective);
		icon = QPATHTOF(icons\HAL_OBJMOD_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_TakenLeader
			{
				displayName="Set Taken By Commander";
				description="Selects which AI leader will consider this objective as taken.";
				typeName="STRING";
				class values
				{
					class None
					{
						name="None";
						value="";
						default=1;
					};
					class A
					{
						name="Leader A";
						value="LeaderHQ";
					};
					class B
					{
						name="Leader B";
						value="LeaderHQB";
					};
					class C
					{
						name="Leader C";
						value="LeaderHQC";
					};
					class D
					{
						name="Leader D";
						value="LeaderHQD";
					};
					class E
					{
						name="Leader E";
						value="LeaderHQE";
					};
					class F
					{
						name="Leader F";
						value="LeaderHQF";
					};
					class G
					{
						name="Leader G";
						value="LeaderHQG";
					};
					class H
					{
						name="Leader H";
						value="LeaderHQH";
					};
				};
			};
			class PatrolPoint
			{
				displayName="Set As Patrol Point";
				description="Objective will never be lost and defense will be passive. Used to create a point for patrols in defense mode. Use in conjunction with ""Set Taken By Commander""";
				typeName="BOOL";
				defaultValue = "False";
			};
			class _ObjName
			{
				displayName="Set Objective Title";
				description="Name that will be given to the objective for status tasks.";
				typeName="STRING";
			};
			class objvalue
			{
				displayName="Set Value (1 to 10)";
				description="Sets the value/priority of the objective. Use a number from 1 to 10";
				typeName="NUMBER";
				defaultValue = "5";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Adds an objective for the synchronized commander module";
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

	class GVAR(Leader_NavalObjective_Module): Module_F
	{
		scope=2;
		displayName="Naval Objective (Simple Mode)";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(objectives);
		function= QFUNC(navalObjective);
		icon = QPATHTOF(icons\HAL_OBJMOD_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydHQ_TakenLeader
			{
				displayName="Set Taken By Commander";
				description="Selects which AI leader will consider this objective as taken.";
				typeName="STRING";
				class values
				{
					class None
					{
						name="None";
						value="";
						default=1;
					};
					class A
					{
						name="Leader A";
						value="LeaderHQ";
					};
					class B
					{
						name="Leader B";
						value="LeaderHQB";
					};
					class C
					{
						name="Leader C";
						value="LeaderHQC";
					};
					class D
					{
						name="Leader D";
						value="LeaderHQD";
					};
					class E
					{
						name="Leader E";
						value="LeaderHQE";
					};
					class F
					{
						name="Leader F";
						value="LeaderHQF";
					};
					class G
					{
						name="Leader G";
						value="LeaderHQG";
					};
					class H
					{
						name="Leader H";
						value="LeaderHQH";
					};
				};
			};
			class PatrolPoint
			{
				displayName="Set As Patrol Point";
				description="Objective will never be lost and defense will be passive. Used to create a point for patrols in defense mode. Use in conjunction with ""Set Taken By Commander""";
				typeName="BOOL";
				defaultValue = "False";
			};
			class _ObjName
			{
				displayName="Set Objective Title";
				description="Name that will be given to the objective for status tasks.";
				typeName="STRING";
			};
			class objvalue
			{
				displayName="Set Value (1 to 10)";
				description="Sets the value/priority of the objective. Use a number from 1 to 10";
				typeName="NUMBER";
				defaultValue = "5";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Adds an objective for the synchronized commander module";
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

	class GVAR(Leader_AmmoDepot_Module): Module_F
	{
		scope=2;
		displayName="Ammo Drop Ammo Depot";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(leader);
		function= QFUNC(ammoDepot);
		icon = QPATHTOF(icons\HAL_COAMMO_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		canSetArea=1;
		class AttributeValues
		{
			size3[]={50,50,-1};
			IsRectangle=0;
		};
		class Arguments: ArgumentsBaseUnits
		{
			class VirtualBoxes
			{
				displayName="Virtual Boxes";
				description="Hides and disables simulation on ammo boxes to make them only appear when para dropped. Useful when a ammo depot location is impossible to place (for example at sea). Works only for synced boxes.";
				typeName="BOOL";
				defaultValue = "False";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Adds a zone in which all ammo boxes will be used for ammo drops for the synchronized commander module. Module may also be directly synced to the ammo boxes in which case the zone will be ignored and only the synced boxes will be considered.";
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

	class GVAR(Leader_Include_Module): Module_F
	{
		scope=2;
		displayName="Include Squads";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(leader);
		function= QFUNC(include);
		icon = QPATHTOF(icons\HAL_COCONT_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of controlled squads for the synchronized commander module";
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

	class GVAR(Leader_Exclude_Module): Module_F
	{
		scope=2;
		displayName="Exclude Squads";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(leader);
		function= QFUNC(exclude);
		icon = QPATHTOF(icons\HAL_COEXCL_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of non-controlled squads for the synchronized commander module";
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

//Squad Properties Modules

	class GVAR(Squad_AmmoDrop_Module): Module_F
	{
		scope=2;
		displayName="Ammo Drop";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function = QFUNC(ammoDrop);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_AOnly_Module): Module_F
	{
		scope=2;
		displayName="Attack Only";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(aOnly);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_CargoOnly_Module): Module_F
	{
		scope=2;
		displayName="Transport Only";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(cargoOnly);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_ROnly_Module): Module_F
	{
		scope=2;
		displayName="Recon Only";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(ROnly);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_ExReammo_Module): Module_F
	{
		scope=2;
		displayName="Never Request Ammo";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function=QFUNC(exReammo);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_ExMedic_Module): Module_F
	{
		scope=2;
		displayName="Never Request Medic";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(exMedic);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_ExRefuel_Module): Module_F
	{
		scope=2;
		displayName="Never Request Fuel";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(exRefuel);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_FirstToFight_Module): Module_F
	{
		scope=2;
		displayName="First To Fight";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(firstToFight);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_RTBRRR_Module): Module_F
	{
		scope=2;
		displayName="Vehicles RTB Refuel/Rearm/Repair";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(attributes);
		function= QFUNC(RTBRRR);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad's vehicles get rearmed/refueled/repaired when they RTB. (Only applies to missions that have an RTB stage). Works on Air Reinforcements modules.";
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

	class GVAR(Squad_ExRepair_Module): Module_F
	{
		scope=2;
		displayName="Never Request Repairs";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function = QFUNC(ExRepair);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_Garrison_Module): Module_F
	{
		scope=2;
		displayName="Set Garrison";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(garrison);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_NoAttack_Module): Module_F
	{
		scope=2;
		displayName="No Attack Orders";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(noAttack);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_NoCargo_Module): Module_F
	{
		scope=2;
		displayName="No Transport Requests";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(noCargo);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_NoDef_Module): Module_F
	{
		scope=2;
		displayName="No Defense Orders";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(noDef);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_NoReports_Module): Module_F
	{
		scope=2;
		displayName="No Enemy Contact Reports";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(noReports);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_Unable_Module): Module_F
	{
		scope=2;
		displayName="Disable Tasking";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(unable);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_NoRecon_Module): Module_F
	{
		scope=2;
		displayName="No Recon Orders";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function = QFUNC(noRecon);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_NoFlank_Module): Module_F
	{
		scope=2;
		displayName="No Flanking Orders";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(noFlank);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_SFBodyGuard_Module): Module_F
	{
		scope=2;
		displayName="Set As HQ Bodyguard";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(sfBodyGuard);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad members will have their squad added to the list of squads affected by the property for the synchronized commander module";
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

	class GVAR(Squad_AlwaysKnownU_Module): Module_F
	{
		scope=2;
		displayName="Always Known Enemy";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function = QFUNC(alwaysKnownU);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized unit will always be known to the commander of the synchronized commander module";
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

	class GVAR(Squad_AlwaysUnKnownU_Module): Module_F
	{
		scope=2;
		displayName="Always Unknown Enemy";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(alwaysUnKnownU);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized unit will always be unknown to the commander of the synchronized commander module";
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

	class GVAR(Squad_RCAS_Module): Module_F
	{
		scope=2;
		displayName="Assign Close Air Support";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(setRoleCAS);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad will be used for CAS";
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

	class GVAR(Squad_RCAP_Module): Module_F
	{
		scope=2;
		displayName="Assign Combat Air Patrol";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(squad);
		function= QFUNC(setRoleCAP);
		icon = QPATHTOF(icons\HAL_SQDPRP_PIN.paa);
		functionPriority=2;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
		};
		class ModuleDescription: ModuleDescription
		{
			description="Synchronized squad will be used for CAP";
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

//Big Boss Modules

	class GVAR(BBLeader_Module): Module_F
	{
		scope=2;
		displayName="High Commander";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(BB);
		function= QFUNC(bbLeader);
		icon = QPATHTOF(icons\HAL_HCCO_PIN.paa);
		functionPriority=1;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class BBLeader
			{
				displayName="Commander Selection";
				description="Set which High-Commander this module will represent.";
				typeName="STRING";
				class values
				{
					class A
					{
						name="High Commander A";
						value="RydBBa_SAL";
						default=1;
					};
					class B
					{
						name="High Commander B";
						value="RydBBb_SAL";
					};
				};
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Creates a new high commander.";
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

	class GVAR(BBSettings_Module): Module_F
	{
		scope=2;
		displayName="High Commander Settings";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(BB);
		function= QFUNC(bbSettings);
		icon = QPATHTOF(icons\HAL_HCCOSET_PIN.paa);
		functionPriority=1;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=1;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class RydBB_CustomObjOnly
			{
				displayName="No Auto Objectives";
				description="HC will only consider user placed objectives instead of scanning the map for strategic locations.";
				typeName="BOOL";
				defaultValue="True";
			};
			class RydBB_LRelocating
			{
				displayName="Commanders Relocate";
				description="HC controlled conmmanders will relocate to objectives recently captured. This is used for HC mode as the legacy relocation works differently.";
				typeName="BOOL";
				defaultValue="False";
			};
			class RydBB_MainInterval
			{
				displayName="HC Cycle (Minutes)";
				description="Delay between HC computation cycles.";
				typeName="NUMBER";
				defaultValue="5";
			};
			/*
			class RydBB_BBOnMap
			{
				displayName="Non-Virtual HC";
				description="";
				typeName="BOOL";
				defaultValue="False";
			};
			*/
		};
		class ModuleDescription: ModuleDescription
		{
			description="Sets settings for the synchronized high commander module";
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

	class GVAR(BBZone_Module): Module_F
	{
		scope=2;
		displayName="High Commander Zone";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(BB);
		function= QFUNC(bbZone);
		icon = QPATHTOF(icons\HAL_HCZONE_PIN.paa);
		functionPriority=1;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		canSetArea=1;
		class AttributeValues
		{
			size3[]={1500,1500,-1};
			IsRectangle=1;
		};
		class Arguments: ArgumentsBaseUnits
		{

		};
		class ModuleDescription: ModuleDescription
		{
			description="If custom objectives are not enforced, High-Command/Big-Boss mode will only scan the map within this zone for additional objectives.";
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

	class GVAR(BBLeader_Objective_Module): Module_F
	{
		scope=2;
		displayName="High Commander Objective";
		author="NinjaRider600";
		vehicleClass="Modules";
		category=QGVAR(BB);
		function= QFUNC(bbObjective);
		icon = QPATHTOF(icons\HAL_OBJHC_PIN.paa);
		functionPriority=1;
		isGlobal=0;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		class Arguments: ArgumentsBaseUnits
		{
			class AreaValue
			{
				displayName="Value (0-10)";
				description="Importance of the objective used for priority calculations";
				typeName="NUMBER";
				defaultValue = "5";
			};
			class Owned
			{
				displayName="Ownership";
				description=" Which HC will have taken the objecctive at mission start.";
				typeName="STRING";
				class values
				{
					class A
					{
						name="High Commander A";
						value="A";
					};
					class B
					{
						name="High Commander B";
						value="B";
					};
					class C
					{
						name="None";
						value="None";
						default=1;
					};
				};
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Adds an objective for the synchronized high commander module";
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
