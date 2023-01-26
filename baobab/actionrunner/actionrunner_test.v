module actionrunner

import freeflowuniverse.baobab.client

fn test_run() {
	client := client.new() or {panic(err)}
	mut ar := new(client) or {panic(err)}

	ar.run()
}
