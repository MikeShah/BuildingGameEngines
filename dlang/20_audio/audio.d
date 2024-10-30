// @file audio.d

struct Audio{
    static void PlaySound(int id, int volumeDB){
        int channel = findOpenChannel();
        if(channel == -1){
            return;
        }

        ResourceID resource = loadSound(id);
        startSound(resource,channel,volume);
    }
}


struct AudioFixed{

    int head=0;
    int tail=0;

    static void Init(){
        numPending =0;
    }

    void PlaySound(int id, int volumeDB){
        assert(tail+1 & MAX_PENDING != head,"Too many sounds!");

        pending[tail].id = id;
        pending[tail].volume = volumeDB;
        tail = (tail+1) % MAX_PENDING;
    }

    static void Update(){
        // If no pending requests, then do nothing
        if(head = tail) { return;}

        int channel = findOpenChannel();
        if(channel == -1){ return;}

        ResourceId resource = loadSound(pending[head].id);
        startSound(resource,channel,pending[head].volume);

        head = (head + 1 ) % MAX_PENDING;
    }

    static immutable MAX_PENDING=16;
    static shared numPending;
    static shared PlayMessage pending[MAX_PENDING};
}

struct PlayMessage{
    SoundId id;
    int volume;
}


void main(){}
