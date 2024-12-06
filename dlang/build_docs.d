/// Builds the documentation for all of the sample code
import std.stdio;
import std.file;
import std.algorithm;
import std.string;
import std.process;
import std.array;

/// Retrieve all of the directories where there exist .d files
auto GetDirectories(){
    auto dFiles = dirEntries("", SpanMode.depth).filter!(f=> f.name.endsWith(".d")).array;

    return dFiles;
}


void GenerateHTML(in DirEntry[] dfiles){

    foreach(dfile ; dfiles){
        // ignore this file
        if(dfile == "build_docs.d"){
            continue;
        }

        // If it's a regular .d file, then just build it.
        writeln("Checking: ",dfile);
        string directory = dfile[0 .. dfile.lastIndexOf("/")];
        writeln("\tIn directory:",directory);

        // Search for html source files
        if(dfile.indexOf("source") < 0){
            // NOTE: I pass in "-c" to avoid building all the executables,
            //       but there must be a way to avoid compiling
            auto pid = execute(["dmd","-Dddocumentation/"~directory,"-unittest","-main","-c",dfile]);
        }else if(dfile.indexOf("source") >=0){
            // Must be a 'dub' project if filepath contains 'source'
            // NOTE: I can do something smarter in the future here, maybe looking for dub.json file?
        }
    }
}


// Gather a list of .html files within a documentation directory
void GatherHTMLLinks(string documentationDirectory){
    auto dFiles = dirEntries(documentationDirectory, SpanMode.depth).filter!(f=> f.name.endsWith(".html")).array.sort;

    // Stores all of the directories that contain at least one .html documentation file
    // key is the directory
    // value is an array of strings representing the .html files
    string[][string] directories;
    foreach(f;dFiles){
        // Set to an empty string array for now
        directories[f[0 .. f.lastIndexOf("/")]] ~= f[f.lastIndexOf("/")+1 .. $];
    }

    /// Every page gets the table of contents
    string tableOfContents = MakeTableOfContents(documentationDirectory);

    // For each of the keys, we want to build a sort of
    // 'table of contents' of the links found
    foreach(k,v; directories){
        writeln("Root directory:", k);
        // Create the table
        string table = MakeRelatedHTMLTable(v).idup;

        // For each of the files found in the current directory
        // we will then add the table found by modifying the file
        // and appending in our table of links
        foreach( value ; v){
            // Open the file
            auto f = File(k~"/"~value,"rw");
            
            // Store the contents of the file 
            char[][] lines;
            foreach(line; f.byLine){
                lines ~= line.dup; // Note: If we do not .dup these lines, then
                                   //       we will lose the reference to the memory
                                   //       when otherwise iterating through 'lines'.
                if(line.indexOf("<div class=\"content_wrapper\"") > -1){
                    lines~= table.dup;
                }
                if(line.indexOf("<body id=\"ddoc_main\"") > -1){
                    lines~= tableOfContents.dup;
                }
            }
            // Close the file
            f.close();

            auto f = File(k~"/"~value,"w");
            foreach(line; lines){
                f.write(line);
            }   
            f.close();


            writeln("\t",value);
        }
    }
    // Read the file
}


/// Make the table of contents to help navigate all of the directories quickly
string MakeTableOfContents(string documentationDirectory){
    string result="<div style=\"float: left\">";
    auto dFiles = dirEntries(documentationDirectory, SpanMode.shallow).array.sort;

    foreach(f; dFiles){
        if(f.isDir){
            // Just grab the first file found and link to that one for now
            auto firstLink = dirEntries(f,SpanMode.shallow).filter!(f=> f.name.endsWith(".html")).array.sort;
            result ~= "<li><a href=\"./../../"~firstLink[0]~"\">"~f~"</a></li>";
        }
    }

    result ~= "</div>";

     return result;
}


/// Given a list of strings creates an html table as a single string.
/// These are the code samples from within the same module
string MakeRelatedHTMLTable(string[] links){
    string result;

    result ~= "<div><ul>";
    foreach(link; links){
        result ~= "<li><a href=\""~link~"\">"~link[0 .. link.indexOf(".")]~"</a></li>";
    }
    result ~= "</ul></div>";

    return result;
}

/// Entry point to program
void main(){
    // (0) Select output directory
    // NOTE: This could potentially be a command-line argument?
    immutable DocsDirectory = "documentation";

    // (1) collect all of the D files
   auto dfiles = GetDirectories();

   foreach(idx,f; dfiles){
        writeln(idx,":",f);
   }

   // (2) Generate the html files
   GenerateHTML(dfiles);

   // (3) Gather the HTML Links
   GatherHTMLLinks(DocsDirectory);


}
