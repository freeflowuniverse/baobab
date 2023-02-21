module gitactor

import freeflowuniverse.baobab.jobs { ActionJob }
import freeflowuniverse.crystallib.gittools { GitStructure }
import freeflowuniverse.crystallib.sshagent

pub struct GitActor {
	name string = 'crystallib.git'
	mut:
	gt GitStructure = gittools.get(gittools.GSConfig{}) or {panic(err)}
}

pub fn (mut actor GitActor) execute (mut job ActionJob) ! {
	$if debug {
		eprintln('active git..')
		println(job)
	}
	// used to initialize gitstructure by default
	// if git init action isn't the first job

	actionname := job.action.split('.').last()
	match actionname {
		'init' {
			actor.run_init(mut job)!
		}
		'params_multibranch' {
			actor.run_multibranch(mut job)!
		}
		'get' {
			actor.run_get(mut job)!
		}
		'link' {
			actor.run_link(mut job)!
		}
		'commit' {
			actor.run_commit(mut job)!
		}
		else {
			error('could not find git action for job:\n${job}')
			return
		}
	}
}

fn (mut actor GitActor) run_init(mut job ActionJob) ! {
	path := job.args.get('path') or { '' }
	multibranch := job.args.get('multibranch') or { '' }

	actor.gt = gittools.get(root: path, multibranch: multibranch == 'true') or {
		return error("Can't get gittools: ${err}")
	}
}

fn (mut actor GitActor) run_get(mut job ActionJob) ! {
	// TODO: if local repo is at local branch that has no upstream produces following error
	// ! 'Your configuration specifies to merge with the ref 'refs/heads/branch'from the remote, but no such ref was fetched.
	if !sshagent.loaded() {
		return error('ssh key must be loaded')
	}
	url := job.args.get('url') or { return error("Couldn't get url.\n${err}") }

	name := job.args.get_default('name', '') or {
		return error("Couldn't get params name.\n${err}")
	}
	$if debug {
		eprintln(@FN + ': git pull: ${url}')
	}
	mut repo := actor.gt.repo_get_from_url(url: url, name: name) or {
		return error('Could not get repo from url ${url}\n${err}')
	}
	repo.pull() or { return error('Could not pull repo ${url}\n${err}') }
}

fn (mut actor GitActor) run_link(mut job ActionJob) ! {
	gitlinkargs := gittools.GitLinkArgs{
		gitsource: job.args.get_default('gitsource', '') or { return error("Can't get param") }
		gitdest: job.args.get_default('gitdest', '') or { return error("Can't get param") }
		source: job.args.get('source') or { '' }
		dest: job.args.get('dest') or { '' }
		pull: job.args.get_default_false('pull')
		reset: job.args.get_default_false('reset')
	}

	actor.gt.link(gitlinkargs) or { return error('Could not link \n${gitlinkargs}\n${err}') }
}

fn (mut actor GitActor) run_commit(mut job ActionJob) ! {
	url := job.args.get('url') or { '' }
	name := job.args.get_default('name', '') or { '' }
	msg := job.args.get('message') or { return error('message cannot be empty') }
	push := job.args.get_default('push', '') or { '' }

	// get repository from url or name
	mut repo := gittools.GitRepo{}
	if url != '' {
		repo = actor.gt.repo_get_from_url(url: url, name: name) or {
			return error('Could not get repo from url ${url}\n${err}')
		}
	} else if name != '' {
		repo = actor.gt.repo_get(name: name) or {
			return error('Could not get repo from name ${name}\n${err}')
		}
	} else {
		return error("Can't get repo without name or url")
	}

	repo.commit(msg) or { return error('Could not commit repo ${repo}\n${err}') }
	if push == 'true' {
		repo.push() or { return error('Could not push repo ${repo}\n${err}') }
	}
}

fn (mut actor GitActor) run_multibranch(mut job ActionJob) ! {
	actor.gt.config.multibranch = true
	// log('${job.guid}:multibranch set')
}
