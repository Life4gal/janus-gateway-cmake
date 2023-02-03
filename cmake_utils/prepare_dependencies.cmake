set(JANUS_LINK_LIBRARIES)
set(JANUS_LINK_DIRECTORIES)
set(JANUS_LINK_LIBRARIES_NAME)
set(JANUS_INCLUDE_DIRECTORIES)
set(JANUS_COMPILE_FLAGS)
set(JANUS_COMPILE_DEFINITIONS)
set(JANUS_LD_FLAGS)

function(janus_verbose_message message)
	# message(${message})
	message(VERBOSE ${message})
endfunction(janus_verbose_message message)

function(janus_print_all_dependencies_info)
	message(STATUS "=======================================")
	# unique
	list(REMOVE_DUPLICATES JANUS_LINK_LIBRARIES)

	message(STATUS "LIBRARIES:")
	foreach (library IN LISTS JANUS_LINK_LIBRARIES)
		message(STATUS "-->\t\t ${library}")
	endforeach (library IN LISTS JANUS_LINK_LIBRARIES)
	message(STATUS "=======================================")

	message(STATUS "=======================================")
	# unique
	list(REMOVE_DUPLICATES JANUS_LINK_DIRECTORIES)

	message(STATUS "DIRECTORIES:")
	foreach (directory IN LISTS JANUS_LINK_DIRECTORIES)
		message(STATUS "-->\t\t ${directory}")
	endforeach (directory IN LISTS JANUS_LINK_DIRECTORIES)
	message(STATUS "=======================================")

	message(STATUS "=======================================")
	# unique
	list(REMOVE_DUPLICATES JANUS_LINK_LIBRARIES_NAME)

	message(STATUS "NAMES:")
	foreach (name IN LISTS JANUS_LINK_LIBRARIES_NAME)
		message(STATUS "-->\t\t ${name}")
	endforeach (name IN LISTS JANUS_LINK_LIBRARIES_NAME)
	message(STATUS "=======================================")

	message(STATUS "=======================================")
	# unique
	list(REMOVE_DUPLICATES JANUS_INCLUDE_DIRECTORIES)

	message(STATUS "INCLUDE:")
	foreach (inc IN LISTS JANUS_INCLUDE_DIRECTORIES)
		message(STATUS "-->\t\t ${inc}")
	endforeach (inc IN LISTS JANUS_INCLUDE_DIRECTORIES)
	message(STATUS "=======================================")

	message(STATUS "=======================================")
	# unique
	list(REMOVE_DUPLICATES JANUS_COMPILE_FLAGS)

	message(STATUS "COMPILE FLAGS:")
	foreach (flag IN LISTS JANUS_COMPILE_FLAGS)
		message(STATUS "-->\t\t ${flag}")
	endforeach (flag IN LISTS JANUS_COMPILE_FLAGS)
	message(STATUS "=======================================")

	message(STATUS "=======================================")
	# unique
	list(REMOVE_DUPLICATES JANUS_COMPILE_DEFINITIONS)

	message(STATUS "COMPILE DEFINITIONS:")
	foreach (definition IN LISTS JANUS_COMPILE_DEFINITIONS)
		message(STATUS "-->\t\t ${definition}")
	endforeach (definition IN LISTS JANUS_COMPILE_DEFINITIONS)
	message(STATUS "=======================================")

	message(STATUS "=======================================")
	# unique
	list(REMOVE_DUPLICATES JANUS_COMPILE_DEFINITIONS)

	message(STATUS "LD FLAGS:")
	foreach (flag IN LISTS JANUS_LD_FLAGS)
		message(STATUS "-->\t\t ${flag}")
	endforeach (flag IN LISTS JANUS_LD_FLAGS)
	message(STATUS "=======================================")
endfunction(janus_print_all_dependencies_info)

function(janus_append_link_libraries)
	foreach (it_lib ${ARGN})
		janus_verbose_message("Append link library [${it_lib}]")
		set(JANUS_LINK_LIBRARIES ${JANUS_LINK_LIBRARIES} ${it_lib} PARENT_SCOPE)
	endforeach ()
endfunction(janus_append_link_libraries)

function(janus_append_link_directories)
	foreach (it_dir ${ARGN})
		janus_verbose_message("Append link library directory [${it_dir}]")
		set(JANUS_LINK_DIRECTORIES ${JANUS_LINK_DIRECTORIES} ${it_dir} PARENT_SCOPE)
	endforeach ()
endfunction(janus_append_link_directories)

function(janus_append_link_libraries_name)
	foreach (it_name ${ARGN})
		janus_verbose_message("Append link library name [${it_name}]")
		set(JANUS_LINK_LIBRARIES_NAME ${JANUS_LINK_LIBRARIES_NAME} ${it_name} PARENT_SCOPE)
	endforeach ()
endfunction(janus_append_link_libraries_name)

function(janus_append_include_directories)
	foreach (it_dir ${ARGN})
		janus_verbose_message("Append include directory [${it_dir}]")
		set(JANUS_INCLUDE_DIRECTORIES ${JANUS_INCLUDE_DIRECTORIES} ${it_dir} PARENT_SCOPE)
	endforeach ()
endfunction(janus_append_include_directories)

function(janus_append_compile_flags)
	foreach (it_flag ${ARGN})
		janus_verbose_message("Append compile flag [${it_flag}]")
		set(JANUS_COMPILE_FLAGS ${JANUS_COMPILE_FLAGS} ${it_flag} PARENT_SCOPE)
	endforeach ()
endfunction(janus_append_compile_flags)

function(janus_append_compile_definitions)
	foreach (it_definition ${ARGN})
		janus_verbose_message("Append compile definition [${it_definition}]")
		set(JANUS_COMPILE_DEFINITIONS ${JANUS_COMPILE_DEFINITIONS} ${it_definition} PARENT_SCOPE)
	endforeach ()
endfunction(janus_append_compile_definitions)

function(janus_append_ld_flags)
	foreach (it_flag ${ARGN})
		janus_verbose_message("Append ld flag [${it_flag}]")
		set(JANUS_LD_FLAGS ${JANUS_LD_FLAGS} ${it_flag} PARENT_SCOPE)
	endforeach ()
endfunction(janus_append_ld_flags)
