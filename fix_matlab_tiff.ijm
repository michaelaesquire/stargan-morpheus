// takes a tiff created by MATLAB and fixes the channnesl from a play button
// to a c and adds the conversion for um


function fixImageChannels(directory) {
	//get all files in given directory
	fileList = getFileList(directory);
	//iterate through all files and perform crop function
	// make a subdirectory
	File.makeDirectory(directory + "fixed_tiffs");
	for (i = 0; i < fileList.length; i++) { 
		fullPath = directory + fileList[i];
		if (File.isDirectory(fullPath)) {
			//selectDir(fullPath);
		}  else if (endsWith(fileList[i],".tif")) { // just making it so that it skips this for now, this was tif
			// if file ends in .tif fix
			input = directory;
			filename = fileList[i];
			openPath = "open=" + input + filename;
			extension = indexOf(filename, ".tif");
			// removed tif extension
			no_tif = substring(filename,0,extension);
			run("Bio-Formats Windowless Importer", openPath);
			run("Stack Splitter", "number=3");
			// close the unsplit image
			selectWindow(filename);
			close();
			//selectWindow("slice0003_1-images.tif");
			//selectWindow("slice0002_1-images.tif");
			run("Merge Channels...", "c1=[t:3/3 - "+filename+"] c2=[t:2/3 - "+filename+"] c4=[t:1/3 - "+filename+"] create");
			// reorder in order: brightfield, FM, syto
			run("Arrange Channels...", "new=321");	
			// change to greyscale setting
			Stack.setDisplayMode("grayscale");
			// add correct scale 
			run("Set Scale...", "distance=9.3023 known=1 unit=um");	
			// save newly stitched image 
			saveAs("Tiff", directory+"fixed_tiffs/"+filename);

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
fixImageChannels(input);
