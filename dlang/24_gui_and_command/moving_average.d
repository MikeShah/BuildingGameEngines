// @file: moving_average.d

/// T is the type (e.g. float, double, int, etc.)
struct MovingAverage(T, size_t size)
{
	T[size] mSamples;
	size_t  mCurrentSample; // Current sample
	size_t  mSampleCount;		// Total of all samples collected

	void AddSample(T value){
		mSamples[mCurrentSample%size] = value;
		mCurrentSample++;
		mSampleCount++;
	}	

	T GetMovingAverage(){
		T sum=0;
		// Handle case where we have fewer samples then
		// our size currently in the array
		if(mSampleCount < size){
				for(int i=0; i < mSampleCount; i++){
					sum += mSamples[i];
				}
		}
		else{
				// Handle the common case
				for(int i=0; i < size; i++){
					sum += mSamples[i];	
				}
		}
		return (cast(T)(sum) / cast(T)(size));	
	}
}

void main(){
	import std.stdio;

	auto avg = MovingAverage!(float,20)();

	for(int i=0; i < 100; i++){
		avg.AddSample(i);
		writeln(avg.GetMovingAverage);
	}
}
