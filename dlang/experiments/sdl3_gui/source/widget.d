// @file: widget.d
import bindbc.sdl;
import std.stdio,std.string,std.conv; // for toZString

// Overridable event handler class
class Event{

}
// alias for events
//alias EventHandler = bool delegate(Event event);
alias EventHandler = bool delegate();

/// A bunch of state 
struct DefaultState{
	bool leftMouseDown = false;
	bool rightMouseDown = false;
	bool leftMouseDrag = false;
	bool rightMouseDrag = false;

	void Reset(){
		this = DefaultState();
	}
}

/// Holds global Graphical User Interface State
/// NOTE: TODO This could also hold things like 'commands' or
///       perhaps other widget events
struct GuiState{
	SDL_Renderer* mRenderer;

	float mouseX,mouseY;	
	DefaultState mState;

	/// Pass in the renderer for SDL to store it
	this(SDL_Renderer* renderer){
		mRenderer = renderer;
	}

	/// TODO Need to figure out how to invalidate other events
	///      and mouse presses if they're not over the GUI.
	/// 	 i.e. I could just call 'update' from within a 'UI' widget, and then
	///           have the bounds there. Then I would not need to even call 'Update' anywhere.
	SDL_Event Update(){
		// Reset the state at the start of every update
		//mState.Reset();

		SDL_GetMouseState(&mouseX, &mouseY);

		// Listen for events
		// TODO: Need to consider if the event should be copied back
		//		 to the event queue, so that the user application can otherwise
		//		 handle the event.
		SDL_Event event;
		SDL_PollEvent(&event);
		if(event.type == SDL_EVENT_MOUSE_MOTION){
			if(mState.leftMouseDown){
				SDL_Log("left button dragged %d",event.button.button);
				mState.leftMouseDrag = true;
			}
			if(mState.rightMouseDown){
				SDL_Log("right button dragged %d",event.button.button);
				mState.rightMouseDrag = true;
			}
		}
		if(event.type == SDL_EVENT_MOUSE_BUTTON_UP){
			if(mState.leftMouseDown){
				SDL_Log("left button up %d",event.button.button);
				mState.leftMouseDown =false;
				mState.leftMouseDrag =false;
			}
			if(mState.rightMouseDown){
				SDL_Log("right button up %d",event.button.button);
				mState.rightMouseDown =false;
				mState.rightMouseDrag =false;
			}
		}
		if(event.type == SDL_EVENT_MOUSE_BUTTON_DOWN){
			if(event.button.button == SDL_BUTTON_LEFT){
				SDL_Log("left button clicked %d",event.button.button);
				mState.leftMouseDown =true;
			}
			if(event.button.button == SDL_BUTTON_RIGHT){
				SDL_Log("right button clicked %d",event.button.button);
				mState.rightMouseDown =true;
			}
		}
		return event;
	}
}

struct Color{
	ubyte r,g,b,a;
}

/// All UI elements have the following
abstract class Widget{
	Widget mParent=null; 	// Keep track of the parent
	Widget[] mChildren;		// Any children of the Widget
	string mText="";		// Any text associated with the widget
	SDL_FRect mRect;		// The rectangle representing where to render the widget
							// This also represents the 'clickable' surface
	Color mColorForeground;
	Color mColorBackground;

	// Data associated with widgets
	// TODO -- may have to abstract these elsewhere
	bool mChecked=false;		// for toggable things. TODO Consider if this should be 'state' later?
	float mValue=0.0f;			//
	float mMinValue=0.0f;			//
	float mMaxValue=0.0f;			//

	// Events that a widget can handle
	EventHandler mEventHandlerClick = null;
	EventHandler mEventHandlerHover = null;
	EventHandler mEventHandlerItemSelected = null;
	EventHandler mEventHandlerValueChanged = null;
	EventHandler mEventHandlerOnScrollChanged = null;

	/// Add a child node
	typeof(this) AddChild(Widget w){
		this.mChildren ~= w;
		w.mParent = this;

		return this;
	}

	/// Sets the parent widget
	/// Makes this item a child of the widget.
	/// TODO: Check that child is not already part mChildren collection
	final void SetParent(Widget p){
		this.mParent = p;
		p.mChildren ~= this;;
	}
	/// Positions are always relative to the parent.
	/// If there is no parent, then this is the 'absolute' position within the
	/// window coordinates.
	void MovePosition(float x, float y){
		mRect.x = x;
		mRect.y = y;
	}
	/// Set the size of the widge in terms of pixels
	final void SetSize(float w, float h){
		mRect.w = w;
		mRect.h = h;
	}
	/// Set the text for the widget
	/// Note: If there is no immediate text, then this will be used for a 'tooltip'
	///       perhaps in the future. TODO
	final void SetText(string text){
		this.mText = text;
	}
	final void SetChecked(bool checked){
		this.mChecked = checked;
	}
	final void SetValue(float v){
		this.mValue = v;
	}
	final void SetMinValue(float v){
		this.mMinValue = v;
	}
	final void SetMaxValue(float v){
		this.mMaxValue = v;
	}
	final void SetStrokeColor(ubyte r, ubyte g, ubyte b, ubyte a){
		this.mColorForeground.r = r;
		this.mColorForeground.g = g;
		this.mColorForeground.b = b;
		this.mColorForeground.a = a;
	}
	final void SetOpacity(ubyte a){
		this.mColorForeground.a = a;
	}
	final void SetEventClickHandler(EventHandler handlerDelegate){
		mEventHandlerClick = handlerDelegate;
	}
	final void SetEventHoverHandler(EventHandler handlerDelegate){
		mEventHandlerHover = handlerDelegate;
	}
	final void SetEventItemSelectedHandler(EventHandler handlerDelegate){
		mEventHandlerItemSelected = handlerDelegate;
	}
	final void SetEventValueChangedHandler(EventHandler handlerDelegate){
		mEventHandlerValueChanged = handlerDelegate;
	}
	final void SetEventOnScrollHandler(EventHandler handlerDelegate){
		mEventHandlerOnScrollChanged = handlerDelegate;
	}

	void Render(GuiState* guiState);

	/// TODO: Find the fields automatically later on
	void Print(){
		writeln("Parent: ",mParent);
		writeln("Text: ",mText);
		writeln("(x,y): (",mRect.x,",",mRect.y,")");
		writeln("(w,h): (",mRect.w,",",mRect.h,")");
		writeln("Foreground: (r,g,b,a): (",mColorForeground.r,",",mColorForeground.g,",",mColorForeground.b,",",mColorForeground.a,")");
		writeln("Background: (r,g,b,a): (",mColorBackground.r,",",mColorBackground.g,",",mColorBackground.b,",",mColorBackground.a,")");
		writeln("children: ",mChildren);
	}
}

/// UI Can have 'child' widgets grouped under it.
/// Positions are set as 'absolute' positions
class UI : Widget{
	GuiState* mGuiState;

	// Which GUI state we register events from
	this(GuiState* guiState){
		mGuiState = guiState;
	}

	/// Sets the guiState and then calls render
	override void Render(GuiState* guiState){
		mGuiState = guiState;
		Render();	
	}
	/// Positions are always relative to the parent.
	/// If there is no parent, then this is the 'absolute' position within the
	/// window coordinates.
	override void MovePosition(float x, float y){
		mRect.x += x;
		mRect.y += y;	
		foreach(child ; mChildren){
			float newX = child.mRect.x + x;
			float newY = child.mRect.y + y;
			child.MovePosition(newX,newY);
		}
	}

	// Draw all child widgets	
	void Render(){
		foreach(child ; mChildren){
			// Render the child node
			child.Render(mGuiState);
		}
	}
}

class Button : Widget{
	this(string text,float x, float y, float w, float h){
		SetText(text);
		MovePosition(x,y);
		SetSize(w,h);
		// Default stroke color
		SetStrokeColor(0,0,0,255);
	}
	override void Render(GuiState* guiState){
		SDL_FPoint mouse = SDL_FPoint(guiState.mouseX,guiState.mouseY);

		if(SDL_PointInRectFloat(&mouse, &mRect)){
			SDL_SetRenderDrawColor(guiState.mRenderer, 192,192,192,128);
			// Handle the button press
			if(guiState.mState.leftMouseDown){
				SDL_SetRenderDrawColor(guiState.mRenderer, 164,164,164,128);
				if(mEventHandlerClick){
					mEventHandlerClick();
				}
				guiState.mState.Reset(); // Handle only one click
			}
		}else{
			SDL_SetRenderDrawColor(guiState.mRenderer, mColorForeground.r,mColorForeground.g,mColorForeground.b,mColorForeground.a);
		}
		SDL_RenderFillRect(guiState.mRenderer, &mRect);

		// Draw the button text
		if(mText.length >0){
			SDL_SetRenderDrawColor(guiState.mRenderer, 255,255,255,mColorForeground.a);
			SDL_RenderDebugText(guiState.mRenderer, mRect.x+2, mRect.y+2, mText.toStringz);
		}
	}
}

class ButtonToggle : Widget{
	this(string text,float x, float y, bool checked){
		SetText(text);
		MovePosition(x,y);
		SetChecked(checked);
		// Default stroke color
		SetStrokeColor(0,0,0,255);
	}
	override void Render(GuiState* guiState){
		SDL_FPoint mouse = SDL_FPoint(guiState.mouseX,guiState.mouseY);

		// toggable button
		SDL_FRect toggleRect = SDL_FRect(mRect.x,mRect.y,20,20);

		if(SDL_PointInRectFloat(&mouse, &toggleRect)){
			SDL_SetRenderDrawColor(guiState.mRenderer, 64,64,64,128);
			// Toggle the checkmark if the left mouse is down
			if(guiState.mState.leftMouseDown){
				mChecked = !mChecked;	
				if(mEventHandlerClick){
					mEventHandlerClick();
				}
				guiState.mState.Reset(); // Handle only one click
			}
		}else{
			SDL_SetRenderDrawColor(guiState.mRenderer, mColorForeground.r,mColorForeground.g,mColorForeground.b,mColorForeground.a);
		}
		SDL_RenderFillRect(guiState.mRenderer, &toggleRect);

		if(mChecked){
			SDL_FRect toggleRectcheck = SDL_FRect(mRect.x+3,mRect.y+3,14,14);
			SDL_SetRenderDrawColor(guiState.mRenderer, 255,255,255,255);
			SDL_RenderFillRect(guiState.mRenderer, &toggleRectcheck);
		}

		// Draw the toggle button text
		if(mText.length >0){
			SDL_SetRenderDrawColor(guiState.mRenderer,255,255,255,mColorForeground.a);
			SDL_RenderDebugText(guiState.mRenderer, mRect.x+22, mRect.y+4, mText.toStringz);
		}
	}
}

class Slider: Widget{
	this(string text,float x, float y,float w, float h, float value, float minValue, float maxValue){
		SetText(text);
		MovePosition(x,y);
		SetSize(w,h);
		SetValue(value);
		SetMinValue(minValue);
		SetMaxValue(maxValue);
		assert(maxValue > minValue, "max value for slider is greater than minimum value. This will cause an error when rendering the slider widget, please fix.");

		// Default stroke color
		SetStrokeColor(0,0,0,255);
	}
	override void Render(GuiState* guiState){
		SDL_FPoint mouse = SDL_FPoint(guiState.mouseX,guiState.mouseY);

		// Position the sliderRectSelect proportionally between the min and max values
		float pixelSliderRatio = (mMaxValue - mMinValue) / mRect.w;
		float sliderOffset = mRect.x + (mValue*pixelSliderRatio);

		// Slider button
		SDL_FRect sliderRect		= SDL_FRect(mRect.x,mRect.y+5,100,10);
		SDL_FRect sliderRectSelect	= SDL_FRect(sliderOffset,mRect.y,10,20);
		SDL_FRect sliderRectBackground = SDL_FRect(mRect.x,mRect.y,100,20);

		SDL_SetRenderDrawBlendMode(guiState.mRenderer, SDL_BLENDMODE_BLEND);
		SDL_SetRenderDrawColor(guiState.mRenderer, 32,32,32,64);
		SDL_RenderFillRect(guiState.mRenderer, &sliderRectBackground);

		SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,255);
		SDL_RenderFillRect(guiState.mRenderer, &sliderRect);
		SDL_SetRenderDrawBlendMode(guiState.mRenderer, SDL_BLENDMODE_NONE);

		// slider selection
		// TODO
		// May want to consider 'snapping' to the nearest integer, or otherwise
		// allowing manual 'input' for the slider
		if(SDL_PointInRectFloat(&mouse, &sliderRectSelect)){
			SDL_SetRenderDrawColor(guiState.mRenderer, 192,192,192,128);
		}else{
			SDL_SetRenderDrawColor(guiState.mRenderer, 64,64,64,255);
		}

		// Slider set value
		if(SDL_PointInRectFloat(&mouse, &sliderRectBackground) && guiState.mState.leftMouseDown){
			// Figure out where we clicked
			float distanceAlongSlider = mouse.x - sliderRect.x;
			mValue = distanceAlongSlider * pixelSliderRatio;
		}

		//
		SDL_RenderFillRect(guiState.mRenderer, &sliderRectSelect);

		// Draw the toggle button text
		if(mText.length >0){
			SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,mColorForeground.a);
			SDL_RenderDebugText(guiState.mRenderer, mRect.x, mRect.y-10, mText.toStringz);
			SDL_SetRenderDrawColor(guiState.mRenderer, 255,255,255,255);
			SDL_RenderDebugText(guiState.mRenderer, mRect.x, mRect.y, mValue.to!string.toStringz);
		}
	}
}
class Label : Widget{
	this(string text,float x, float y, float w, float h){
		SetText(text);
		MovePosition(x,y);
		SetSize(w,h);
		// Default stroke color
		SetStrokeColor(0,0,0,255);
	}
	override void Render(GuiState* guiState){
		SDL_SetRenderDrawBlendMode(guiState.mRenderer, SDL_BLENDMODE_BLEND);
		SDL_SetRenderDrawColor(guiState.mRenderer, 192,192,192,192);
		SDL_RenderFillRect(guiState.mRenderer, &mRect);
		SDL_SetRenderDrawBlendMode(guiState.mRenderer, SDL_BLENDMODE_NONE);

		SDL_SetRenderDrawColor(guiState.mRenderer, mColorForeground.r,mColorForeground.g,mColorForeground.b,mColorForeground.a);
		SDL_RenderDebugText(guiState.mRenderer, mRect.x+2, mRect.y+2, mText.toStringz);
	}
}

class Panel : Widget{
	this(string text, float x, float y, float w, float h){
		SetText(text);
		MovePosition(x,y);
		SetSize(w,h);
		// Default stroke color
		SetStrokeColor(0,192,0,64);
	}
	override void Render(GuiState* guiState){
		SDL_FPoint mouse = SDL_FPoint(guiState.mouseX,guiState.mouseY);

		SDL_SetRenderDrawBlendMode(guiState.mRenderer, SDL_BLENDMODE_BLEND);

		if(SDL_PointInRectFloat(&mouse, &mRect)){
			SDL_SetRenderDrawColor(guiState.mRenderer, mColorForeground.r,mColorForeground.g,mColorForeground.b,128);
		}else{
			SDL_SetRenderDrawColor(guiState.mRenderer, mColorForeground.r,mColorForeground.g,mColorForeground.b,mColorForeground.a);
		}
		SDL_RenderFillRect(guiState.mRenderer, &mRect);
		SDL_SetRenderDrawBlendMode(guiState.mRenderer, SDL_BLENDMODE_NONE);

		// Title bar
		if(mText.length >0){
			DrawTitleBar(guiState.mRenderer, mText, mRect.x, mRect.y-12, mRect.w, 12);
		}
	}
}

class DropDown : Widget{
	string[] mElements;
	bool mIsOpen=false; // Is the DropDown 'open'
	int mLastIndexSelected = -1;	// No index selected
	long mFirstRenderedElementIndex;

	this(string text, float x, float y, float w, float h){
		SetText(text);
		MovePosition(x,y);
		SetSize(w,h);
		// Default stroke color
		SetStrokeColor(0,192,0,64);
	}

	// TODO: Change this 
	// 
	void AddElement(string temp){
		mElements ~= temp;
	}

	override void Render(GuiState* guiState){
		SDL_SetRenderDrawBlendMode(guiState.mRenderer, SDL_BLENDMODE_BLEND);

		SDL_FPoint mouse = SDL_FPoint(guiState.mouseX,guiState.mouseY);

		// Clickable Range
		SDL_FRect clickableRange = mRect;
		clickableRange.h = mRect.h + 20;
		
		bool isHovered = SDL_PointInRectFloat(&mouse, &clickableRange);

		if(isHovered){
			if(guiState.mState.leftMouseDown && !mIsOpen){
				mIsOpen = !mIsOpen;
				guiState.mState.Reset();
				return;
			}
		}

		// Render the last selected element below in the dropdown
		SDL_FRect lastSelected = SDL_FRect(mRect.x,mRect.y+20,mRect.w,mRect.h);
		SDL_SetRenderDrawColor(guiState.mRenderer, 255,255,255,128);
		SDL_RenderFillRect(guiState.mRenderer, &lastSelected);
		SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,255);
		SDL_RenderRect(guiState.mRenderer, &lastSelected);
		SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,255);
		if(!mIsOpen){
			if(mLastIndexSelected != -1){
				SDL_RenderDebugText(guiState.mRenderer, lastSelected.x+2, lastSelected.y+2, mElements[mLastIndexSelected].toStringz);
			}else if(mLastIndexSelected==-1){
				SDL_RenderDebugText(guiState.mRenderer, lastSelected.x+lastSelected.w/2, lastSelected.y+2, "-".toStringz);
			}
		}

		// Stays 'shown' when hovered or clicked so that further elements can then be selected.
		// TODO Fix render 'ordering' of the elements -- perhaps in a seperate pass to figure
		//      out how to get things to overlay properly?
		long widthOfScrollbar=10;
		if(mIsOpen){
			foreach(idx,elem; mElements[mFirstRenderedElementIndex..$]){
				// Limit ourselves to only displaying 3 items
				if(idx>3){
					break;
				}

				SDL_FRect r = SDL_FRect(mRect.x,mRect.y+(idx+1)*20,mRect.w-widthOfScrollbar,mRect.h);
				// If mouse is in the selected element
				if(SDL_PointInRectFloat(&mouse, &r)){
					SDL_SetRenderDrawColor(guiState.mRenderer, 255,255,255,128);
					SDL_RenderFillRect(guiState.mRenderer, &r);
					// Select the element 
					if(guiState.mState.leftMouseDown){
						mIsOpen = false;
						// Execute the event handler for the selected item.
						if(mEventHandlerItemSelected){
							writeln("Detected a left-click on element:",elem);
							mEventHandlerItemSelected();
							mLastIndexSelected = cast(int)idx; // update index of selected element
						}
						guiState.mState.Reset();
					}
				}else{
					SDL_SetRenderDrawColor(guiState.mRenderer, 192,192,192,255);
					SDL_RenderFillRect(guiState.mRenderer, &r);
				}
				SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,255);
				SDL_RenderRect(guiState.mRenderer, &r);
				SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,255);
				SDL_RenderDebugText(guiState.mRenderer, r.x+2, r.y+2, elem.toStringz);
			}

			// Draw a scrollbar on the right	
			// tempRect is a 'hack' to make the 'size' of the total rectangle
			SDL_FRect tempRect = SDL_FRect(mRect.x,mRect.y+mRect.h,mRect.w,mRect.h*3);	// rectangle + 4 elements
			SDL_FRect backgroundBar = SDL_FRect (tempRect.x+tempRect.w-10,tempRect.y,10,tempRect.h);
			SDL_FRect topBar 		= SDL_FRect (tempRect.x+tempRect.w-10,tempRect.y,10,10);
			SDL_FRect bottomBar 	= SDL_FRect (tempRect.x+tempRect.w-10,tempRect.y+tempRect.h-10,10,10);

			SDL_SetRenderDrawColor(guiState.mRenderer, 192,192,192,255);
			SDL_RenderFillRect(guiState.mRenderer,&backgroundBar);

			SDL_SetRenderDrawColor(guiState.mRenderer, 32,32,32,255);
			SDL_RenderFillRect(guiState.mRenderer,&topBar);
			SDL_RenderFillRect(guiState.mRenderer,&bottomBar);

			if(SDL_PointInRectFloat(&mouse, &topBar) && guiState.mState.leftMouseDown){
				mFirstRenderedElementIndex--;
				if(mFirstRenderedElementIndex<0){
					mFirstRenderedElementIndex=0;
				}
				guiState.mState.Reset(); // Handle scroll up
			}
			else if(SDL_PointInRectFloat(&mouse, &bottomBar) && guiState.mState.leftMouseDown){
				mFirstRenderedElementIndex++;
				if(mFirstRenderedElementIndex>mElements.length-1){
					mFirstRenderedElementIndex=mElements.length-1;
				}
				guiState.mState.Reset(); // Handle scroll down 
			}else if(SDL_PointInRectFloat(&mouse, &backgroundBar)){
				// Render a line to indicate where you are
				SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,255);
				SDL_RenderLine(guiState.mRenderer, backgroundBar.x, mouse.y, backgroundBar.x+backgroundBar.w,mouse.y);	
				if(guiState.mState.leftMouseDown | guiState.mState.leftMouseDrag){
					// Calculate roughly where to position.

					float percentageHeight = ((mouse.y -backgroundBar.y) / backgroundBar.h) * mElements.length;
					writeln("percentageHeight = ",percentageHeight);
					mFirstRenderedElementIndex = cast(long)percentageHeight;

	//				guiState.mState.Reset(); // Handle scroll down 
				}
			}
		}

		// If mouse clicked outside of expanded dropdown, then close it.
		SDL_FRect maxClickableRect = SDL_FRect(mRect.x,mRect.y,mRect.w,mRect.h);
		// The '+1' is for the 'last selected element'
		foreach(idx; 0 .. mElements.length + 1){
			maxClickableRect.h += 20; // TODO: '20' is arbitrary
		}
		
		// Close dropdown
		// Don't reset gui state, because we may be doing something else since we are
		// outside of dropdown.
		if(!SDL_PointInRectFloat(&mouse, &maxClickableRect) && guiState.mState.leftMouseDown){
			mIsOpen = false;
		}
			

		// Title bar
		if(mText.length >0){
			DrawTitleBar(guiState.mRenderer, mText, mRect.x, mRect.y,mRect.w, mRect.h);
		}
	}
}

class TreeItem{
	string mText;
	int mDepth =1;
	TreeItem[] mItems;
	bool mExpanded = false;	// By default do not expand out all children

	this(string text){
		mText = text;
		mExpanded = false;
	}

	typeof(this) AddChild(TreeItem item){
		item.mDepth = this.mDepth+1;	// increase the depth for each child automatically
		mItems ~= item;
		return this;
	}
}

class TreeView : Widget{
	TreeItem mRoot;
	long mFirstRenderedElementIndex=0;

	this(string text, float x, float y, float w, float h){
		SetText(text);
		MovePosition(x,y);
		SetSize(w,h);
		// Default stroke color
		SetStrokeColor(255,255,255,64);
	}

	override void Render(GuiState* guiState){
		SDL_FPoint mouse = SDL_FPoint(guiState.mouseX,guiState.mouseY);

		SDL_SetRenderDrawColor(guiState.mRenderer, 255,255,255,64);
		SDL_RenderFillRect(guiState.mRenderer, &mRect);
		//Draw an outline when we hover over
		if(SDL_PointInRectFloat(&mouse, &mRect)){
			SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,128);
			SDL_RenderRect(guiState.mRenderer, &mRect);
		}

		// Skip entire traversal if there is no root node to render
		if(mRoot is null){
			return;
		}
		// Do breadth-first traversal to render tree view
		// The 'bfs' is the resulting tree that we can then just iterate through
		// linearly.
		TreeItem[] tempbfs;
		TreeItem[] bfs;
		tempbfs ~= mRoot;
		mRoot.mExpanded = true; // By default, always expand out the root node

		// Now do the bfs
		// TODO: May need to do depth-first traversal here to properly handle renderig
		//       and folding of nodes. Change to stack?
		while(tempbfs.length>0){
			TreeItem front = tempbfs[0];
			tempbfs = tempbfs[1 .. $]; // pop element
			bfs ~= front;
			// Append the children, but we 'prepend them'
			if(front.mExpanded){
				foreach(child ; front.mItems){
					child.mDepth = front.mDepth+1;
					// prepend the node so that it will render in order
					tempbfs = child ~ tempbfs;
					//					tempbfs ~= child;
				}	
			}
		}

		// Repromote any 'child nodes in the 'tempbfs' to ensure they do not
		// fall under expanded nodes
		import std.algorithm;
		//		bfs.sort!("a.mText < b.mText");

		int elementRenderHeight = 15;
		int scrollBarWidth = 10;
		SDL_FRect r;
		foreach(idx,elem; bfs[mFirstRenderedElementIndex..$]){
			SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,255);

			float xIndent = 2+mRect.x+elem.mDepth*10; 
			float yIndent = 2+mRect.y+idx*elementRenderHeight;
			r = SDL_FRect(xIndent,yIndent,mRect.w - elem.mDepth*10 - scrollBarWidth, elementRenderHeight);
			// Terminate rendering of child elements if they go out of bounds.
			if(yIndent > mRect.y+mRect.h){
				break;
			}
			// Draw a plus sign next to nodes that can be expanded
			if(elem.mExpanded == false && elem.mItems.length > 0){
				SDL_RenderLine(guiState.mRenderer, xIndent-9, yIndent+3, xIndent-2,yIndent+3);	
				SDL_RenderLine(guiState.mRenderer, xIndent-6, yIndent, xIndent-6,yIndent+6);	
				SDL_FRect box = SDL_FRect(xIndent-11,yIndent-1,10,10);
				SDL_RenderRect(guiState.mRenderer,&box);
			}else if (elem.mExpanded == true && elem.mItems.length >0){
				SDL_RenderLine(guiState.mRenderer, xIndent-9, yIndent+3, xIndent-2,yIndent+3);	
				SDL_FRect box = SDL_FRect(xIndent-11,yIndent-1,10,10);
				SDL_RenderRect(guiState.mRenderer,&box);
			}

			// Hover over
			if(SDL_PointInRectFloat(&mouse, &r)){
				SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,255);
				SDL_RenderRect(guiState.mRenderer,&r);

				// toggle expanding the child nodes
				if(guiState.mState.leftMouseDown){
					writeln("Clicked on:",elem.mText);
					elem.mExpanded = !elem.mExpanded;
					if(mEventHandlerClick){
						mEventHandlerClick();
					}
					guiState.mState.Reset(); // Handle only one click
				}
			}
			SDL_RenderDebugText(guiState.mRenderer, r.x, r.y, elem.mText.toStringz);
		}

		// Draw a scrollbar on the right	
		SDL_FRect backgroundBar = SDL_FRect (mRect.x+mRect.w-scrollBarWidth,mRect.y,10,mRect.h);
		SDL_FRect topBar 		= SDL_FRect (mRect.x+mRect.w-scrollBarWidth,mRect.y,10,10);
		SDL_FRect bottomBar 	= SDL_FRect (mRect.x+mRect.w-scrollBarWidth,mRect.y+mRect.h-10,10,10);

		SDL_SetRenderDrawColor(guiState.mRenderer, 192,192,192,255);
		SDL_RenderRect(guiState.mRenderer,&backgroundBar);

		SDL_SetRenderDrawColor(guiState.mRenderer, 32,32,32,255);
		SDL_RenderFillRect(guiState.mRenderer,&topBar);
		SDL_RenderFillRect(guiState.mRenderer,&bottomBar);

		if(SDL_PointInRectFloat(&mouse, &topBar) && guiState.mState.leftMouseDown){
			mFirstRenderedElementIndex--;
			if(mFirstRenderedElementIndex<0){
				mFirstRenderedElementIndex=0;
			}
			guiState.mState.Reset(); // Handle scroll up
		}
		else if(SDL_PointInRectFloat(&mouse, &bottomBar) && guiState.mState.leftMouseDown){
			mFirstRenderedElementIndex++;
			if(mFirstRenderedElementIndex>bfs.length-1){
				mFirstRenderedElementIndex=bfs.length-1;
			}
			guiState.mState.Reset(); // Handle scroll down 
		}else if(SDL_PointInRectFloat(&mouse, &backgroundBar)){
			// Render a line to indicate where you are
			SDL_SetRenderDrawColor(guiState.mRenderer, 0,0,0,255);
			SDL_RenderLine(guiState.mRenderer, backgroundBar.x, mouse.y, backgroundBar.x+backgroundBar.w,mouse.y);	
			if(guiState.mState.leftMouseDown | guiState.mState.leftMouseDrag){
				// Calculate roughly where to position.

				float percentageHeight = ((mouse.y -backgroundBar.y) / backgroundBar.h) * bfs.length;
				writeln("percentageHeight = ",percentageHeight);
				mFirstRenderedElementIndex = cast(long)percentageHeight;

//				guiState.mState.Reset(); // Handle scroll down 
			}
		}

		// Title bar
		if(mText.length >0){
			DrawTitleBar(guiState.mRenderer, mText, mRect.x, mRect.y-12, mRect.w, 12);
		}
	}
}

/// Helper function to draw a title bar
void DrawTitleBar(SDL_Renderer* renderer, string text, float x, float y, float w, float h){
	SDL_FRect rect = SDL_FRect(x,y,w,h);

	SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
	SDL_SetRenderDrawColor(renderer,0,0,0,192);
	SDL_RenderFillRect(renderer, &rect);
	SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_NONE);

	SDL_SetRenderDrawColor(renderer, 255,255,255,255);
	SDL_RenderDebugText(renderer, x+2, y+2, text.toStringz);
}


/*
   class Image: Widget{
   SDL_Texture* mTexture;

   this(GuiState* guiState, string bitmapFilePath){
// Create a texture
SDL_Surface* mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
mTexture = SDL_CreateTextureFromSurface(guiState.mRenderer,mSurface);
SDL_DestroySurface(mSurface);
}
// Destroy anything 'heap' allocated.
// Remember, SDL is a C library, thus heap allocated resources need
// to be destroyed
~this(){
SDL_DestroyTexture(mTexture);
}

override void Render(GuiState* guiState){
SDL_FRect    mRectangle;
// Position the rectangle 
if(mParent is null){
mRectangle.x = x;
mRectangle.y = y; 
}else{
mRectangle.x = x + mParent.x;
mRectangle.y = y + mParent.y;;
}
mRectangle.w = w;
mRectangle.h = h;
SDL_RenderTexture(guiState.mRenderer, mTexture, null,&mRectangle );
}
}
 */


