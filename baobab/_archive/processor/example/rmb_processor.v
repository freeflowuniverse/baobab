module main

import freeflowuniverse.crystallib.rmbprocessor
import freeflowuniverse.crystallib.params

fn do() ! {
	mut text := "
		id:a1 name6:aaaaa
		name:'need to do something 1' 
		name2:   test
		name3: hi name10:'this is with space'  name11:aaa11
	"
	param := params.parse(text) or { panic(err) }

	mut rmbp := rmbprocessor.new()!
	mut client := &rmbp.rmbc
	client.reset()!

	// schedule a job
	mut ajob := client.action_new_schedule(u32(0), 'mydomain.myactor.myaction', param,
		'sourcedomain.sourceactor.soureaction')!

	rmbprocessor.process()!
}

fn main() {
	do() or { panic(err) }
}
