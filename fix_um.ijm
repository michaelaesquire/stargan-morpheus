// macro to take corrected images and restitch 
// READ INSTRUCTIONS FIRST

// select master directory containing original image files and new image directories
// this will go in each image directory, find corrected tiles, restitch
// and place corrected images in same folder as original images 
// folders f1, f2 and f3 will have been created by BaSiC_macro2.ijm

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

			run("Set Scale...", "distance=9.3023 known=1 unit=um");	
			// save newly stitched image 
			saveAs("Tiff", directory+"fixed_tiffs/um_"+filename);

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
