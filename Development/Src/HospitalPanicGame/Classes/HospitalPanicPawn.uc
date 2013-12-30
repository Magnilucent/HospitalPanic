/**
 * Copyright 1998-2013 Epic Games, Inc. All Rights Reserved.
 */
class HospitalPanicPawn extends GamePawn
	config(Game);

defaultproperties
{
	// Flags
	bCanCrouch=true
	
	// Locomotion
	GroundSpeed=+00200.000000
	JumpZ=+00240.000000
	
	CrouchedPct=+0.30
	WalkingPct=+1.0
	
	// Collision
	BaseEyeHeight=+00029.000000
	EyeHeight=+00027.000000
	
	CrouchHeight=+14.0
	CrouchRadius=+10.0
	
	Begin Object Name=CollisionCylinder
        CollisionRadius=+0010.000000
        CollisionHeight=+0032.000000
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CollisionCylinder
    CylinderComponent=CollisionCylinder
    Components.Add(CollisionCylinder)
}