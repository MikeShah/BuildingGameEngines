/// Builds the documentation for all of the sample code
/// rdmd -wi -g build_docs.d
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


/// Functions main job is to invoke a D compiler to run ddoc
void GenerateHTML(in DirEntry[] dfiles){

    // Find every D file and attempt to build the ddocs
    foreach(dfile ; dfiles){
        // ignore this file
        if(dfile == "build_docs.d"){
            continue;
        }

        // If it's a regular .d file, then just build it.
        writeln("Searching for D File: ",dfile);
        string directory = dfile[0 .. dfile.lastIndexOf("/")];
        writeln("\tIn directory:",directory);

        // Search for html source files
        if(dfile.indexOf("source") < 0){
            // NOTE: I pass in "-c" to avoid building all the executables,
            //       but there must be a way to avoid compiling
            auto pid = execute(["dmd","-Dddocumentation/"~directory,"-unittest","-main","-c",dfile]);
        }
        else if(dfile.indexOf("dub.json") >=0){
            writeln("Found a dub-based project: ",directory);
            auto pid = execute(["dub","--build=docs","-Dddocumentation/"~directory,dfile]);
            // Builds directory using dub if a dub.json file is detected
            // TODO: Can probably just copy the 'docs' directory to the documentation folder at this point.
        //    auto pid = execute(["dub","build/","docs");
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
        // Create table of all other .d files that are found within
        // same directory as the current file.
        string table = MakeRelatedHTMLTable(v).idup;

        // For each of the files found in the current directory
        // we will then add the table found by modifying the file
        // and appending in our table of links
        foreach( value ; v){
            // Open the file
            string filename = k~"/"~value;
            auto f = File(filename,"rw");
            
            // Store the contents of the file 
            string[] lines;
            int counter=0;
            foreach(line; f.byLine){
                lines ~= line.idup~'\n'; // Note: If we do not .dup these lines, then
                                   //       we will lose the reference to the memory
                                   //       when otherwise iterating through 'lines'.
            }
            // Close the file
            f.close();

            // the lines
            for(size_t i=0; i < lines.length; i++){
                // Append some additional headers
                if(lines[i].indexOf("<head>") > -1){
                    lines[i] = "<head><link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">".dup;
                }
                // First time we find the content wrapper, we want to add in our 'header index'
                if(lines[i].indexOf("<div class=\"content_wrapper\">") > -1){
                    lines[i]="<div class=\"w3-threequarter w3-container\"><div class=\"content_wrapper\">".dup; // Note: Need to terminate this
                    lines[i]~= table.dup;                                            //       div before end of body.
                }
                if(lines[i].indexOf("</body>") > -1){
                    lines[i] = "</div> <!--  ending w3-threequarter--></body>".dup;
                }


                if(lines[i].indexOf("<body id=\"ddoc_main\" class=\"ddoc dlang\">") > -1){
                    lines[i]= "<body id=\"ddoc_main\" class=\"ddoc dlang\">" ~tableOfContents.idup;
                }
                if(lines[i].indexOf("<h1 class=\"module_name\">") > -1){
                    string dFileName = filename.replace("html","d");
                    string sourceCode = lines[i];
                    sourceCode ~= "<a href=../../"~dFileName~">"~dFileName~"</a>".idup;
                    sourceCode ~= "<section class=\"section\">".dup;
                    sourceCode ~= "<div class=\"dlang\">".dup;
                    sourceCode ~= "<code class=\"code\">".dup;

                    auto sourceFile = File(dFileName[dFileName.indexOf("/")+1..$],"r");
                    foreach( s ; sourceFile.byLine){
                        sourceCode ~= s.idup ~"<br>".idup;
                    }
                    sourceCode ~= "</code>".dup;
                    sourceCode ~= "</div>".dup;
                    sourceCode ~= "</section>".dup;

                    lines[i] = sourceCode;
                }
            }

            auto f2 = File(filename,"w");
            foreach(line; lines){
                f2.write(line);
            }   
            f2.close();

            writeln("\t",value);
        }
    }
    // Read the file
}


/// Make the table of contents to help navigate all of the directories quickly
/// This appears on the 'top-left' of the screen
string MakeTableOfContents(string documentationDirectory){

    string result="<div class=\"w3-quarter w3-container\">".dup;
    result ~= "<div class=\"w3-bar-block w3-light-grey\">".dup;
    auto dFiles = dirEntries(documentationDirectory, SpanMode.shallow).array.sort;

    foreach(f; dFiles){
        if(f.isDir){
            // Just grab the first file found and link to that one for now
            auto firstLink = dirEntries(f,SpanMode.shallow).filter!(f=> f.name.endsWith(".html")).array.sort;
            if(firstLink.length >0){
                result ~= "<a href=\"./../../"~firstLink[0]~"\" class=\"w3-bar-item w3-button\">"~f~"</a>".dup;
            }
        }
    }

    result ~= "</div><!-- Ending w3-bar-block -->".dup;
    result ~= "</div><!-- w3-quarter ending -->".dup;

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

//   foreach(idx,f; dfiles){
//        writeln(idx,":",f);
//   }

   // (2) Generate the html files
   GenerateHTML(dfiles);

   // (3) Gather the HTML Links
   GatherHTMLLinks(DocsDirectory);
}
