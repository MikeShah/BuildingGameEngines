// @file: string_split_strategies.d
//
// When reading data, one task that you may often need to do is break
// the string based on some 'token'. For example, 'comma seperated values'
// (.csv) files separate elements by commas. There are also tab separated
// files (.tsv), or simply data split by spaces. For this, we will want
// to 'split' the provided data based on this character.
//
// For this example, we will assume we have data as a string of characters
// and we will explore the '.split' and '.splitter' functions.


void main(){
    import std.stdio, std.string;

    string data = "Some really long piece of data that will be" ~
                  " interesting for us to separate based on the" ~
                  " space character. Let's see how many interesting" ~
                  " words we can add here to make this example" ~
                  " more interesting, and also observe the performance" ~
                  " of these functions";


    // The 'split' function will 'eagerly' evaluate your string, and generate
    // a new 'array' of strings basedd on the delimeter (token you want to split) provided.
    string[] tokens = data.split(' ');
    writeln(tokens);

    // There also exists the 'splitter' function.
    // https://dlang.org/library/std/algorithm/iteration/splitter.html
    // 'splitter' will lazily split a range (which an array is).
    // This means we don't have to 'allocate' as we are performing the split.
    // In the above example, data.split will eagerly generate the 'tokens'
    // array, and may occassionally 'expand' the tokens array as each new
    // element is found. With 'splitter', we don't pay that cost.
    //
    // The following line below however does not work. Because again
    // this is a 'range' object. Ranges are 'lazy' meaning we evaluate
    // our data several characters at a time, and only 'produce' and output
    // as needed.
    import std.algorithm;
    // string[] token_splitter = data.splitter(' '); // The return type her eis 'Result'.
                                                     // This may be a little strange at first,
                                                     // but this is so we can compose range
                                                     // operations.
                                                     // So again, the type is NOT string[], but 'Result'.
    // Here is the appropriate use of 'splittler' 
    auto token_splitter = data.splitter(' ');
    writeln(token_splitter);
    // This again below does not work. Because remember, we have a 'range'
    // writeln(token_splitter[0]);
    // We can however use 'range' functions on our range as follows.
    writeln(token_splitter.front());

    // Probably what you really wanted, was something like this.
    import std.array;
    string[] token_splitter_array = data.splitter(' ').array;
    // However, this is a bit of an 'anti-pattern' in the sense that we should have just used
    // 'split' if we want to save the result.
    // That doesn't mean never have 'data.splitter.array', because we might want to utilize a
    // range to compose some operations and then save them.
    // For example:
    import std.functional;
    string[] tokens_lazily_filtered = data.splitter(' ').filter!(a => a.startsWith('w')).array.sort.array;
    writeln("Filtered result",tokens_lazily_filtered);
    // The above example of several chained functions produces an array of sorted words that begin with 'w'.
    // Some odditiy that 'array' is produced twice is needed to produce the array, but otherwise this shows
    // an example of where we want to 'keep' the result from using splitter.
    //
    // Note: It may be worth benchmarking some larger examples to otherwise see the performance in the above
    //       example compared to say what we have below with 'split'. We still need to produce the array
    //       'twice' (i.e. the 'array.sort.array') because of the filter call.
    // string[] tokens_eager_filter = data.split(' ').filter!(a => a.startsWith('w')).array.sort.array;
    //       But what is probably interesting is to compare it with the bottom. In this case, note we do
    //       a sort 'prior' to our filter. It's possible this could be quite more expensive, due to us
    //       potentially running a more expenssive 'sort' algorithm on a larger data set. Thus, in some
    //       cases it's worthwhile to again run a few experiments of 'lazy' and 'eager' evaluation.
    // string[] tokens_eager2_filter = data.split(' ').sort.filter!(a => a.startsWith('w')).array;

}
