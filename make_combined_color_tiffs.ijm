// macro to take corrected images and restitch 
// READ INSTRUCTIONS FIRST

// select master directory containing original image files and new image directories
// this will go in each image directory, find corrected tiles, restitch
// and place corrected images in same folder as original images 
// folders f1, f2 and f3 will have been created by BaSiC_macro2.ijm

function combineColors(directory) {
	//get all files in given directory
	fileList = getFileList(directory);
	//iterate through all files and perform crop function
	// make a subdirectory
	File.makeDirectory(directory + "tricolor");
	for (i = 0; i < fileList.length; i++) { 
		fullPath = directory + fileList[i];
		if (File.isDirectory(fullPath)) {
			//selectDir(fullPath);
		} else if (endsWith(fileList[i],".tif")) { 
			// if file ends in .dv, split save
			input = directory;
			filename = fileList[i];
			openPath = "open=" + input + filename;
			run("Bio-Formats Windowless Importer", openPath);
			run("Stack Splitter", "number=3");
			selectWindow(filename);
			close();å
			run("Merge Channels...", "c1=[c:2/3 - "+filename+"] c2=[c:3/3 - "+filename+"] c4=[c:1/3 - "+filename+"] create");
			// reorder in order: brightfield, FM, syto
			run("Arrange Channels...", "new=312");	
			// change to greyscale setting
			//Stack.setDisplayMode("grayscale");
			// add correct scale 
			run("Next Slice [>]");
			run("Next Slice [>]");
			run("Enhance Contrast", "saturated=0.35");
			run("Previous Slice [<]");
			run("Enhance Contrast", "saturated=0.35");
			run("Previous Slice [<]");
			run("Enhance Contrast", "saturated=0.35");
			//run("Set Scale...", "distance=9.3023 known=1 unit=um");	
			// save newly stitched image 
			saveAs("PNG", directory+"tricolor/tricolor_"+filename);

			close();
		} 
	}
}





//user inputs master directory to crop
Dialog.create("Select master directory");
Dialog.addMessage("Choose master directory ");
Dialog.show();
input = getDirectory("Choose master directory");

//call selectDir to go through and correctly split images
combineColors(input);
