module utils

// priority: priority of priority  e.g. I want to find an id before a name, if left empty the priority doesn't matter
// fulltext: if bool will do full text search over all fields
// amount: amount of results to return from the list we ware walking over when it matches
pub struct FindConfig {
	priority []string 
	amount int = 1
	fulltext bool 
}


// NEXT: make sure description is in line with implementation, move to crystal

// targets: list of objects to search through
// search: 
// args: FindConfig (what to look for)
//
// it returns list of indexes of the targets e.g. [2,4] ->  nr 2 and 4 means the 3e object index and 5e object index out of targets[]
//
// while the finder is walking over the objects it will do different types of matches
// 
// one is based on direct match, means priority are the same between target and search object
// one is based on text search match, means the word looking for is part of the field (string only)
// for a direct match the relevance is 5, for text search match its 1
// 
// relevance
// 		is by default 5 means direct match
//		if is 1, there is a keyword match
// 
pub fn find[T](targets []T, search T, args FindConfig) ?[]int {
	// mut results := []int{}
	// mut i := 0
	// for {
	// 	if i == args.relevance {
	// 		if results.len == 0 {
	// 			return none
	// 		}
	// 		return results
	// 	}
	// 	config := MatchConfig {
	// 		priority: args.priority
	// 		keyword: args.keyword
	// 		relevance: i
	// 	}
	// 	for j, target in targets {
	// 		if matches[T](target, search, config) {
	// 			results << j
	// 		}
	// 	}
	// 	if results.len == args.amount {
	// 		return results
	// 	}
	// 	i += 1
	// }
	return none
}


pub struct MatchConfig{
	priority []string
	keyword string
	relevance int
}

// FIXME: maybe later
pub fn matches[T](target T, search T, args MatchConfig) bool {
	// println(args)
	// $for field in T.priority {
	// 	priority := args.priority.index(field.name)
	// 	// println('pri: $priority\n $field')
	// 	$if field.typ is string {
	// 		if args.relevance == priority+1 {
	// 			if search.$(field.name) != '' {
	// 				if target.$(field.name) == search.$(field.name) {
	// 					return true
	// 				}
	// 			}
	// 		} if args.relevance == (2*(priority+1)) {
	// 			name := args.keyword
	// 			name2 := target.$(field.name)
	// 			// name2
	// 			if args.keyword != '' {
	// 			if target.$(field.name) == args.keyword {
	// 				return true
	// 			}}
	// 		}
	// 		if args.relevance == (3*(priority+1)) {
	// 			name := search.$(field.name)
	// 			name2 := target.$(field.name)
	// 			// name2
	// 			if search.$(field.name) != '' {
	// 			if target.$(field.name).contains((search.$(field.name))) {
	// 				return true
	// 			}}
	// 		} 
	// 		if args.relevance == (4*(priority+1)) {
	// 			if args.keyword != '' {
	// 			if target.$(field.name).contains(args.keyword) {
	// 				return true
	// 			}}
	// 		}
	// 	}
	// }
	return false
}