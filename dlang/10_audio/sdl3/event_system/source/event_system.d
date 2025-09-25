import sprite;

// Enum representing possible event types we can check against;
// Enums are more 'type-safe' than regular integers'.
// Enums are also useful otherwise for making sure 'switch statements'
// (see later 'Handle Event' can otherwise catch all cases without us forgetting)
enum EventEnum : uint {NOP,MOVE_SPRITE, PLAY_SOUND};

/// One event 
union Event{
	// Every event has at a minimum a 'type' for the first bits.
	// This is important so we can distinguish between event types.
	EventEnum type;

	NOP 		nop_event;
	MoveSprite 	move_sprite_event;
	PlaySound  	play_sound_event;
}

/////////////////////////////////////////
//          All of the event types    ///
/////////////////////////////////////////
struct NOP{ // 'no op' -- i.e. no operation or an empty event
	EventEnum event= EventEnum.NOP;
}
struct MoveSprite{
	EventEnum event= EventEnum.MOVE_SPRITE;
	Sprite* mSpritePtr; // Sprite we want to move
	float x,y;	
}	
struct PlaySound{
	EventEnum event= EventEnum.PLAY_SOUND;
	int soundID;	
}	

/// Giant switch statement to handle all of the events.
void HandleEvent(Event e){
	final switch (e.type){
		case EventEnum.MOVE_SPRITE:
			e.move_sprite_event.mSpritePtr.MoveSprite(e.move_sprite_event.x,e.move_sprite_event.y);
			break;
		case EventEnum.NOP:
			break;
		case EventEnum.PLAY_SOUND:
			break;
	}
}
