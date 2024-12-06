/// Builds the documentation for all of the sample code
import std.stdio;
import std.algorithm;
import std.string;
import std.process;

auto GetDirectory(){
    import std.file;

    auto dFiles = dirEntries("", SpanMode.depth).filter!(f=> f.name.endsWith(".d"));

    return dFiles;
}



void main(){
    immutable DocsDirectory = "documentation";


   auto dfiles = GetDirectory();

    foreach(dfile ; dfiles){
        // ignore this file
        if(dfile == "build_docs.d"){
            continue;
        }

        // If it's a regular D file, then just build it.
        writeln("Checking: ",dfile);
        string directory = dfile[0 .. dfile.lastIndexOf("/")];
        writeln("\tIn directory:",directory);

        // Search for html source files
        if(dfile.indexOf("source") < 0){
            auto pid = execute(["dmd","-Dddocumentation/"~directory,"-unittest","-main",dfile]);
        }else if(dfile.indexOf("source") >=0){
            // Must be a 'dub' project if filepath contains 'source'
            // NOTE: I can do something smarter in the future here 
        }
    }

}
