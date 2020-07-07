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
		} else if (endsWith(fileList[i],".png")) { 
			// if file ends in .dv, split save
			input = directory;
			filename = fileList[i];
			openPath = "open=" + input + filename;
			run("Bio-Formats Windowless Importer", openPath);
			run("Split Channels");
		//	run("Merge Channels...", "c1=["+filename+" (green)] c2=["+filename+" (blue)] c4=["+filename+" (red)] create");
			run("Merge Channels...", "c1=[C3-"+filename+"] c2=[C2-"+filename+"] c4=[C1-"+filename+"] create");
			// reorder in order: brightfield, FM, syto
			run("Arrange Channels...", "new=321");	
			// change to greyscale setting
			Stack.setDisplayMode("grayscale");
			// add correct scale 
			run("Set Scale...", "distance=9.3023 known=1 unit=um");	
			// save newly stitched image 
			saveAs("Tiff", directory+"fixed_tiffs/cfixed_"+filename);

			close();
		} else if (endsWith(fileList[i],".aaaaa")) { // just making it so that it skips this for now, this was tif
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
			//run("Merge Channels...", "c1=slice0002_"+filename+" c2=slice0003_"+filename+" c4=slice0001_"+filename+" create");
			run("Merge Channels...", "c1=[t:3/3 - "+filename+"] c2=[t:2/3 - "+filename+"] c4=[t:1/3 - "+filename+"] create");
			// reorder in order: brightfield, FM, syto
			run("Arrange Channels...", "new=321");	
			// change to greyscale setting
			Stack.setDisplayMode("grayscale");
			// add correct scale 
			run("Set Scale...", "distance=9.3023 known=1 unit=um");	
			// save newly stitched image 
			saveAs("Tiff", directory+"fixed_tiffs/cfixed_"+filename);

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
