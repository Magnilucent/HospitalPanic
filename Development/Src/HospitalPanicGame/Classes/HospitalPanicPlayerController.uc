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

exec function Parkour()
{

	local Actor  TraceHit;
	local vector HitLocation, HitNormal, StartTrace, EndTrace, Dir, PawnLocation;
	local rotator HitRotation, PawnRotation;
	local float TraceDist, TraceAdd;   //both of these values will be equivalent in uu's

	//A little wiggle room so the trace doesn't start too close to us
	TraceAdd = 5;
	//Max range for this trace
	TraceDist = 20;

	//Get Pawn's rotation
	PawnRotation = Pawn.Rotation;
	//Remove the pitch
	PawnRotation.Pitch = 0;
	//convert it to a vector
	Dir = vector(PawnRotation);

	//Multiply the pawn's rotation vector by TraceAdd so it doesn't start too close to the pawn, and add that to the pawn's location
	StartTrace = Pawn.Location + (Dir * TraceAdd);
	StartTrace.Z +=  Pawn.BaseEyeHeight + 5;
	//Same thing but multiply by the TraceDistance to find our end point
	EndTrace = StartTrace + (Dir * TraceDist); 
	//Throw the trace    
	TraceHit = Trace(HitLocation, HitNormal, StartTrace, EndTrace, true);
	//Draw It
	DrawDebugLine(StartTrace, EndTrace,255,0,255,true);

	if (TraceHit != none) //something was hit, exit the function
	{
		return;
	}
	else //nothing was hit, maybe it is an air duct!
	{
		//Throw a trace downwards from the end of the last trace to try to find a floor.
		StartTrace = EndTrace;
		EndTrace.Z -= 10;
		
		TraceHit = Trace(HitLocation, HitNormal, StartTrace, EndTrace, true);
		//Draw It
		DrawDebugLine(StartTrace, EndTrace,255,0,255,true);
		
		if ( TraceHit == none ) //nothing hit... probably just air
		{
			return;
		}
		else //Cool! Probably an air duct
		{
			//Used later to lock the pawn to the height of the duct
			PawnLocation.Z = HitLocation.Z - Pawn.BaseEyeHeight;
		   
			//This trace is just to make the pawn face the wall.
			StartTrace = Pawn.Location + (Dir * TraceAdd);
		   
			//Make the trace under the floor we found
			StartTrace.Z = HitLocation.Z - 5;
		   
			EndTrace = StartTrace + (Dir * TraceDist);
			
			TraceHit = Trace(HitLocation, HitNormal, StartTrace, EndTrace, true);
			
			if ( TraceHit != none ) //there should always be a wall under a vent (for now)
			{
				//Getting ready to make the pawn face the wall.
				HitRotation = rotator(HitNormal);
				
				//We don't want to change the pitch or roll.
				HitRotation.Pitch = Pawn.Rotation.Pitch;
				HitRotation.Roll = Pawn.Rotation.Roll;
				
				//Changing pawn's rotation.
				Pawn.SetViewRotation(HitRotation);
			   
				//For moving the pawn to the wall.
				PawnLocation.X = HitLocation.X;
				PawnLocation.Y = HitLocation.Y;
				
				//Backing the new pawn location up so it isn't inside the wall when we move it
				PawnLocation += -(HitNormal*Pawn.CylinderComponent.CollisionRadius);
				
				//Setting the pawn to the new "hanging" location.
				Pawn.SetLocation(PawnLocation);
				
				GotoState('PlayerHanging');
			}
		}
	}
}

//Used when player is hanging off a ledge.
state PlayerHanging
{
	event BeginState(Name PreviousStateName)
	{
		//We don't want gravity to affect the pawn right now
		Pawn.SetPhysics(PHYS_Flying);
		//Freeze pawn at location.
		Pawn.Acceleration = vect(0,0,0);
		Pawn.velocity = vect(0,0,0);
	}
	
	function PlayerMove(float DeltaTime)
	{
		if ( Pawn == None )
		{
			return;
		}
		
		if ( bPressedJump )
		{
			//Leave the hanging state
			Pawn.SetPhysics(PHYS_Walking);
			GotoState(Pawn.LandMovementState);
		}
		
		bPressedJump = false;
	}
}
