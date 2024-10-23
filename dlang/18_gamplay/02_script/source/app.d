// 02_script_
// 
// Make sure to edit your
// subConfiguration for your pyd
// e.g. python3.10 = python310
//      python3.6  = python36
// See: https://dub.pm/dub-reference/build_settings/#subconfigurations
import std.stdio;

// Pybind code
import pyd.pyd;
import pyd.embedded;

shared static this(){
	// Initializes the python interpreter.
	// Needed before we make any python calls.
	py_init();
}

// Raw string -- spacing matters
immutable script = `
import matplotlib.pyplot as plt

fig, ax = plt.subplots()

fruits = ['apple', 'blueberry', 'cherry', 'orange']
counts = [40, 100, 30, 55]
bar_labels = ['red', 'blue', '_red', 'orange']
bar_colors = ['tab:red', 'tab:blue', 'tab:red', 'tab:orange']

ax.bar(fruits, counts, label=bar_labels, color=bar_colors)

ax.set_ylabel('fruit supply')
ax.set_title('Fruit supply by kind and color')
ax.legend(title='Fruit color')

plt.show()
`;

void main()
{
	// ---------- Run a python script -------- //
	auto context = new InterpContext();
	context.py_stmts(script);
}
