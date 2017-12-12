#!/usr/bin/env node

const commandLineArgs = require('command-line-args')
const path = require('path');
const fs = require('fs');
const copydir = require('copy-dir');
const renamer = require('renamer');
const replace = require('replace-in-file');
const commandExists = require('command-exists');

const optionDefinitions = [
  { name: 'project', alias: 'p', type: String }
];
const options = commandLineArgs(optionDefinitions);

// Generate new project
if(options.project) {
	console.log("Creating a new project: " + options.project);
	const templateDir = path.resolve(__dirname, '../templates/HelloWorld');
	const projectDir = path.resolve(process.cwd(), options.project);

	copyTemplate(templateDir, projectDir);
	renameFilesAndFolders(options.project, projectDir);
	replaceFileContent(options.project, projectDir);
	installDependencies(projectDir).then(function() {
		console.log("=================================================");
		console.log("Project " + options.project + " created.");
		console.log("cd into the project (" + projectDir+ ") and run \"npm start\"");
		console.log("=================================================");
	});

} else {
	console.log("Please use 'dss --project ProjectName' to create a new project. Other options are not supported at the moment.");
}

function copyTemplate(templateDir, projectDir) {
	if (fs.existsSync(projectDir)) {
		console.error("Directory " + projectDir + " already exists.");
	    process.exit(1);
	} else {
		copydir.sync(templateDir, projectDir);
		console.log("Template copied to: " + projectDir);
	}
}

function renameFilesAndFolders(project, projectDir) {
  var renamedFiles = renameFilesAndFoldersForProjectName(projectDir, "HelloWorld", project);
  var renamedFilesLowerCase = renameFilesAndFoldersForProjectName(projectDir, "helloworld", project.toLowerCase());
  var totalRenamedFiles = renamedFiles + renamedFilesLowerCase
  console.log("Files and folders renamed:", totalRenamedFiles);
}

function renameFilesAndFoldersForProjectName(projectDir, originalProjectName, newProjectName) {
  var renamerOptions = {
		'files': projectDir + "/**",
		'find': originalProjectName,
		'replace': newProjectName,
		'regex': true
	};

	var fileStats = renamer.expand(renamerOptions.files);
	renamerOptions.files = fileStats.filesAndDirs

	var results = renamer.replace(renamerOptions)
	results = renamer.replaceIndexToken(results)
	if (results.list.length) {
		let renamedCount = 0;
		let renamed = renamer.rename(results).list.forEach(function(ren) {
			if(ren.renamed) {
				renamedCount++;
			}
		});
    return renamedCount;
	}
}

function replaceFileContent(project, projectDir) {
  var changedFiles = replaceFileContentForProjectName(projectDir, /HelloWorld/g, project);
  var changedFilesLowerCase = replaceFileContentForProjectName(projectDir, /helloworld/g, project.toLowerCase());
  var totalChangedFiles = changedFiles + changedFilesLowerCase
  console.log("Modified files:", totalChangedFiles);
}

function replaceFileContentForProjectName(projectDir, originalProjectName, newProjectName) {
	try {
		const options = {
			//Glob(s)
			files: [
				projectDir + "/**",
			],
			//Replacement to make (string or regex)
			from: originalProjectName,
			to: newProjectName,
		};

		let changedFiles = replace.sync(options);
    return changedFiles.length;
	}
	catch (error) {
		console.error("Error occurred:", error);
	}
}

function deleteFolderRecursive(path) {
  if (fs.existsSync(path)) {
    fs.readdirSync(path).forEach(function(file,index){
      var curPath = path + "/" + file;
      if(fs.lstatSync(curPath).isDirectory()) { // recurse
        deleteFolderRecursive(curPath);
      } else { // delete file
        fs.unlinkSync(curPath);
      }
    });
    fs.rmdirSync(path);
  }
};

function installDependencies(projectDir) {
	const commandExistsSync = require('command-exists').sync;
	const spawn = require( 'child_process' ).spawn;
	let npm;
	let promise = new Promise((resolve, reject) => {

		if (fs.existsSync(projectDir + "/yarn.lock")) {
    		fs.unlinkSync(projectDir + "/yarn.lock");
		}

		if (fs.existsSync(projectDir + "/node_modules")) {
			deleteFolderRecursive(projectDir + '/node_modules');
		}

		console.log("Installing NPM....")
		if (commandExistsSync('yarn')) {
		    npm = spawn( 'yarn', [ 'install' ], {cwd: projectDir});
		} else {
			npm = spawn( 'npm', [ 'install' ], {cwd: projectDir});
		}

		npm.stdout.on('data', (data) => {
	  		console.log(data.toString());
		});

		npm.stderr.on('data', (data) => {
		  console.log(`ps stderr: ${data}`);
		});

		npm.on('close', (code) => {
			if (code !== 0) {
				console.log(`npm process exited with code ${code}`);
				reject();
				return;
			} else {
				console.log("Deintegrating Cocoapods....")
				let cocoapodsDeintegrate = spawn( 'pod', [ 'deintegrate' ], {cwd: projectDir + '/ios'} );
				cocoapodsDeintegrate.stdout.on('data', (data) => {
					console.log(data.toString());

					console.log("Installing Cocoapods....")
					let cocoapods = spawn( 'pod', [ 'install' ], {cwd: projectDir + '/ios'} );
					cocoapods.stdout.on('data', (data) => {
						console.log(data.toString());
					});

					cocoapods.stderr.on('data', (data) => {
						console.log(`cocoapods stderr: ${data}`);
					});

					cocoapods.on('close', (code) => {
						if (code !== 0) {
							console.log(`cocoapods process exited with code ${code}`);
							reject();
						} else {
							resolve();
						}
					});
				});

				cocoapodsDeintegrate.stderr.on('data', (data) => {
					console.log(`cocoapods stderr: ${data}`);
				});

				cocoapodsDeintegrate.on('close', (code) => {
					if (code !== 0) {
						console.log(`cocoapods process exited with code ${code}`);
						reject();
					}
				});
			}
		});

	});
	return promise;
}
