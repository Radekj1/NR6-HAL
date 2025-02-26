class CfgPatches
{
	class NR6_HAL
	{
		author="NinjaRider600";
		name="NR6_HAL";
		units[]=
		{
			"NR6_HAL_Core_Module",
			"NR6_HAL_Leader_Module",
			"NR6_HAL_Leader_Settings_Module",
			"NR6_HAL_GenSettings_Module",
			"NR6_HAL_Leader_BehSettings_Module",
			"NR6_HAL_Objective_Module",
			"NR6_HAL_BBObjective_Module",
			"NR6_HAL_BBLeader_Module",
			"NR6_HAL_Front_Module"
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

class CfgFunctions
{
	class NR6
	{
		class Modules
		{
			class HALcore
			{
				description="HAL Start";
				file="\NR6_HAL\RydHQInit.sqf";
			};
			class HALGenset
			{
				description="Set general settings for HAL using a module.";
				file="\NR6_HAL\Modules\GeneralSettings.sqf";
			};
			class HALLead
			{
				description="Adds a HAL leader using a module.";
				file="\NR6_HAL\Modules\AddLeader.sqf";
			};
			class HALLeadset
			{
				description="Commander settings module.";
				file="\NR6_HAL\Modules\LeaderSettings.sqf";
			};
			class HALLeadBeh
			{
				description="Commander settings module.";
				file="\NR6_HAL\Modules\LeaderBehaviourSettings.sqf";
			};
			class HALLeadPers
			{
				description="Commander settings module.";
				file="\NR6_HAL\Modules\LeaderPersonalitySettings.sqf";
			};
			class HALLeadSup
			{
				description="Commander settings module.";
				file="\NR6_HAL\Modules\LeaderSupportSettings.sqf";
			};
			class HALLeadObj
			{
				description="Commander settings module.";
				file="\NR6_HAL\Modules\LeaderObjectivesSettings.sqf";
			};
			class HALObj
			{
				description="Commander objective module.";
				file="\NR6_HAL\Modules\Objective.sqf";
			};
			class HALSObj
			{
				description="Commander objective module.";
				file="\NR6_HAL\Modules\SimpleObjective.sqf";
			};
			class HALNObj
			{
				description="Commander objective module.";
				file="\NR6_HAL\Modules\NavalObjective.sqf";
			};
			class HALBBObj
			{
				description="";
				file="\NR6_HAL\Modules\BBObjective.sqf";
			};
			class HALBB
			{
				description="";
				file="\NR6_HAL\Modules\BBLeader.sqf";
			};
			class HALBBZone
			{
				description="";
				file="\NR6_HAL\Modules\BBZone.sqf";
			};
			class HALAmmoDepot
			{
				description="";
				file="\NR6_HAL\Modules\AmmoDepot.sqf";
			};
			class HALBBSet
			{
				description="";
				file="\NR6_HAL\Modules\BBSettings.sqf";
			};
			class HALExclude
			{
				description="";
				file="\NR6_HAL\Modules\Exclude.sqf";
			};
			class HALFront
			{
				description="";
				file="\NR6_HAL\Modules\Front.sqf";
			};
			class HALIdleDecoy
			{
				description="";
				file="\NR6_HAL\Modules\IdleDecoy.sqf";
			};
			class HALInclude
			{
				description="";
				file="\NR6_HAL\Modules\Include.sqf";
			};
			class HALRestDecoy
			{
				description="";
				file="\NR6_HAL\Modules\RestDecoy.sqf";
			};
			class HALSuppDecoy
			{
				description="";
				file="\NR6_HAL\Modules\SuppDecoy.sqf";
			};
			class AmmoDrop
			{
				description="";
				file="\NR6_HAL\Modules\AmmoDrop.sqf";
			};
			class AlwaysKnownU
			{
				description="";
				file="\NR6_HAL\Modules\AlwaysKnownU.sqf";
			};
			class AOnly
			{
				description="";
				file="\NR6_HAL\Modules\AOnly.sqf";
			};
			class CargoOnly
			{
				description="";
				file="\NR6_HAL\Modules\CargoOnly.sqf";
			};
			class ExReammo
			{
				description="";
				file="\NR6_HAL\Modules\ExReammo.sqf";
			};
			class ExMedic
			{
				description="";
				file="\NR6_HAL\Modules\ExMedic.sqf";
			};
			class AlwaysUnKnownU
			{
				description="";
				file="\NR6_HAL\Modules\AlwaysUnKnownU.sqf";
			};
			class ExRefuel
			{
				description="";
				file="\NR6_HAL\Modules\ExRefuel.sqf";
			};
			class FirstToFight
			{
				description="";
				file="\NR6_HAL\Modules\FirstToFight.sqf";
			};
			class RTBRRR
			{
				description="";
				file="\NR6_HAL\Modules\RTBRRR.sqf";
			};
			class ExRepair
			{
				description="";
				file="\NR6_HAL\Modules\ExRepair.sqf";
			};
			class Garrison
			{
				description="";
				file="\NR6_HAL\Modules\Garrison.sqf";
			};
			class NoAttack
			{
				description="";
				file="\NR6_HAL\Modules\NoAttack.sqf";
			};
			class NoCargo
			{
				description="";
				file="\NR6_HAL\Modules\NoCargo.sqf";
			};
			class NoDef
			{
				description="";
				file="\NR6_HAL\Modules\NoDef.sqf";
			};
			class NoRecon
			{
				description="";
				file="\NR6_HAL\Modules\NoRecon.sqf";
			};
			class NoReports
			{
				description="";
				file="\NR6_HAL\Modules\NoReports.sqf";
			};
			class NoFlank
			{
				description="";
				file="\NR6_HAL\Modules\NoFlank.sqf";
			};
			class ROnly
			{
				description="";
				file="\NR6_HAL\Modules\ROnly.sqf";
			};
			class SFBodyGuard
			{
				description="";
				file="\NR6_HAL\Modules\SFBodyGuard.sqf";
			};
			class Unable
			{
				description="";
				file="\NR6_HAL\Modules\Unable.sqf";
			};
			class RCAS
			{
				description="";
				file="\NR6_HAL\Modules\SetRoleCAS.sqf";
			};
			class RCAP
			{
				description="";
				file="\NR6_HAL\Modules\SetRoleCAP.sqf";
			};
		};
	};
};

class CfgRadio
	{
	sounds[] = {};
	class HAC_OrdConf1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdConf1v1.ogg", 1, 1};
		title = "Roger that - Out.";
		};

	class HAC_OrdConf2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdConf2v1.ogg", 1, 1};
		title = "Affirmative - Out.";
		};

	class HAC_OrdConf3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Acknowledged - Out.";
		};

	class HAC_OrdConf4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdConf4v1.ogg", 1, 1};
		title = "On it - Out.";
		};

	class HAC_OrdConf5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdConf5v1.ogg", 1, 1};
		title = "Command, executing orders - Out.";
		};


	class HAC_OrdDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdDen1v1.ogg", 1, 1};
		title = "Can't do it - Over.";
		};

	class HAC_OrdDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdDen2v1.ogg", 1, 1};
		title = "Not possible - Over.";
		};

	class HAC_OrdDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdDen3v1.ogg", 1, 1};
		title = "Negative - Over.";
		};

	class HAC_OrdDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdDen4v1.ogg", 1, 1};
		title = "Impossible - Over.";
		};

	class HAC_OrdDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdDen5v1.ogg", 1, 1};
		title = "Command, I cannot comply. Requesting new orders - Over.";
		};


	class HAC_OrdFinal1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdFinal1v1.ogg", 1, 1};
		title = "Approaching objective - Out.";
		};

	class HAC_OrdFinal2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdFinal2v1.ogg", 1, 1};
		title = "We're close to the objective - Out.";
		};

	class HAC_OrdFinal3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdFinal3v1.ogg", 1, 1};
		title = "In position - Out.";
		};

	class HAC_OrdFinal4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdFinal4v1.ogg", 1, 1};
		title = "We're proceeding to the objective - Out.";
		};


	class HAC_OrdEnd1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdEnd1v1.ogg", 1, 1};
		title = "Waiting for orders - Over.";
		};

	class HAC_OrdEnd2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdEnd2v1.ogg", 1, 1};
		title = "Task complete - Over.";
		};

	class HAC_OrdEnd3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdEnd3v1.ogg", 1, 1};
		title = "We're done here - Over.";
		};

	class HAC_OrdEnd4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdEnd4v1.ogg", 1, 1};
		title = "Mission objective completed - Over.";
		};

	class HAC_OrdEnd5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OrdEnd5v1.ogg", 1, 1};
		title = "Command, we're awaiting orders - Over.";
		};


	class HAC_SuppReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppReq1v1.ogg", 1, 1};
		title = "We need supplies - Over.";
		};

	class HAC_SuppReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppReq2v1.ogg", 1, 1};
		title = "Request logistical support - Over.";
		};

	class HAC_SuppReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppReq3v1.ogg", 1, 1};
		title = "We could use some supplies - Over.";
		};

	class HAC_SuppReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppReq4v1.ogg", 1, 1};
		title = "Our supplies are low - Over.";
		};

	class HAC_SuppReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppReq5v1.ogg", 1, 1};
		title = "Command, requesting support - Over.";
		};



	class HAC_MedReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\MedReq1v1.ogg", 1, 1};
		title = "We need a Medevac! - Over.";
		};

	class HAC_MedReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\MedReq2v1.ogg", 1, 1};
		title = "Requesting Medevac - Over.";
		};

	class HAC_MedReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\MedReq3v1.ogg", 1, 1};
		title = "We need immediate Medevac - Over.";
		};

	class HAC_MedReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\MedReq4v1.ogg", 1, 1};
		title = "We need medical support - Over.";
		};

	class HAC_MedReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\MedReq5v1.ogg", 1, 1};
		title = "Command, requesting medevac - Over.";
		};



	class HAC_ArtyReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtyReq1v1.ogg", 1, 1};
		title = "Requesting fire mission on transmitted coordinates - Over.";
		};

	class HAC_ArtyReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtyReq2v1.ogg", 1, 1};
		title = "We need artillery on target position - Over.";
		};

	class HAC_ArtyReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtyReq3v1.ogg", 1, 1};
		title = "Give us some fire support!";
		};

	class HAC_ArtyReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtyReq4v1.ogg", 1, 1};
		title = "A few artillery shells would be appreciated here - Over.";
		};

	class HAC_ArtyReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtyReq5v1.ogg", 1, 1};
		title = "Command, requesting fire mission on target coordinates - Over.";
		};



	class HAC_SmokeReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SmokeReq1v1.ogg", 1, 1};
		title = "Requesting smoke cover for withdrawal - Over.";
		};

	class HAC_SmokeReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SmokeReq2v1.ogg", 1, 1};
		title = "Need smoke screen on our position - Over.";
		};

	class HAC_SmokeReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SmokeReq3v1.ogg", 1, 1};
		title = "We're falling back. Need smoke cover - Over.";
		};

	class HAC_SmokeReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SmokeReq4v1.ogg", 1, 1};
		title = "We need concealment. Requesting smoke - Over.";
		};


	class HAC_IllumReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\IllumReq1v1.ogg", 1, 1};
		title = "Enemy presence in the are. Requesting illumination - Over.";
		};

	class HAC_IllumReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\IllumReq2v1.ogg", 1, 1};
		title = "Illumination needed at our coordinates - Over.";
		};

	class HAC_IllumReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\IllumReq3v1.ogg", 1, 1};
		title = "Need illumination on our position - Over.";
		};

	class HAC_IllumReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\IllumReq4v1.ogg", 1, 1};
		title = "Some illumination rounds would be useful here - Over.";
		};

	class HAC_InDanger1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger1v1.ogg", 1, 1};
		title = "Incoming!";
		};

	class HAC_InDanger2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger2v1.ogg", 1, 1};
		title = "We're under fire!";
		};

	class HAC_InDanger3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger3v1.ogg", 1, 1};
		title = "Enemy is nearby!";
		};

	class HAC_InDanger4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger4v1.ogg", 1, 1};
		title = "We are taking fire!";
		};

	class HAC_InDanger5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger5v1.ogg", 1, 1};
		title = "We are pinned down!";
		};

	class HAC_InDanger6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger6v1.ogg", 1, 1};
		title = "Opening fire!";
		};

	class HAC_InDanger7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger7v1.ogg", 1, 1};
		title = "The enemy is approaching our position!";
		};

	class HAC_InDanger8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger8v1.ogg", 1, 1};
		title = "We are being flanked!";
		};

	class HAC_InDanger9
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger9v1.ogg", 1, 1};
		title = "We must stop them at any cost!";
		};

	class HAC_InDanger10
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger10v1.ogg", 1, 1};
		title = "Sending hell on them!";
		};

	class HAC_InDanger11
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger11v1.ogg", 1, 1};
		title = "Keep your heads down, dammit!";
		};

	class HAC_InDanger12
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger12v1.ogg", 1, 1};
		title = "Engaging at will!";
		};

	class HAC_InDanger13
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InDanger13v1.ogg", 1, 1};
		title = "Command, we're in danger - Over.";
		};



	class HAC_EnemySpot1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\EnemySpot1v1.ogg", 1, 1};
		title = "Enemy spotted - Over.";
		};

	class HAC_EnemySpot2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\EnemySpot2v1.ogg", 1, 1};
		title = "We're observing hostiles - Over.";
		};

	class HAC_EnemySpot3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\EnemySpot3v1.ogg", 1, 1};
		title = "Enemy forces at the designated coordinates - Over.";
		};

	class HAC_EnemySpot4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\EnemySpot4v1.ogg", 1, 1};
		title = "Hostile presence in the area - Over.";
		};

	class HAC_EnemySpot5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\EnemySpot5v1.ogg", 1, 1};
		title = "Command, hostiles spotted near our location - Over.";
		};


	class HAC_InFear1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InFear1v1.ogg", 1, 1};
		title = "We stand no chance!";
		};

	class HAC_InFear2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InFear2v1.ogg", 1, 1};
		title = "Regrouping!";
		};

	class HAC_InFear3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InFear3v1.ogg", 1, 1};
		title = "The enemy is overwhelming!";
		};

	class HAC_InFear4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InFear4v1.ogg", 1, 1};
		title = "There's too many of them!";
		};

	class HAC_InFear5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InFear5v1.ogg", 1, 1};
		title = "We are dying here!";
		};

	class HAC_InFear6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InFear6v1.ogg", 1, 1};
		title = "We're outnumbered!";
		};

	class HAC_InFear7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InFear7v1.ogg", 1, 1};
		title = "We need help!";
		};

	class HAC_InFear8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InFear8v1.ogg", 1, 1};
		title = "We can't hold this position!";
		};



	class HAC_InPanic1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InPanic1v1.ogg", 1, 1};
		title = "We're in hell!";
		};

	class HAC_InPanic2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InPanic2v1.ogg", 1, 1};
		title = "We have to run!";
		};

	class HAC_InPanic3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InPanic3v1.ogg", 1, 1};
		title = "We can't stay here anymore!";
		};

	class HAC_InPanic4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InPanic4v1.ogg", 1, 1};
		title = "We're out of here!";
		};

	class HAC_InPanic5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InPanic5v1.ogg", 1, 1};
		title = "We are going to die!";
		};

	class HAC_InPanic6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InPanic6v1.ogg", 1, 1};
		title = "We need to run!";
		};

	class HAC_InPanic7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InPanic7v1.ogg", 1, 1};
		title = "It's hopeless!";
		};

	class HAC_InPanic8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\InPanic8v1.ogg", 1, 1};
		title = "We're not dying here!";
		};


	class HAC_SuppAss1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppAss1v1.ogg", 1, 1};
		title = "Support on the way - Out.";
		};

	class HAC_SuppAss2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppAss2v1.ogg", 1, 1};
		title = "Support is inbound. Hold on - Out.";
		};

	class HAC_SuppAss3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppAss3v1.ogg", 1, 1};
		title = "Support is directed to your position - Out.";
		};

	class HAC_SuppAss4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppAss4v1.ogg", 1, 1};
		title = "Supplies en route - Out.";
		};

	class HAC_SuppAss5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppAss5v1.ogg", 1, 1};
		title = "Support en route to you - Out.";
		};



	class HAC_SuppDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppDen1v1.ogg", 1, 1};
		title = "Support not possible at the moment - Out.";
		};

	class HAC_SuppDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppDen2v1.ogg", 1, 1};
		title = "Negative, support is unavailable - Out.";
		};

	class HAC_SuppDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppDen3v1.ogg", 1, 1};
		title = "Support request denied - Out.";
		};

	class HAC_SuppDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppDen4v1.ogg", 1, 1};
		title = "Negative, we have no support available - Out.";
		};

	class HAC_SuppDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\SuppDen5v1.ogg", 1, 1};
		title = "Negative, request denied. Cannot provide support right now - Out.";
		};



	class HAC_ArtAss1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtAss1v1.ogg", 1, 1};
		title = "Artillery support inbound - Out.";
		};

	class HAC_ArtAss2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtAss2v1.ogg", 1, 1};
		title = "Prepare for artillery barrage - Out.";
		};

	class HAC_ArtAss3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtAss3v1.ogg", 1, 1};
		title = "Fire Mission accepted. Wait for the fireworks - Out.";
		};

	class HAC_ArtAss4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtAss4v1.ogg", 1, 1};
		title = "Preparing artillery fire mission. Dig in! - Out.";
		};

	class HAC_ArtAss5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtAss5v1.ogg", 1, 1};
		title = "Fire mission on designated coordinates - Out.";
		};


	class HAC_ArtDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtDen1v1.ogg", 1, 1};
		title = "Negative, we have no available artillery battery - Out.";
		};

	class HAC_ArtDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtDen2v1.ogg", 1, 1};
		title = "Fire mission impossible at this time - Out.";
		};

	class HAC_ArtDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtDen3v1.ogg", 1, 1};
		title = "Negative, all batteries are busy right now - Out.";
		};

	class HAC_ArtDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtDen4v1.ogg", 1, 1};
		title = "Fire mission request denied - Out.";
		};

	class HAC_ArtDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtDen5v1.ogg", 1, 1};
		title = "Negative, request denied. No fire missions are available - Out.";
		};


	class HAC_OffStance1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\OffStance1v1.ogg", 1, 1};
		title = "To all callsigns: Offensive formation in effect";
		};

	class HAC_DefStance1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\DefStance1v1.ogg", 1, 1};
		title = "To all callsigns: Deffensive formation in effect";
		};


	class HAC_ArtFire1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtFire1v1.ogg", 1, 1};
		title = "Firing for effect! - Out.";
		};

	class HAC_ArtFire2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtFire2v1.ogg", 1, 1};
		title = "Shells on the way! - Out.";
		};

	class HAC_ArtFire3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtFire3v1.ogg", 1, 1};
		title = "Fire mission in progress - Out.";
		};

	class HAC_ArtFire4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtFire4v1.ogg", 1, 1};
		title = "Shells away - Out.";
		};

	class HAC_ArtFire5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice1\ArtFire5v1.ogg", 1, 1};
		title = "Fire Mission on target location - Out.";
		};



	class v2HAC_OrdConf1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdConf1v2.ogg", 1, 1};
		title = "Roger that - Out.";
		};

	class v2HAC_OrdConf2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdConf2v2.ogg", 1, 1};
		title = "Affirmative - Out.";
		};

	class v2HAC_OrdConf3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Acknowledged - Out.";
		};

	class v2HAC_OrdConf4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdConf4v2.ogg", 1, 1};
		title = "On it - Out.";
		};

	class v2HAC_OrdConf5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdConf5v2.ogg", 1, 1};
		title = "Command, executing orders - Out.";
		};


	class v2HAC_OrdDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdDen1v2.ogg", 1, 1};
		title = "Can't do it - Over.";
		};

	class v2HAC_OrdDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdDen2v2.ogg", 1, 1};
		title = "Not possible - Over.";
		};

	class v2HAC_OrdDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdDen3v2.ogg", 1, 1};
		title = "Negative - Over.";
		};

	class v2HAC_OrdDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdDen4v2.ogg", 1, 1};
		title = "Impossible - Over.";
		};

	class v2HAC_OrdDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdDen5v2.ogg", 1, 1};
		title = "Command, unable to comply. Requesting new orders - Over.";
		};


	class v2HAC_OrdFinal1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdFinal1v2.ogg", 1, 1};
		title = "Approaching objective - Out.";
		};

	class v2HAC_OrdFinal2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdFinal2v2.ogg", 1, 1};
		title = "We're close to the objective - Out.";
		};

	class v2HAC_OrdFinal3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdFinal3v2.ogg", 1, 1};
		title = "In position - Out.";
		};

	class v2HAC_OrdFinal4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdFinal4v2.ogg", 1, 1};
		title = "Executing objective - Out.";
		};


	class v2HAC_OrdEnd1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdEnd1v2.ogg", 1, 1};
		title = "Waiting for orders - Over.";
		};

	class v2HAC_OrdEnd2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdEnd2v2.ogg", 1, 1};
		title = "Task complete - Over.";
		};

	class v2HAC_OrdEnd3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdEnd3v2.ogg", 1, 1};
		title = "We're done here - Over.";
		};

	class v2HAC_OrdEnd4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdEnd4v2.ogg", 1, 1};
		title = "Mission objective completed - Over.";
		};

	class v2HAC_OrdEnd5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OrdEnd5v2.ogg", 1, 1};
		title = "Command, we're awaiting orders - Over.";
		};


	class v2HAC_SuppReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppReq1v2.ogg", 1, 1};
		title = "We need supplies - Over.";
		};

	class v2HAC_SuppReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppReq2v2.ogg", 1, 1};
		title = "Requesting logistical support - Over.";
		};

	class v2HAC_SuppReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppReq3v2.ogg", 1, 1};
		title = "We could use some supplies - Over.";
		};

	class v2HAC_SuppReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppReq4v2.ogg", 1, 1};
		title = "We are low on supplies - Over.";
		};

	class v2HAC_SuppReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppReq5v2.ogg", 1, 1};
		title = "Command, requesting supplies - Over.";
		};



	class v2HAC_MedReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\MedReq1v2.ogg", 1, 1};
		title = "We need a Medevac! - Over.";
		};

	class v2HAC_MedReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\MedReq2v2.ogg", 1, 1};
		title = "Requesting Medevac - Over.";
		};

	class v2HAC_MedReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\MedReq3v2.ogg", 1, 1};
		title = "We need immediate Medevac - Over.";
		};

	class v2HAC_MedReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\MedReq4v2.ogg", 1, 1};
		title = "We need medical support - Over.";
		};

	class v2HAC_MedReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\MedReq5v2.ogg", 1, 1};
		title = "Command, requesting medevac - Over.";
		};



	class v2HAC_ArtyReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtyReq1v2.ogg", 1, 1};
		title = "Requesting fire mission on transmitted coordinates - Over.";
		};

	class v2HAC_ArtyReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtyReq2v2.ogg", 1, 1};
		title = "We need artillery on target position - Over.";
		};

	class v2HAC_ArtyReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtyReq3v2.ogg", 1, 1};
		title = "Give us some fire support!";
		};

	class v2HAC_ArtyReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtyReq4v2.ogg", 1, 1};
		title = "A few artillery shells would be appreciated here - Over.";
		};

	class v2HAC_ArtyReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtyReq5v2.ogg", 1, 1};
		title = "Command, requesting fire mission on target coordinates - Over.";
		};



	class v2HAC_SmokeReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SmokeReq1v2.ogg", 1, 1};
		title = "Requesting smoke cover to withdraw - Over.";
		};

	class v2HAC_SmokeReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SmokeReq2v2.ogg", 1, 1};
		title = "Need smoke screen on our position - Over.";
		};

	class v2HAC_SmokeReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SmokeReq3v2.ogg", 1, 1};
		title = "We're falling back. Give us some smoke - Over.";
		};

	class v2HAC_SmokeReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SmokeReq4v2.ogg", 1, 1};
		title = "We need concealment. Requesting smoke - Over.";
		};


	class v2HAC_IllumReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\IllumReq1v2.ogg", 1, 1};
		title = "Potential enemy presence on field. Requesting illumination - Over.";
		};

	class v2HAC_IllumReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\IllumReq2v2.ogg", 1, 1};
		title = "Illumination needed at our coordinates - Over.";
		};

	class v2HAC_IllumReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\IllumReq3v2.ogg", 1, 1};
		title = "Need illumination on our position - Over.";
		};

	class v2HAC_IllumReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\IllumReq4v2.ogg", 1, 1};
		title = "We hear them. Some flares could be useful here - Over.";
		};


	class v2HAC_InDanger1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger1v2.ogg", 1, 1};
		title = "Incoming!";
		};

	class v2HAC_InDanger2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger2v2.ogg", 1, 1};
		title = "We're under fire!";
		};

	class v2HAC_InDanger3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger3v2.ogg", 1, 1};
		title = "Enemy nearby!";
		};

	class v2HAC_InDanger4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger4v2.ogg", 1, 1};
		title = "Under fire!";
		};

	class v2HAC_InDanger5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger5v2.ogg", 1, 1};
		title = "We are pinned down!";
		};

	class v2HAC_InDanger6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger6v2.ogg", 1, 1};
		title = "Opening fire!";
		};

	class v2HAC_InDanger7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger7v2.ogg", 1, 1};
		title = "The enemy is approaching our position!";
		};

	class v2HAC_InDanger8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger8v2.ogg", 1, 1};
		title = "We are being flanked!";
		};

	class v2HAC_InDanger9
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger9v2.ogg", 1, 1};
		title = "We must stop them at any cost!";
		};

	class v2HAC_InDanger10
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger10v2.ogg", 1, 1};
		title = "Give'em hell!";
		};

	class v2HAC_InDanger11
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger11v2.ogg", 1, 1};
		title = "Keep your heads down, dammit!";
		};

	class v2HAC_InDanger12
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger12v2.ogg", 1, 1};
		title = "Fire at will!";
		};

	class v2HAC_InDanger13
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InDanger13v2.ogg", 1, 1};
		title = "Command, we're in danger - Over.";
		};



	class v2HAC_EnemySpot1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\EnemySpot1v2.ogg", 1, 1};
		title = "Enemy spotted - Over.";
		};

	class v2HAC_EnemySpot2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\EnemySpot2v2.ogg", 1, 1};
		title = "We're observing hostiles - Over.";
		};

	class v2HAC_EnemySpot3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\EnemySpot3v2.ogg", 1, 1};
		title = "Enemy forces at the designated coordinates - Over.";
		};

	class v2HAC_EnemySpot4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\EnemySpot4v2.ogg", 1, 1};
		title = "Hostile presence in this area - Over.";
		};

	class v2HAC_EnemySpot5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\EnemySpot5v2.ogg", 1, 1};
		title = "Command, hostiles spotted - Over.";
		};


	class v2HAC_InFear1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InFear1v2.ogg", 1, 1};
		title = "We have no chance!";
		};

	class v2HAC_InFear2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InFear2v2.ogg", 1, 1};
		title = "Regroup!";
		};

	class v2HAC_InFear3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InFear3v2.ogg", 1, 1};
		title = "Enemy is overwhelming!";
		};

	class v2HAC_InFear4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InFear4v2.ogg", 1, 1};
		title = "There's too many of them!";
		};

	class v2HAC_InFear5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InFear5v2.ogg", 1, 1};
		title = "Don't let us die here!";
		};

	class v2HAC_InFear6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InFear6v2.ogg", 1, 1};
		title = "We're outnumbered!";
		};

	class v2HAC_InFear7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InFear7v2.ogg", 1, 1};
		title = "We need help!";
		};

	class v2HAC_InFear8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InFear8v2.ogg", 1, 1};
		title = "We can't hold this position!";
		};



	class v2HAC_InPanic1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InPanic1v2.ogg", 1, 1};
		title = "The hell with this!";
		};

	class v2HAC_InPanic2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InPanic2v2.ogg", 1, 1};
		title = "Run!";
		};

	class v2HAC_InPanic3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InPanic3v2.ogg", 1, 1};
		title = "We can't stand it any more!";
		};

	class v2HAC_InPanic4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InPanic4v2.ogg", 1, 1};
		title = "We're out of here!";
		};

	class v2HAC_InPanic5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InPanic5v2.ogg", 1, 1};
		title = "We are going to die!";
		};

	class v2HAC_InPanic6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InPanic6v2.ogg", 1, 1};
		title = "We need to run!";
		};

	class v2HAC_InPanic7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InPanic7v2.ogg", 1, 1};
		title = "It's hopeless!";
		};

	class v2HAC_InPanic8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\InPanic8v2.ogg", 1, 1};
		title = "I'm not dying here!";
		};


	class v2HAC_SuppAss1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppAss1v2.ogg", 1, 1};
		title = "Support on the way - Out.";
		};

	class v2HAC_SuppAss2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppAss2v2.ogg", 1, 1};
		title = "Support is inbound. Hold on - Out.";
		};

	class v2HAC_SuppAss3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppAss3v2.ogg", 1, 1};
		title = "Support is directed to your position - Out.";
		};

	class v2HAC_SuppAss4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppAss4v2.ogg", 1, 1};
		title = "Supplies en route - Out.";
		};

	class v2HAC_SuppAss5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppAss5v2.ogg", 1, 1};
		title = "Support en route - Out.";
		};



	class v2HAC_SuppDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppDen1v2.ogg", 1, 1};
		title = "Support not possible at the moment - Out.";
		};

	class v2HAC_SuppDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppDen2v2.ogg", 1, 1};
		title = "Negative, support is unavailable - Out.";
		};

	class v2HAC_SuppDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppDen3v2.ogg", 1, 1};
		title = "Support request denied - Out.";
		};

	class v2HAC_SuppDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppDen4v2.ogg", 1, 1};
		title = "Negative, we have no support vehicles available - Out.";
		};

	class v2HAC_SuppDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\SuppDen5v2.ogg", 1, 1};
		title = "Negative, request denied. we cannot provide support right now - Out.";
		};



	class v2HAC_ArtAss1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtAss1v2.ogg", 1, 1};
		title = "Artillery support assigned - Out.";
		};

	class v2HAC_ArtAss2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtAss2v2.ogg", 1, 1};
		title = "Prepare for artillery barrage - Out.";
		};

	class v2HAC_ArtAss3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtAss3v2.ogg", 1, 1};
		title = "Fire Mission accepted. Wait for the fireworks - Out.";
		};

	class v2HAC_ArtAss4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtAss4v2.ogg", 1, 1};
		title = "Preparing artillery fire mission. Dig in! - Out.";
		};

	class v2HAC_ArtAss5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtAss5v2.ogg", 1, 1};
		title = "Fire mission on target coordinates - Out.";
		};


	class v2HAC_ArtDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtDen1v2.ogg", 1, 1};
		title = "Negative, we have no available artillery battery - Out.";
		};

	class v2HAC_ArtDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtDen2v2.ogg", 1, 1};
		title = "Fire mission impossible at this time - Out.";
		};

	class v2HAC_ArtDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtDen3v2.ogg", 1, 1};
		title = "Negative, all batteries are busy right now - Out.";
		};

	class v2HAC_ArtDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtDen4v2.ogg", 1, 1};
		title = "Fire mission request denied. - Out.";
		};

	class v2HAC_ArtDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtDen5v2.ogg", 1, 1};
		title = "Negative, request denied. No fire missions are available - Out.";
		};


	class v2HAC_OffStance1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\OffStance1v2.ogg", 1, 1};
		title = "To all callsigns: Offensive formation in effect";
		};

	class v2HAC_DefStance1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\DefStance1v2.ogg", 1, 1};
		title = "To all callsigns: Defensive formation in effect";
		};


	class v2HAC_ArtFire1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtFire1v2.ogg", 1, 1};
		title = "Firing for effect! - Out.";
		};

	class v2HAC_ArtFire2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtFire2v2.ogg", 1, 1};
		title = "Shells on the way! - Out.";
		};

	class v2HAC_ArtFire3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtFire3v2.ogg", 1, 1};
		title = "Fire mission in progress - Out.";
		};

	class v2HAC_ArtFire4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtFire4v2.ogg", 1, 1};
		title = "Shells away - Out.";
		};

	class v2HAC_ArtFire5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice2\ArtFire5v2.ogg", 1, 1};
		title = "Fire mission dispatched on target location - Out.";
		};



	class v3HAC_OrdConf1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdConf1v3.ogg", 1, 1};
		title = "Roger that - Out.";
		};

	class v3HAC_OrdConf2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdConf2v3.ogg", 1, 1};
		title = "Affirmative - Out.";
		};

	class v3HAC_OrdConf3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Acknowledged - Out.";
		};

	class v3HAC_OrdConf4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdConf4v3.ogg", 1, 1};
		title = "On it - Out.";
		};

	class v3HAC_OrdConf5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdConf5v3.ogg", 1, 1};
		title = "Command, executing orders - Out.";
		};


	class v3HAC_OrdDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdDen1v3.ogg", 1, 1};
		title = "Can't do it - Over.";
		};

	class v3HAC_OrdDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdDen2v3.ogg", 1, 1};
		title = "Not possible - Over.";
		};

	class v3HAC_OrdDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdDen3v3.ogg", 1, 1};
		title = "Negative - Over.";
		};

	class v3HAC_OrdDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdDen4v3.ogg", 1, 1};
		title = "Impossible - Over.";
		};

	class v3HAC_OrdDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdDen5v3.ogg", 1, 1};
		title = "Command, I cannot comply. Requesting new orders - Over.";
		};


	class v3HAC_OrdFinal1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdFinal1v3.ogg", 1, 1};
		title = "Approaching objective - Out.";
		};

	class v3HAC_OrdFinal2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdFinal2v3.ogg", 1, 1};
		title = "We're close to the objective - Out.";
		};

	class v3HAC_OrdFinal3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdFinal3v3.ogg", 1, 1};
		title = "In position - Out.";
		};

	class v3HAC_OrdFinal4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdFinal4v3.ogg", 1, 1};
		title = "We're proceeding to the objective - Out.";
		};


	class v3HAC_OrdEnd1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdEnd1v3.ogg", 1, 1};
		title = "Waiting for orders - Over.";
		};

	class v3HAC_OrdEnd2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdEnd2v3.ogg", 1, 1};
		title = "Task complete - Over.";
		};

	class v3HAC_OrdEnd3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdEnd3v3.ogg", 1, 1};
		title = "We're done here - Over.";
		};

	class v3HAC_OrdEnd4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdEnd4v3.ogg", 1, 1};
		title = "Mission objective completed - Over.";
		};

	class v3HAC_OrdEnd5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OrdEnd5v3.ogg", 1, 1};
		title = "Command, we're awaiting orders - Over.";
		};


	class v3HAC_SuppReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppReq1v3.ogg", 1, 1};
		title = "We need supplies - Over.";
		};

	class v3HAC_SuppReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppReq2v3.ogg", 1, 1};
		title = "Request logistical support - Over.";
		};

	class v3HAC_SuppReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppReq3v3.ogg", 1, 1};
		title = "We could use some supplies - Over.";
		};

	class v3HAC_SuppReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppReq4v3.ogg", 1, 1};
		title = "Our supplies are low - Over.";
		};

	class v3HAC_SuppReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppReq5v3.ogg", 1, 1};
		title = "Command, requesting support - Over.";
		};



	class v3HAC_MedReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\MedReq1v3.ogg", 1, 1};
		title = "We need a Medevac! - Over.";
		};

	class v3HAC_MedReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\MedReq2v3.ogg", 1, 1};
		title = "Requesting Medevac - Over.";
		};

	class v3HAC_MedReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\MedReq3v3.ogg", 1, 1};
		title = "We need immediate Medevac - Over.";
		};

	class v3HAC_MedReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\MedReq4v3.ogg", 1, 1};
		title = "We need medical support - Over.";
		};

	class v3HAC_MedReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\MedReq5v3.ogg", 1, 1};
		title = "Command, requesting medevac - Over.";
		};



	class v3HAC_ArtyReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtyReq1v3.ogg", 1, 1};
		title = "Requesting fire mission on transmitted coordinates - Over.";
		};

	class v3HAC_ArtyReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtyReq2v3.ogg", 1, 1};
		title = "We need artillery on target position - Over.";
		};

	class v3HAC_ArtyReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtyReq3v3.ogg", 1, 1};
		title = "Give us some fire support!";
		};

	class v3HAC_ArtyReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtyReq4v3.ogg", 1, 1};
		title = "A few artillery shells would be appreciated here - Over.";
		};

	class v3HAC_ArtyReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtyReq5v3.ogg", 1, 1};
		title = "Command, requesting fire mission on previous coordinates - Over.";
		};



	class v3HAC_SmokeReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SmokeReq1v3.ogg", 1, 1};
		title = "Requesting smoke cover to withdraw - Over.";
		};

	class v3HAC_SmokeReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SmokeReq2v3.ogg", 1, 1};
		title = "Need smoke screen on our position - Over.";
		};

	class v3HAC_SmokeReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SmokeReq3v3.ogg", 1, 1};
		title = "We're falling back. Give us some smoke - Over.";
		};

	class v3HAC_SmokeReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SmokeReq4v3.ogg", 1, 1};
		title = "We need concealment. Requesting smoke - Over.";
		};


	class v3HAC_IllumReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\IllumReq1v3.ogg", 1, 1};
		title = "Possible enemy presence on field. Requesting illumination - Over.";
		};

	class v3HAC_IllumReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\IllumReq2v3.ogg", 1, 1};
		title = "Illumination needed at our coordinates - Over.";
		};

	class v3HAC_IllumReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\IllumReq3v3.ogg", 1, 1};
		title = "Need illumination on our last position - Over.";
		};

	class v3HAC_IllumReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\IllumReq4v3.ogg", 1, 1};
		title = "We hear them. Some flare rounds could be useful here - Over.";
		};


	class v3HAC_InDanger1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger1v3.ogg", 1, 1};
		title = "Incoming!";
		};

	class v3HAC_InDanger2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger2v3.ogg", 1, 1};
		title = "We're under fire!";
		};

	class v3HAC_InDanger3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger3v3.ogg", 1, 1};
		title = "Enemy is close!";
		};

	class v3HAC_InDanger4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger4v3.ogg", 1, 1};
		title = "Under fire!";
		};

	class v3HAC_InDanger5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger5v3.ogg", 1, 1};
		title = "We are pinned down!";
		};

	class v3HAC_InDanger6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger6v3.ogg", 1, 1};
		title = "Opening fire!";
		};

	class v3HAC_InDanger7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger7v3.ogg", 1, 1};
		title = "The enemy is approaching our position!";
		};

	class v3HAC_InDanger8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger8v3.ogg", 1, 1};
		title = "We are being flanked!";
		};

	class v3HAC_InDanger9
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger9v3.ogg", 1, 1};
		title = "We must stop them at any cost!";
		};

	class v3HAC_InDanger10
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger10v3.ogg", 1, 1};
		title = "Give'em hell!";
		};

	class v3HAC_InDanger11
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger11v3.ogg", 1, 1};
		title = "Keep your heads down, dammit!";
		};

	class v3HAC_InDanger12
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger12v3.ogg", 1, 1};
		title = "Fire at will!";
		};

	class v3HAC_InDanger13
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InDanger13v3.ogg", 1, 1};
		title = "Command, we're in danger - Over.";
		};



	class v3HAC_EnemySpot1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\EnemySpot1v3.ogg", 1, 1};
		title = "Enemy spotted - Over.";
		};

	class v3HAC_EnemySpot2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\EnemySpot2v3.ogg", 1, 1};
		title = "We're observing hostiles - Over.";
		};

	class v3HAC_EnemySpot3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\EnemySpot3v3.ogg", 1, 1};
		title = "Enemy forces at the designated coordinates - Over.";
		};

	class v3HAC_EnemySpot4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\EnemySpot4v3.ogg", 1, 1};
		title = "Hostile presence in this area - Over.";
		};

	class v3HAC_EnemySpot5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\EnemySpot5v3.ogg", 1, 1};
		title = "Command, hostiles spotted - Over.";
		};


	class v3HAC_InFear1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InFear1v3.ogg", 1, 1};
		title = "We have no chance!";
		};

	class v3HAC_InFear2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InFear2v3.ogg", 1, 1};
		title = "Regroup!";
		};

	class v3HAC_InFear3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InFear3v3.ogg", 1, 1};
		title = "Enemy is overwhelming!";
		};

	class v3HAC_InFear4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InFear4v3.ogg", 1, 1};
		title = "There's too many of them!";
		};

	class v3HAC_InFear5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InFear5v3.ogg", 1, 1};
		title = "Don't let us die here!";
		};

	class v3HAC_InFear6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InFear6v3.ogg", 1, 1};
		title = "We're outnumbered!";
		};

	class v3HAC_InFear7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InFear7v3.ogg", 1, 1};
		title = "We need help!";
		};

	class v3HAC_InFear8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InFear8v3.ogg", 1, 1};
		title = "We can't hold this position!";
		};



	class v3HAC_InPanic1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InPanic1v3.ogg", 1, 1};
		title = "The hell with this!";
		};

	class v3HAC_InPanic2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InPanic2v3.ogg", 1, 1};
		title = "Run!";
		};

	class v3HAC_InPanic3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InPanic3v3.ogg", 1, 1};
		title = "We can't stand it any more!";
		};

	class v3HAC_InPanic4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InPanic4v3.ogg", 1, 1};
		title = "We're out of here!";
		};

	class v3HAC_InPanic5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InPanic5v3.ogg", 1, 1};
		title = "We all going to die!";
		};

	class v3HAC_InPanic6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InPanic6v3.ogg", 1, 1};
		title = "We need to run!";
		};

	class v3HAC_InPanic7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InPanic7v3.ogg", 1, 1};
		title = "It's hopeless!";
		};

	class v3HAC_InPanic8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\InPanic8v3.ogg", 1, 1};
		title = "I'm not dying here!";
		};


	class v3HAC_SuppAss1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppAss1v3.ogg", 1, 1};
		title = "Support on the way - Out.";
		};

	class v3HAC_SuppAss2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppAss2v3.ogg", 1, 1};
		title = "Support is inbound. Hold on - Out.";
		};

	class v3HAC_SuppAss3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppAss3v3.ogg", 1, 1};
		title = "Support is directed to your position - Out.";
		};

	class v3HAC_SuppAss4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppAss4v3.ogg", 1, 1};
		title = "Supplies en route - Out.";
		};

	class v3HAC_SuppAss5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppAss5v3.ogg", 1, 1};
		title = "Support en route - Out.";
		};



	class v3HAC_SuppDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppDen1v3.ogg", 1, 1};
		title = "Support not possible at the moment - Out.";
		};

	class v3HAC_SuppDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppDen2v3.ogg", 1, 1};
		title = "Negative, support is unavailable - Out.";
		};

	class v3HAC_SuppDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppDen3v3.ogg", 1, 1};
		title = "Support request denied. - Out.";
		};

	class v3HAC_SuppDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppDen4v3.ogg", 1, 1};
		title = "Negative, we have no support vehicles available - Out.";
		};

	class v3HAC_SuppDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\SuppDen5v3.ogg", 1, 1};
		title = "Negative, request denied. We cannot provide support right now - Out.";
		};



	class v3HAC_ArtAss1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtAss1v3.ogg", 1, 1};
		title = "Artillery support assigned - Out.";
		};

	class v3HAC_ArtAss2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtAss2v3.ogg", 1, 1};
		title = "Prepare for artillery barrage - Out.";
		};

	class v3HAC_ArtAss3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtAss3v3.ogg", 1, 1};
		title = "Fire mission accepted. Wait for the fireworks - Out.";
		};

	class v3HAC_ArtAss4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtAss4v3.ogg", 1, 1};
		title = "Preparing artillery fire mission. Dig in! - Out.";
		};

	class v3HAC_ArtAss5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtAss5v3.ogg", 1, 1};
		title = "Fire mission dispatched on target coordinates - Out.";
		};


	class v3HAC_ArtDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtDen1v3.ogg", 1, 1};
		title = "Negative, we have no available artillery battery - Out.";
		};

	class v3HAC_ArtDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtDen2v3.ogg", 1, 1};
		title = "Fire mission impossible at this time - Out.";
		};

	class v3HAC_ArtDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtDen3v3.ogg", 1, 1};
		title = "Negative, all batteries are busy right now - Out.";
		};

	class v3HAC_ArtDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtDen4v3.ogg", 1, 1};
		title = "Fire mission request denied. - Out.";
		};

	class v3HAC_ArtDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtDen5v3.ogg", 1, 1};
		title = "Negative, request denied. No fire missions are available - Out.";
		};


	class v3HAC_OffStance1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\OffStance1v3.ogg", 1, 1};
		title = "To all callsigns: Offensive formation in effect";
		};

	class v3HAC_DefStance1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\DefStance1v3.ogg", 1, 1};
		title = "To all callsigns: Defensive formation in effect";
		};


	class v3HAC_ArtFire1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtFire1v3.ogg", 1, 1};
		title = "Firing for effect! - Out.";
		};

	class v3HAC_ArtFire2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtFire2v3.ogg", 1, 1};
		title = "Shells on the way! - Out.";
		};

	class v3HAC_ArtFire3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtFire3v3.ogg", 1, 1};
		title = "Fire mission in progress - Out.";
		};

	class v3HAC_ArtFire4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtFire4v3.ogg", 1, 1};
		title = "Shells away - Out.";
		};

	class v3HAC_ArtFire5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Voice3\ArtFire5v3.ogg", 1, 1};
		title = "Fire Mission dispatched on target location - Out.";
		};

	class HQ_ord_attack
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Engage enemy forces (Infantry)";
		};

	class HQ_ord_attackNaval
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Engage enemy ships";
		};

	class HQ_ord_attackArmor
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Engage enemy forces (Armor)";
		};

	class HQ_ord_attackAir
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Provide Close Air Support";
		};

	class HQ_ord_attackAirCAP
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Perform Combat Air Patrol";
		};

	class HQ_ord_attackSnip
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Perform sniper mission";
		};

	class HQ_ord_recon
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Perform reconnaissance";
		};

	class HQ_ord_capture
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Secure objective";
		};

	class HQ_ord_captureNav
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Secure seas";
		};

	class HQ_ord_defend
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Take and hold defensive position";
		};

	class HQ_ord_defendR
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Patrol area and standby for orders";
		};

	class HQ_ord_defendRNav
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Patrol seas and standby for orders";
		};

	class HQ_ord_flank
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Outflank enemy forces";
		};

	class HQ_ord_ammoS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Deliver ammunition";
		};

	class HQ_ord_medS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Provide medevac";
		};

	class HQ_ord_fuelS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Deliver fuel";
		};

	class HQ_ord_repS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Conduct field repairs";
		};

	class HQ_ord_idle
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Standby for orders";
		};

	class HQ_ord_withdraw
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Withdraw";
		};

	class HQ_ord_cargo
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Provide transport";
		};

	class HQ_ord_SF
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Perform tactical operation";
		};

//40K IMPERIUM OF MAN LINES

	class HAC_40KImp_OrdConf1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "In the name of the Emperor, it shall be done - Out.";
		};

	class HAC_40KImp_OrdConf2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Affirmative - Out.";
		};

	class HAC_40KImp_OrdConf3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Acknowledged - Out.";
		};

	class HAC_40KImp_OrdConf4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Compliance - Out.";
		};

	class HAC_40KImp_OrdConf5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "In his name, we go onwards with this mission - Out.";
		};


	class HAC_40KImp_OrdDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Unable to comply - Over.";
		};

	class HAC_40KImp_OrdDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Not possible - Over.";
		};

	class HAC_40KImp_OrdDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Negative - Over.";
		};

	class HAC_40KImp_OrdDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Compliance impossible - Over.";
		};

	class HAC_40KImp_OrdDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Compliance not possible - Over.";
		};


	class HAC_40KImp_OrdFinal1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Approaching objective - Out.";
		};

	class HAC_40KImp_OrdFinal2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "We are nearing our objective - Out.";
		};

	class HAC_40KImp_OrdFinal3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "In position - Out.";
		};

	class HAC_40KImp_OrdFinal4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "We have arrived at our objective - Out.";
		};


	class HAC_40KImp_OrdEnd1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Standing by for orders - Over.";
		};

	class HAC_40KImp_OrdEnd2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Task complete - Over.";
		};

	class HAC_40KImp_OrdEnd3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "His will has been executed - Over.";
		};

	class HAC_40KImp_OrdEnd4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Mission objective completed - Over.";
		};

	class HAC_40KImp_OrdEnd5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Awaiting the Emperor's word! - Over.";
		};


	class HAC_40KImp_SuppReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Requesting ammunition - Over.";
		};

	class HAC_40KImp_SuppReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Requesting additional ammunition - Over.";
		};

	class HAC_40KImp_SuppReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Supplies critical - Over.";
		};

	class HAC_40KImp_SuppReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "We require additional weaponry - Over.";
		};

	class HAC_40KImp_SuppReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Requesting more ammnition - Over.";
		};



	class HAC_40KImp_MedReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Requesting medical assistance! - Over.";
		};

	class HAC_40KImp_MedReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Requesting apothecary! - Over.";
		};

	class HAC_40KImp_MedReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "We need an apothecary! - Over.";
		};

	class HAC_40KImp_MedReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "We need medical support - Over.";
		};

	class HAC_40KImp_MedReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Requesting an apothecary's blessings - Over.";
		};



	class HAC_40KImp_ArtyReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Requesting the Emperor's wrath on target position - Over.";
		};

	class HAC_40KImp_ArtyReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Requesting artillery on target position - Over.";
		};

	class HAC_40KImp_ArtyReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Fire support requested - Over";
		};

	class HAC_40KImp_ArtyReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Shelling requested on target location - Over.";
		};

	class HAC_40KImp_ArtyReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Requesting fire mission on target coordinates - Over.";
		};



	class HAC_40KImp_SmokeReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Requesting smoke cover for tactical withdrawal - Over.";
		};

	class HAC_40KImp_SmokeReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Requesting smoke deployment on our position - Over.";
		};

	class HAC_40KImp_SmokeReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Smoke cover requested for tactical withdrawal - Over.";
		};

	class HAC_40KImp_SmokeReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Requesting concealement smoke - Over.";
		};


	class HAC_40KImp_IllumReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Requesting the Emperor's light at our position - Over.";
		};

	class HAC_40KImp_IllumReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Illumination requested at our coordinates - Over.";
		};

	class HAC_40KImp_IllumReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Requesting illumination on our position - Over.";
		};

	class HAC_40KImp_IllumReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Requesting illumination shells - Over.";
		};

	class HAC_40KImp_InDanger1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "For the Emperor!";
		};

	class HAC_40KImp_InDanger2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Under fire! - Over";
		};

	class HAC_40KImp_InDanger3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Burn the heretic! Kill the mutant! Purge the unclean!";
		};

	class HAC_40KImp_InDanger4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Onwards Brothers! For the Emperor!";
		};

	class HAC_40KImp_InDanger5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Sustaining enemy fire - Over";
		};

	class HAC_40KImp_InDanger6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Purging the enemies of the Emperor! - Over";
		};

	class HAC_40KImp_InDanger7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "The stench of heresy! Burn it all Brothers!";
		};

	class HAC_40KImp_InDanger8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Engaging hostiles - over";
		};

	class HAC_40KImp_InDanger9
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "We must smite their resolve, Brothers!";
		};

	class HAC_40KImp_InDanger10
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Show them the wrath of the Emperor!";
		};

	class HAC_40KImp_InDanger11
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Show them no mercy for the enemies of the Emperor are to be purged!";
		};

	class HAC_40KImp_InDanger12
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Engage at will, Brothers!";
		};

	class HAC_40KImp_InDanger13
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Under heavy enemy fire - Over.";
		};



	class HAC_40KImp_EnemySpot1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Enemy of the Imperium spotted - Over.";
		};

	class HAC_40KImp_EnemySpot2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Hostiles spotted - Over.";
		};

	class HAC_40KImp_EnemySpot3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Enemy of the Emperor spotted - Over.";
		};

	class HAC_40KImp_EnemySpot4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Hostile presence in the area - Over.";
		};

	class HAC_40KImp_EnemySpot5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Hostiles spotted near our location - Over.";
		};


	class HAC_40KImp_InFear1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "By the Emperor! Regroup!";
		};

	class HAC_40KImp_InFear2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Emperor be praised! Glory in death!";
		};

	class HAC_40KImp_InFear3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Enemy is gaining ground on us! - Over";
		};

	class HAC_40KImp_InFear4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "We are overwhelmed! - Over";
		};

	class HAC_40KImp_InFear5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Regroup Brothers! Your duty only ends in death!";
		};

	class HAC_40KImp_InFear6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Cower and you shall be shot! Get back in line!";
		};

	class HAC_40KImp_InFear7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Requesting immediate assistance! - Over";
		};

	class HAC_40KImp_InFear8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Emperor protect us!";
		};



	class HAC_40KImp_InPanic1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Emperor save us!";
		};

	class HAC_40KImp_InPanic2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "We need to reposition!";
		};

	class HAC_40KImp_InPanic3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "We must follow the Emperor's light!";
		};

	class HAC_40KImp_InPanic4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Emperor save us all!";
		};

	class HAC_40KImp_InPanic5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "We are soon going to be by his side, Brothers!";
		};

	class HAC_40KImp_InPanic6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Run and I will execute you myself!";
		};

	class HAC_40KImp_InPanic7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Emperor save us!";
		};

	class HAC_40KImp_InPanic8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Glory in death Brothers! For it is upon us!";
		};


	class HAC_40KImp_SuppAss1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Support on the way - Out.";
		};

	class HAC_40KImp_SuppAss2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Support is inbound. The Emperor protects - Out.";
		};

	class HAC_40KImp_SuppAss3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Support is directed to your position. The Emperor provides - Out.";
		};

	class HAC_40KImp_SuppAss4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "The Emperor has blessed you with supplies. Expect them soon - Out.";
		};

	class HAC_40KImp_SuppAss5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Support en route to you - Out.";
		};



	class HAC_40KImp_SuppDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Support not possible at the moment - Out.";
		};

	class HAC_40KImp_SuppDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Negative, support is unavailable - Out.";
		};

	class HAC_40KImp_SuppDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Support request denied. Unavailable - Out.";
		};

	class HAC_40KImp_SuppDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Negative, we have no support available - Out.";
		};

	class HAC_40KImp_SuppDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Negative, request denied. Support unavailable - Out.";
		};



	class HAC_40KImp_ArtAss1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Artillery support inbound - Out.";
		};

	class HAC_40KImp_ArtAss2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Prepare for artillery barrage - Out.";
		};

	class HAC_40KImp_ArtAss3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Fire mission dispatched. Brace for the Emperor's wrath - Out.";
		};

	class HAC_40KImp_ArtAss4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Emperor's wrath inbound - Out.";
		};

	class HAC_40KImp_ArtAss5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Fire mission in progress - Out.";
		};


	class HAC_40KImp_ArtDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Negative, fire support unavailable at this time - Out.";
		};

	class HAC_40KImp_ArtDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Fire mission impossible at this time - Out.";
		};

	class HAC_40KImp_ArtDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Negative, artillery unavailable - Out.";
		};

	class HAC_40KImp_ArtDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Fire mission request not authorised - Out.";
		};

	class HAC_40KImp_ArtDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Negative, fire support currently unavailable - Out.";
		};


	class HAC_40KImp_OffStance1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "To all callsigns: Offensive formation in effect. For the glory of the Emperor.";
		};

	class HAC_40KImp_DefStance1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "To all callsigns: Deffensive formation in effect. Emperor be praised.";
		};


	class HAC_40KImp_ArtFire1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Firing for effect! - Out.";
		};

	class HAC_40KImp_ArtFire2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Shells on the way! - Out.";
		};

	class HAC_40KImp_ArtFire3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Fire mission in progress - Out.";
		};

	class HAC_40KImp_ArtFire4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Shells away - Out.";
		};

	class HAC_40KImp_ArtFire5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Fire Mission on target location - Out.";
		};



	class HAC_40KImp_HQ_ord_attack
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Engage the Emperor's enemies";
		};

	class HAC_40KImp_HQ_ord_attackNaval
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Sink enemy sea vessels";
		};

	class HAC_40KImp_HQ_ord_attackArmor
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Smite the Emperor's enemies";
		};

	class HAC_40KImp_HQ_ord_attackAir
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Provide Close Air Support";
		};

	class HAC_40KImp_HQ_ord_attackAirCAP
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Perform Combat Air Patrol";
		};

	class HAC_40KImp_HQ_ord_attackSnip
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Perform sniper mission";
		};

	class HAC_40KImp_HQ_ord_recon
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Perform reconnaissance";
		};

	class HAC_40KImp_HQ_ord_capture
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Secure objective in his name";
		};

	class HAC_40KImp_HQ_ord_captureNav
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Secure seas in his name";
		};

	class HAC_40KImp_HQ_ord_defend
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Take and hold defensive position";
		};

	class HAC_40KImp_HQ_ord_defendR
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Patrol area and standby for orders";
		};

	class HAC_40KImp_HQ_ord_defendRNav
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Patrol seas and standby for orders";
		};

	class HAC_40KImp_HQ_ord_flank
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Outflank enemy forces";
		};

	class HAC_40KImp_HQ_ord_ammoS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Deliver ammunition";
		};

	class HAC_40KImp_HQ_ord_medS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Provide medevac";
		};

	class HAC_40KImp_HQ_ord_fuelS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Deliver fuel";
		};

	class HAC_40KImp_HQ_ord_repS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Conduct field repairs";
		};

	class HAC_40KImp_HQ_ord_idle
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Standby for orders";
		};

	class HAC_40KImp_HQ_ord_withdraw
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Performal tactical withdraw";
		};

	class HAC_40KImp_HQ_ord_cargo
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Provide transport";
		};

	class HAC_40KImp_HQ_ord_SF
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Perform tactical operation";
		};

//SILENT LINES

	class HAC_SILENTM_OrdConf1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Understood - Out.";
		};

	class HAC_SILENTM_OrdConf2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Affirmative - Out.";
		};

	class HAC_SILENTM_OrdConf3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Acknowledged - Out.";
		};

	class HAC_SILENTM_OrdConf4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "On the way - Out.";
		};

	class HAC_SILENTM_OrdConf5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Wilco. On the way - Out.";
		};


	class HAC_SILENTM_OrdDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Unable to comply - Over.";
		};

	class HAC_SILENTM_OrdDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Not possible - Over.";
		};

	class HAC_SILENTM_OrdDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Negative - Over.";
		};

	class HAC_SILENTM_OrdDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Unable - Over.";
		};

	class HAC_SILENTM_OrdDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Task not possible - Over.";
		};


	class HAC_SILENTM_OrdFinal1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Approaching objective - Out.";
		};

	class HAC_SILENTM_OrdFinal2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "We are nearing our objective - Out.";
		};

	class HAC_SILENTM_OrdFinal3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "In position - Out.";
		};

	class HAC_SILENTM_OrdFinal4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "We have arrived at our objective - Out.";
		};


	class HAC_SILENTM_OrdEnd1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Standing by for orders - Over.";
		};

	class HAC_SILENTM_OrdEnd2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Task complete - Over.";
		};

	class HAC_SILENTM_OrdEnd3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Objective complete. Standing by - Over.";
		};

	class HAC_SILENTM_OrdEnd4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Mission objective completed - Over.";
		};

	class HAC_SILENTM_OrdEnd5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Awaiting new orders - Over.";
		};


	class HAC_SILENTM_SuppReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Requesting ammunition - Over.";
		};

	class HAC_SILENTM_SuppReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Requesting additional ammunition - Over.";
		};

	class HAC_SILENTM_SuppReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Our supplies are low - Over.";
		};

	class HAC_SILENTM_SuppReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "We require additional ammo - Over.";
		};

	class HAC_SILENTM_SuppReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Requesting more ammnition - Over.";
		};



	class HAC_SILENTM_MedReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Requesting medical assistance! - Over.";
		};

	class HAC_SILENTM_MedReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Requesting medic! - Over.";
		};

	class HAC_SILENTM_MedReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "We need a medic! - Over.";
		};

	class HAC_SILENTM_MedReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "We need medical support - Over.";
		};

	class HAC_SILENTM_MedReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Requesting a medic - Over.";
		};



	class HAC_SILENTM_ArtyReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Requesting fire mission on target position - Over.";
		};

	class HAC_SILENTM_ArtyReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Requesting artillery on target position - Over.";
		};

	class HAC_SILENTM_ArtyReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Fire support requested - Over";
		};

	class HAC_SILENTM_ArtyReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Shelling requested on target location - Over.";
		};

	class HAC_SILENTM_ArtyReq5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Requesting fire mission on target coordinates - Over.";
		};



	class HAC_SILENTM_SmokeReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Requesting smoke cover for tactical withdrawal - Over.";
		};

	class HAC_SILENTM_SmokeReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Requesting smoke deployment on our position - Over.";
		};

	class HAC_SILENTM_SmokeReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Smoke cover requested for tactical withdrawal - Over.";
		};

	class HAC_SILENTM_SmokeReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Requesting concealement smoke - Over.";
		};


	class HAC_SILENTM_IllumReq1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Requesting artillery flare at our position - Over.";
		};

	class HAC_SILENTM_IllumReq2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Illumination requested at our coordinates - Over.";
		};

	class HAC_SILENTM_IllumReq3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Requesting illumination on our position - Over.";
		};

	class HAC_SILENTM_IllumReq4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Requesting illumination shells - Over.";
		};

	class HAC_SILENTM_InDanger1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Hostile contact! - Over";
		};

	class HAC_SILENTM_InDanger2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Under fire! - Over";
		};

	class HAC_SILENTM_InDanger3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Taking fire! - Over";
		};

	class HAC_SILENTM_InDanger4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Under heavy fire! - Over";
		};

	class HAC_SILENTM_InDanger5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Taking enemy fire - Over";
		};

	class HAC_SILENTM_InDanger6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Heavy enemy response at our position - Over";
		};

	class HAC_SILENTM_InDanger7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "We're under fire! - Over";
		};

	class HAC_SILENTM_InDanger8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Engaging hostiles - Over";
		};

	class HAC_SILENTM_InDanger9
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Enemy contact! - Over";
		};

	class HAC_SILENTM_InDanger10
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Enemy fire! - Over";
		};

	class HAC_SILENTM_InDanger11
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "We're engaged in combat - Over";
		};

	class HAC_SILENTM_InDanger12
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Taking fire from hostile forces - Over";
		};

	class HAC_SILENTM_InDanger13
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Under enemy fire - Over.";
		};



	class HAC_SILENTM_EnemySpot1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Enemy spotted - Over.";
		};

	class HAC_SILENTM_EnemySpot2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Hostiles spotted - Over.";
		};

	class HAC_SILENTM_EnemySpot3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Confirmed hostiles spotted - Over.";
		};

	class HAC_SILENTM_EnemySpot4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Hostile presence in the area - Over.";
		};

	class HAC_SILENTM_EnemySpot5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Hostiles spotted near our location - Over.";
		};


	class HAC_SILENTM_InFear1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Under fire! Trying to regroup! - Over";
		};

	class HAC_SILENTM_InFear2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Requesting immediate assistance! - Over";
		};

	class HAC_SILENTM_InFear3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Enemy is gaining ground on us! - Over";
		};

	class HAC_SILENTM_InFear4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "We are overwhelmed! - Over";
		};

	class HAC_SILENTM_InFear5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "We are taking casualties! - Over";
		};

	class HAC_SILENTM_InFear6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Enemy fire has us pinned down! - Over";
		};

	class HAC_SILENTM_InFear7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Requesting immediate assistance! - Over";
		};

	class HAC_SILENTM_InFear8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "We're in trouble! Requesting immediate support! - Over";
		};



	class HAC_SILENTM_InPanic1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Fuck fuck fuck! We need support! - Over";
		};

	class HAC_SILENTM_InPanic2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "We need to reposition!";
		};

	class HAC_SILENTM_InPanic3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "We're getting the fuck out of here!";
		};

	class HAC_SILENTM_InPanic4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "We're so fucked!";
		};

	class HAC_SILENTM_InPanic5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "We're about to die here! - Over!";
		};

	class HAC_SILENTM_InPanic6
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "We're fucking dead!";
		};

	class HAC_SILENTM_InPanic7
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Anyone? We need help!";
		};

	class HAC_SILENTM_InPanic8
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "We're not making out of this one!";
		};


	class HAC_SILENTM_SuppAss1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Support on the way - Out.";
		};

	class HAC_SILENTM_SuppAss2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Support is inbound. - Out.";
		};

	class HAC_SILENTM_SuppAss3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Support is directed to your position. - Out.";
		};

	class HAC_SILENTM_SuppAss4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Supplies disptached to you. - Out.";
		};

	class HAC_SILENTM_SuppAss5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Support en route to you - Out.";
		};



	class HAC_SILENTM_SuppDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Support not possible at the moment - Out.";
		};

	class HAC_SILENTM_SuppDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Negative, support is unavailable - Out.";
		};

	class HAC_SILENTM_SuppDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Support request denied. Unavailable - Out.";
		};

	class HAC_SILENTM_SuppDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Negative, we have no support available - Out.";
		};

	class HAC_SILENTM_SuppDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Negative, request denied. Support unavailable - Out.";
		};



	class HAC_SILENTM_ArtAss1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Artillery support inbound - Out.";
		};

	class HAC_SILENTM_ArtAss2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Prepare for artillery barrage - Out.";
		};

	class HAC_SILENTM_ArtAss3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Fire mission dispatched. - Out.";
		};

	class HAC_SILENTM_ArtAss4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Artillery support inbound - Out.";
		};

	class HAC_SILENTM_ArtAss5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Fire mission in progress - Out.";
		};


	class HAC_SILENTM_ArtDen1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Negative, fire support unavailable at this time - Out.";
		};

	class HAC_SILENTM_ArtDen2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Fire mission impossible at this time - Out.";
		};

	class HAC_SILENTM_ArtDen3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Negative, artillery unavailable - Out.";
		};

	class HAC_SILENTM_ArtDen4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Fire mission request not possible - Out.";
		};

	class HAC_SILENTM_ArtDen5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Negative, fire support currently unavailable - Out.";
		};


	class HAC_SILENTM_OffStance1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "To all callsigns: Offensive formation in effect.";
		};

	class HAC_SILENTM_DefStance1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "To all callsigns: Deffensive formation in effect.";
		};


	class HAC_SILENTM_ArtFire1
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Firing for effect! - Out.";
		};

	class HAC_SILENTM_ArtFire2
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Shells on the way! - Out.";
		};

	class HAC_SILENTM_ArtFire3
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Fire mission in progress - Out.";
		};

	class HAC_SILENTM_ArtFire4
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Shells away - Out.";
		};

	class HAC_SILENTM_ArtFire5
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Fire Mission on target location - Out.";
		};



	class HAC_SILENTM_HQ_ord_attack
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Engage enemy forces (Infantry)";
		};

	class HAC_SILENTM_HQ_ord_attackNaval
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Engage enemy ships";
		};

	class HAC_SILENTM_HQ_ord_attackArmor
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Engage enemy forces (Armor)";
		};

	class HAC_SILENTM_HQ_ord_attackAir
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Provide Close Air Support";
		};

	class HAC_SILENTM_HQ_ord_attackAirCAP
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Perform Combat Air Patrol";
		};

	class HAC_SILENTM_HQ_ord_attackSnip
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Perform sniper mission";
		};

	class HAC_SILENTM_HQ_ord_recon
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Perform reconnaissance";
		};

	class HAC_SILENTM_HQ_ord_capture
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Secure objective";
		};

	class HAC_SILENTM_HQ_ord_captureNav
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Secure seas";
		};

	class HAC_SILENTM_HQ_ord_defend
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Take and hold defensive position";
		};

	class HAC_SILENTM_HQ_ord_defendR
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Patrol area and standby for orders";
		};

	class HAC_SILENTM_HQ_ord_defendRNav
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Patrol seas and standby for orders";
		};

	class HAC_SILENTM_HQ_ord_flank
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Outflank enemy forces";
		};

	class HAC_SILENTM_HQ_ord_ammoS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Deliver ammunition";
		};

	class HAC_SILENTM_HQ_ord_medS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Provide medevac";
		};

	class HAC_SILENTM_HQ_ord_fuelS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Deliver fuel";
		};

	class HAC_SILENTM_HQ_ord_repS
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Conduct field repairs";
		};

	class HAC_SILENTM_HQ_ord_idle
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static4ss.ogg", 1, 1};
		title = "Standby for orders";
		};

	class HAC_SILENTM_HQ_ord_withdraw
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static1ss.ogg", 1, 1};
		title = "Withdraw";
		};

	class HAC_SILENTM_HQ_ord_cargo
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static2ss.ogg", 1, 1};
		title = "Provide transport";
		};

	class HAC_SILENTM_HQ_ord_SF
		{
		name = "";
		sound[] = {"\NR6_HAL\Sound\Static3ss.ogg", 1, 1};
		title = "Perform tactical operation";
		};
	};
