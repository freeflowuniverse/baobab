module modelbase


//walk over all targets, return the one which has cid or name match
//if more than 1 found, then is error
//QUESTION:return index or reference?
fn cid_name_find[T](targets []T, cid_name string) !int {
	mut result := -1
	for i, target in targets {
		if !cid_name_matches[T](target, cid_name) {
			continue
		}
		if result != -1 {
			return error('Duplicate root objects found.')
		}
		result = i
	}
	return result
}

fn cid_name_matches[T](target T, cid_name string) bool {
	$for field in T.fields {
		if field.name == 'cid' || field.name == 'name' {
			if target.$(field.name) == cid_name {
				return true
			}
		}
	}
	return false
}