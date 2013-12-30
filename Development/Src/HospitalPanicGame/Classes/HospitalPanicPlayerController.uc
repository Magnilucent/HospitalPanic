/**
 * Copyright 1998-2013 Epic Games, Inc. All Rights Reserved.
 */
class HospitalPanicPlayerController extends GamePlayerController
	config(Game);

/**
 * Requests that the pawn crouch
 */
exec function Duck()
{
	Pawn.ShouldCrouch(true);
}

/**
 * Requests that the pawn uncrouch
 */
exec function UnDuck()
{
	Pawn.ShouldCrouch(false);
}