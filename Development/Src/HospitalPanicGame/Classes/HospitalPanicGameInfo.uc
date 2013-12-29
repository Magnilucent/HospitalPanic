/**
 * Copyright 1998-2013 Epic Games, Inc. All Rights Reserved.
 */
class HospitalPanicGameInfo extends GameInfo;

auto State PendingMatch
{
Begin:
	StartMatch();
}

defaultproperties
{
	HUDType=class'GameFramework.MobileHUD'
	PlayerControllerClass=class'HospitalPanicGame.HospitalPanicPlayerController'
	DefaultPawnClass=class'HospitalPanicGame.HospitalPanicPawn'
	bDelayedStart=false
}


