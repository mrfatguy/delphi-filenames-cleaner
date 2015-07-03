# Files and Folders Names Cleaner

Simple tool (with sources), written in Delphi, to "clean" (purge out of unwanted characters, correct, change) names of all your files and folders.

**This project ABANDONED! There is no wiki, issues and no support. There will be no future updates. Unfortunately, you're on your own.**

You can use this project as either a tool, to batch-change names of your files and folders in much more flexible way than most tools (like batch rename tool in Total Commander) allows you to do. Or you can use its source code to implement multi-folder recursive searching and renaming algorithm in your own application. Keep in mind, that both comments and names (variables, object) are in Polish. I didn't find enough time and determination to translated them as well. I only translated strings. Also keep in mind, that though GUI of this program is translated to English, it still was written for Polish language. Therefore, certain functions (i.e. remove Polish national characters from names) will remain pretty useless for non-Polish users (however, these routines may be easily changed to remove national characters from any other language).

**You're only getting project's source code and nothing else! You need to find all missing Delphi components by yourself.**

### Status

Last time `.dpr` file saved in Delphi: **2 April 2006**. Last time `.exe` file built: **6 January 2013**.

I don't have access to either most of my components used in this or any other of my Delphi projects, nor to Delphi itself. Even translation of this project to English was done by text-editing all `.dfm` and `.pas` files and therefore it may be cracked. It was made in hope to be useful to anyone and for the same reason I'm releasing its source code, but you're using this project or source code at your own responsibility.

Note, that due to my laziness, this project uses core `TTreeView`, knows as buggy and awfully slow. I'm aware of advantages of using super fast solutions like `VirtualTreeView` component, but I was to lazy in implementing it in this project.

**This project ABANDONED! There is no wiki, issues and no support. There will be no future updates. Unfortunately, you're on your own.**