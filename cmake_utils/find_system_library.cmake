# find lib${name} + version + .so
function(find_system_library_inner name)
	message(STATUS "Finding system library ${name}...")

	set(
			SEARCH_PATH
			# TODO
			"/usr/lib/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu"
	)

	foreach (path IN LISTS SEARCH_PATH)
		message(STATUS "Searching ${name} in ${path}...")

		# get all so
		file(
				GLOB_RECURSE
				shared_objects
				RELATIVE ${path}

				# lib${name} + version + .so
				${path}/lib${name}*.so
		)

		list(LENGTH shared_objects so_file_size)
		if (${so_file_size} EQUAL 0)
			continue()
		endif (${so_file_size} EQUAL 0)

		# cmake --> Changed in version 3.6: The results will be ordered lexicographically.
		list(POP_BACK shared_objects so_name)

		# check
		string(REGEX MATCH "^lib${name}[0-9.]*[.]so$" so_name_valid ${so_name})
		if (NOT so_name_valid)
			continue()
		endif (NOT so_name_valid)

		# get real name (name + version)
		string(REGEX REPLACE "^lib${name}([0-9.]*)[.]so$" "${name}\\1" name_with_version "${so_name}")
		set(so_version ${CMAKE_MATCH_1})

		# set variables
		string(TOUPPER ${name} upper_name)

		set(LIB_${upper_name}_FOUND ON PARENT_SCOPE)

		set(LIB_${upper_name}_LIBRARIES ${name} PARENT_SCOPE)
		set(LIB_${upper_name}_VERSION ${so_version} PARENT_SCOPE)
		set(LIB_${upper_name}_LIBRARY_DIRS ${path} PARENT_SCOPE)
		# TODO
		set(LIB_${upper_name}_INCLUDE_DIRS "/usr/include;/usr/include/${name};/usr/include/${name_with_version}" PARENT_SCOPE)
		set(LIB_${upper_name}_CFLAGS "" PARENT_SCOPE)
		set(LIB_${upper_name}_LDFLAGS "-l${name}" PARENT_SCOPE)

		# add library
		add_library(
				${name}
				SHARED
				IMPORTED
		)
		set_target_properties(
				${name}
				PROPERTIES
				IMPORTED_LOCATION ${path}/${so_name}
				IMPORTED_IMPLIB ${path}/lib${name}.a
		)
	endforeach (path IN LISTS SEARCH_PATH)
endfunction(find_system_library_inner name)

# find lib${name} + .so + .version
function(find_system_library_post name)
	message(STATUS "Finding system library ${name}...")

	set(
			SEARCH_PATH
			# TODO
			"/usr/lib/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu"
	)

	foreach (path IN LISTS SEARCH_PATH)
		message(STATUS "Searching ${name} in ${path}...")

		# get all so
		file(
				GLOB_RECURSE
				shared_objects
				RELATIVE ${path}

				# lib${name} + .so + .version
				${path}/lib${name}.so*
		)

		list(LENGTH shared_objects so_file_size)
		if (${so_file_size} EQUAL 0)
			continue()
		endif (${so_file_size} EQUAL 0)

		# We always assume that `lib${name}.so` exists.
		list(FIND shared_objects lib${name}.so index)
		if (${index} EQUAL -1)
			message(STATUS "[lib${name}.so] not exists in folder ${path}, ignore it...")
			continue()
		endif (${index} EQUAL -1)

		# cmake --> Changed in version 3.6: The results will be ordered lexicographically.
		list(POP_BACK shared_objects longest_so_name)

		# check
		string(REGEX MATCH "^lib${name}[.]so[.]([0-9.]*)$" so_name_valid ${longest_so_name})
		if (NOT so_name_valid)
			continue()
		endif (NOT so_name_valid)
		set(so_version ${CMAKE_MATCH_1})

		# set variables
		string(TOUPPER ${name} upper_name)

		set(LIB_${upper_name}_FOUND ON PARENT_SCOPE)

		set(LIB_${upper_name}_LIBRARIES ${name} PARENT_SCOPE)
		set(LIB_${upper_name}_VERSION ${so_version} PARENT_SCOPE)
		set(LIB_${upper_name}_LIBRARY_DIRS ${path} PARENT_SCOPE)
		# TODO
		set(LIB_${upper_name}_INCLUDE_DIRS "/usr/include;/usr/include/${name}" PARENT_SCOPE)
		set(LIB_${upper_name}_CFLAGS "" PARENT_SCOPE)
		set(LIB_${upper_name}_LDFLAGS "-l${name}" PARENT_SCOPE)

		# add library
		add_library(
				${name}
				SHARED
				IMPORTED
		)
		set_target_properties(
				${name}
				PROPERTIES
				IMPORTED_LOCATION ${path}/lib${name}.so
				IMPORTED_IMPLIB ${path}/lib${name}.a
		)
	endforeach (path IN LISTS SEARCH_PATH)
endfunction(find_system_library_post name)
