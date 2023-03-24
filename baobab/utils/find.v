module utils

pub struct FindConfig {
	fields []string // priority of fields
	keyword string
	amount int = 1
	relevance int = 5
}

pub fn find[T](targets []T, search T, args FindConfig) ?[]int {
	mut results := []int{}
	mut i := 0
	for {
		if i == args.relevance {
			if results.len == 0 {
				return none
			}
			return results
		}
		config := MatchConfig {
			fields: args.fields
			keyword: args.keyword
			relevance: i
		}
		for j, target in targets {
			if matches[T](target, search, config) {
				results << j
			}
		}
		if results.len == args.amount {
			return results
		}
		i += 1
	}
	return none
}


pub struct MatchConfig{
	fields []string
	keyword string
	relevance int
}

pub fn matches[T](target T, search T, args MatchConfig) bool {
	// println(args)
	$for field in T.fields {
		priority := args.fields.index(field.name)
		println('\nhere: $args.keyword, $args.relevance, $priority, $field.name')
		// println('pri: $priority\n $field')
		$if field.typ is string {
			if args.relevance == priority+1 {
				if search.$(field.name) != '' {
					if target.$(field.name) == search.$(field.name) {
						return true
					}
				}
			} if args.relevance == (2*(priority+1)) {
				name := args.keyword
				name2 := target.$(field.name)
				// name2
				println('whyyo: $field.name\nsearch:${name}\ntarget:$name2')
				if args.keyword != '' {
				if target.$(field.name) == args.keyword {
					return true
				}}
			}
			if args.relevance == (3*(priority+1)) {
				name := search.$(field.name)
				name2 := target.$(field.name)
				// name2
				println('woah: $field.name\nsearch:${name}\ntarget:$name2')
				if search.$(field.name) != '' {
				if target.$(field.name).contains((search.$(field.name))) {
					return true
				}}
			} 
			if args.relevance == (4*priority) {
				if args.keyword != '' {
				if target.$(field.name).contains(args.keyword) {
					return true
				}}
			}
		}
	}
	return false
}