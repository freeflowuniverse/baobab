module actions

import os

// Factory method to create an ActionMananger
pub fn get() ActionsManager {
	return ActionsManager{}
}

// Parses the text to actions using an ActionsManager
pub fn text_parse(content string) !ActionsManager {
	mut actions := get()
	actions.text_parse(content)!
	return actions
}

// Parses the file to actions using an ActionsManager
pub fn file_parse(path string) !ActionsManager {
	mut actions := get()
	actions.file_parse(path)!
	return actions
}

// Walks over all files of a dir and returns a list
// of actions using a ActionsManager
pub fn dir_parse(path string) !ActionsManager {
	mut actions := get()
	actions.add(path)!
	return actions
}

// Add a path to the ActionsManager to parse later
pub fn (mut actions ActionsManager) add(path string) ! {
	// recursive behavior for when dir
	if os.is_dir(path) {
		mut items := os.ls(path)!
		items.sort() // make sure we sort the items before we go in
		// process dirs first, make sure we go deepest possible
		for path0 in items {
			pathtocheck := '${path}/${path0}'
			if os.is_dir(pathtocheck) {
				actions.add(pathtocheck)!
			}
		}
		// now process files in order
		for path1 in items {
			pathtocheck := '${path}/${path1}'
			if os.is_file(pathtocheck) {
				actions.add(pathtocheck)!
			}
		}
	}

	// make sure we only process markdown files
	if os.is_file(path) {
		if path.to_lower().ends_with('.md') {
			actions.file_parse(path)!
		}
	}
}
