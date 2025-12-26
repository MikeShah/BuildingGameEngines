/// @file: app.d
import sdl_abstraction;
import bindbc.sdl;
import std.stdio;
import widget;

void main()
{
    SDL_Window* window = SDL_CreateWindow("Dlang SDL3 GUI",640,480, SDL_WINDOW_ALWAYS_ON_TOP);
a
    // Create a hardware accelerated mRenderer
    SDL_Renderer* renderer = SDL_CreateRenderer(window,null);

	GuiState gui = GuiState(renderer);
	UI ui = new UI(&gui);	

//	Panel p1 = new Panel("",0,0,200,25);
//	p1.SetParent(ui);

	ui.AddChild(new Panel("Panel Text",0,0,200,400));
//	ui.AddChild(new Panel("",10,5,180,15));
	ui.AddChild(new Label("testing with some text",15,12));
	// Chaining is supported
	ui.AddChild(new Button("Button text",10,30,100,20))
	  .AddChild(new ButtonToggle("Toggle text",10,50,true))
	  .AddChild(new ButtonToggle("Toggle text",10,70,false));
	ui.AddChild(new Slider("Slider text",10,110,100,20,10.0f,0.0,100.0));

	DropDown d1 = new DropDown("Dropdown",10,150,100,20);
	d1.AddElement("test1");
	d1.AddElement("test2");
	d1.AddElement("test3");
	ui.AddChild(d1);
//	ui.AddChild(new DropDown("Dropdown",10,130,100,20));
	TreeView t1 = new TreeView("Tree View",10,240,180,120);
	TreeItem root =  new TreeItem("Root");
	t1.mRoot = root;
	root.AddChild(new TreeItem("tree item 1"))
		.AddChild(new TreeItem("tree item 2"))
		.AddChild(new TreeItem("tree item 3"));

	TreeItem secondLayer = new TreeItem("has children");
	root.AddChild(secondLayer);
	secondLayer.AddChild(new TreeItem("nested item 1"));
	secondLayer.AddChild(new TreeItem("nested item 2"));

	TreeItem nested1 = new TreeItem("one level");
	TreeItem nested2 = new TreeItem("two level");
	TreeItem nested3 = new TreeItem("three level");
	nested1.AddChild(nested2);
	nested2.AddChild(nested3);
	root.AddChild(nested1);

	ui.AddChild(t1);

	ui.MovePosition(20,30);

    bool gameIsRunning=true;
    while(gameIsRunning){

        // Store an SDL Event
        SDL_Event event;
        while(SDL_PollEvent(&event)){
            if(event.type == SDL_EVENT_QUIT){
                writeln("Exit event triggered");
                gameIsRunning= false;
            }
            if(event.type == SDL_EVENT_KEY_DOWN){
				ui.MovePosition(1,1);
				ui.Print();
            }
        }

        // Slow down the application for the purpose of this demo
        SDL_Delay(16);  
		
        SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
        // Clear the renderer each time we render
        SDL_RenderClear(renderer);

		gui.Update();
		ui.Render();

        // Final step is to present what we have copied into
        // video memory
        SDL_RenderPresent(renderer);
    }
    // Destroy our renderer
    SDL_DestroyRenderer(renderer);
    // Destroy our window
    SDL_DestroyWindow(window);
} // end main()
