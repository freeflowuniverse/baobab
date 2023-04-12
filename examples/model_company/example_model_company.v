module main

import freeflowuniverse.baobab.modelactors.company
import freeflowuniverse.crystallib.actionsparser

fn main() {
	do() or { 
		eprintln(err)
		exit(1)
	}
}

fn do() ! {
	actions_path := os.dir(@FILE) + '/actions'
	mut ap:= actionsparser.new(path:actions_path)!
	println(ap)

}

