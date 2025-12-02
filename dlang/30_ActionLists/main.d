import component, gameobject,action;

void main(string[] args){

	GameObject go;
	go.AddComponent("action");
	go.AddComponent("texture");
	go.AddComponent("collider");

	go.GetComponent!ComponentAction("action").AddAction(new OneTimeAction("One Named Action"));
	go.GetComponent!ComponentAction("action").AddAction(new RepeatingAction("Repeating Action Algorithm",3));
	go.GetComponent!ComponentAction("action").AddAction(new OneTimeAction("Last Action queued up"));

	int updates=7;
	// Simulate a loop that runs X number of times
	while(updates>0){
		go.Update();
		updates--;
	}

}
