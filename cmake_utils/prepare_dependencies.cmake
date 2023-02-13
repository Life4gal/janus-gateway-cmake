set(JANUS_LINK_LIBRARIES "" CACHE INTERNAL "janus link libraries" FORCE)
set(JANUS_LINK_DIRECTORIES "" CACHE INTERNAL "janus link directories" FORCE)
set(JANUS_LINK_LIBRARIES_NAME "" CACHE INTERNAL "janus link library names" FORCE)
set(JANUS_INCLUDE_DIRECTORIES "" CACHE INTERNAL "janus include directory" FORCE)
set(JANUS_COMPILE_FLAGS "" CACHE INTERNAL "janus compile flags" FORCE)
# TODO: Is it necessary? We can use `JANUS_COMPILE_FLAGS`.
set(JANUS_COMPILE_DEFINITIONS "" CACHE INTERNAL "janus compile definitions" FORCE)
set(JANUS_LD_FLAGS "" CACHE INTERNAL "janus ld flags" FORCE)

set(JANUS_EXTRA_SOURCE_FILES "" CACHE INTERNAL "janus extra source" FORCE)
set(JANUS_CONF_FILES "" CACHE INTERNAL "janus conf file" FORCE)

set(JANUS_EXTRA_LIBRARIES "" CACHE INTERNAL "janus extra libraries" FORCE)
set(JANUS_EXTRA_LIBRARIES_SOURCE_FILES "" CACHE INTERNAL "janus extra libraries source files" FORCE)
set(JANUS_EXTRA_LIBRARIES_CONF_FILES "" CACHE INTERNAL "janus extra libraries conf files" FORCE)
set(JANUS_EXTRA_LIBRARIES_COMMON_COMPILE_FLAGS "" CACHE INTERNAL "janus extra libraries common compile flags" FORCE)
set(JANUS_EXTRA_LIBRARIES_COMMON_LD_FLAGS "" CACHE INTERNAL "janus extra libraries common ld flags" FORCE)

function(janus_verbose_message message)
	#message(${message})
	message(VERBOSE ${message})
endfunction(janus_verbose_message message)

function(janus_print_all_dependencies_info)
	message(STATUS "=======================================")

	message(STATUS "LIBRARIES:")
	#foreach (library IN LISTS $CACHE{JANUS_LINK_LIBRARIES})
	#	message(STATUS "-->\t\t ${library}")
	#endforeach (library IN LISTS $CACHE{JANUS_LINK_LIBRARIES})
	foreach (library IN LISTS JANUS_LINK_LIBRARIES)
		message(STATUS "-->\t\t ${library}")
	endforeach (library IN LISTS JANUS_LINK_LIBRARIES)

	message(STATUS "=======================================")

	message(STATUS "DIRECTORIES:")
	#foreach (directory IN LISTS $CACHE{JANUS_LINK_DIRECTORIES})
	#	message(STATUS "-->\t\t ${directory}")
	#endforeach (directory IN LISTS $CACHE{JANUS_LINK_DIRECTORIES})
	foreach (directory IN LISTS JANUS_LINK_DIRECTORIES)
		message(STATUS "-->\t\t ${directory}")
	endforeach (directory IN LISTS JANUS_LINK_DIRECTORIES)

	message(STATUS "=======================================")

	message(STATUS "NAMES:")
	#foreach (name IN LISTS $CACHE{JANUS_LINK_LIBRARIES_NAME})
	#	message(STATUS "-->\t\t ${name}")
	#endforeach (name IN LISTS $CACHE{JANUS_LINK_LIBRARIES_NAME})
	foreach (name IN LISTS JANUS_LINK_LIBRARIES_NAME)
		message(STATUS "-->\t\t ${name}")
	endforeach (name IN LISTS JANUS_LINK_LIBRARIES_NAME)

	message(STATUS "=======================================")

	message(STATUS "INCLUDE:")
	#foreach (inc IN LISTS $CACHE{JANUS_INCLUDE_DIRECTORIES})
	#	message(STATUS "-->\t\t ${inc}")
	#endforeach (inc IN LISTS $CACHE{JANUS_INCLUDE_DIRECTORIES})
	foreach (inc IN LISTS JANUS_INCLUDE_DIRECTORIES)
		message(STATUS "-->\t\t ${inc}")
	endforeach (inc IN LISTS JANUS_INCLUDE_DIRECTORIES)

	message(STATUS "=======================================")

	message(STATUS "COMPILE FLAGS:")
	#foreach (flag IN LISTS $CACHE{JANUS_COMPILE_FLAGS})
	#	message(STATUS "-->\t\t ${flag}")
	#endforeach (flag IN LISTS $CACHE{JANUS_COMPILE_FLAGS})
	foreach (flag IN LISTS JANUS_COMPILE_FLAGS)
		message(STATUS "-->\t\t ${flag}")
	endforeach (flag IN LISTS JANUS_COMPILE_FLAGS)

	message(STATUS "=======================================")

	message(STATUS "COMPILE DEFINITIONS:")
	#foreach (definition IN LISTS $CACHE{JANUS_COMPILE_DEFINITIONS})
	#	message(STATUS "-->\t\t ${definition}")
	#endforeach (definition IN LISTS $CACHE{JANUS_COMPILE_DEFINITIONS})
	foreach (definition IN LISTS JANUS_COMPILE_DEFINITIONS)
		message(STATUS "-->\t\t ${definition}")
	endforeach (definition IN LISTS JANUS_COMPILE_DEFINITIONS)

	message(STATUS "=======================================")

	message(STATUS "LD FLAGS:")
	#foreach (flag IN LISTS $CACHE{JANUS_LD_FLAGS})
	#	message(STATUS "-->\t\t ${flag}")
	#endforeach (flag IN LISTS $CACHE{JANUS_LD_FLAGS})
	foreach (flag IN LISTS JANUS_LD_FLAGS)
		message(STATUS "-->\t\t ${flag}")
	endforeach (flag IN LISTS JANUS_LD_FLAGS)

	message(STATUS "=======================================")

	message(STATUS "EXTRA SOURCE FILES:")
	#foreach (file IN LISTS $CACHE{JANUS_EXTRA_SOURCE_FILES})
	#	message(STATUS "-->\t\t ${file}")
	#endforeach (file IN LISTS $CACHE{JANUS_EXTRA_SOURCE_FILES})
	foreach (file IN LISTS JANUS_EXTRA_SOURCE_FILES)
		message(STATUS "-->\t\t ${file}")
	endforeach (file IN LISTS JANUS_EXTRA_SOURCE_FILES)

	message(STATUS "=======================================")

	message(STATUS "CONF FILES:")
	#foreach (file IN LISTS $CACHE{JANUS_CONF_FILES})
	#	message(STATUS "-->\t\t ${file}")
	#endforeach (file IN LISTS $CACHE{JANUS_CONF_FILES})
	foreach (file IN LISTS JANUS_CONF_FILES)
		message(STATUS "-->\t\t ${file}")
	endforeach (file IN LISTS JANUS_CONF_FILES)

	message(STATUS "=======================================")

	message(STATUS "EXTRA LIBRARIES:")
	#foreach (library IN LISTS $CACHE{JANUS_EXTRA_LIBRARIES})
	#	message(STATUS "-->\t\t ${library}")
	#endforeach (library IN LISTS $CACHE{JANUS_EXTRA_LIBRARIES})
	foreach (library IN LISTS JANUS_EXTRA_LIBRARIES)
		message(STATUS "-->\t\t ${library}")
	endforeach (library IN LISTS JANUS_EXTRA_LIBRARIES)

	message(STATUS "=======================================")

	message(STATUS "EXTRA LIBRARIES SOURCE FILES:")
	#foreach (file IN LISTS $CACHE{JANUS_EXTRA_LIBRARIES_SOURCE_FILES})
	#	message(STATUS "-->\t\t ${file}")
	#endforeach (file IN LISTS $CACHE{JANUS_EXTRA_LIBRARIES_SOURCE_FILES})
	foreach (file IN LISTS JANUS_EXTRA_LIBRARIES_SOURCE_FILES)
		message(STATUS "-->\t\t ${file}")
	endforeach (file IN LISTS JANUS_EXTRA_LIBRARIES_SOURCE_FILES)

	message(STATUS "=======================================")

	message(STATUS "EXTRA LIBRARIES CONFIG FILES:")
	#foreach (file IN LISTS $CACHE{JANUS_EXTRA_LIBRARIES_CONF_FILES})
	#	message(STATUS "-->\t\t ${file}")
	#endforeach (file IN LISTS $CACHE{JANUS_EXTRA_LIBRARIES_CONF_FILES})
	foreach (file IN LISTS JANUS_EXTRA_LIBRARIES_CONF_FILES)
		message(STATUS "-->\t\t ${file}")
	endforeach (file IN LISTS JANUS_EXTRA_LIBRARIES_CONF_FILES)

	message(STATUS "=======================================")

	message(STATUS "EXTRA LIBRARIES COMMON COMPILE FLAGS:")
	#foreach (flag IN LISTS $CACHE{JANUS_EXTRA_LIBRARIES_COMMON_COMPILE_FLAGS})
	#	message(STATUS "-->\t\t ${flag}")
	#endforeach (flag IN LISTS $CACHE{JANUS_EXTRA_LIBRARIES_COMMON_COMPILE_FLAGS})
	foreach (flag IN LISTS JANUS_EXTRA_LIBRARIES_COMMON_COMPILE_FLAGS)
		message(STATUS "-->\t\t ${flag}")
	endforeach (flag IN LISTS JANUS_EXTRA_LIBRARIES_COMMON_COMPILE_FLAGS)

	message(STATUS "=======================================")

	message(STATUS "EXTRA LIBRARIES CMMON LD FLAGS:")
	#foreach (flag IN LISTS $CACHE{JANUS_EXTRA_LIBRARIES_COMMON_COMPILE_FLAGS})
	#	message(STATUS "-->\t\t ${flag}")
	#endforeach (flag IN LISTS $CACHE{JANUS_EXTRA_LIBRARIES_COMMON_COMPILE_FLAGS})
	foreach (flag IN LISTS JANUS_EXTRA_LIBRARIES_COMMON_LD_FLAGS)
		message(STATUS "-->\t\t ${flag}")
	endforeach (flag IN LISTS JANUS_EXTRA_LIBRARIES_COMMON_LD_FLAGS)

	message(STATUS "=======================================")
endfunction(janus_print_all_dependencies_info)

function(janus_append_link_libraries)
	foreach (it_lib ${ARGN})
		#list(FIND JANUS_LINK_LIBRARIES ${it_lib} index)
		#if (${index} EQUAL -1)
		janus_verbose_message("Append link library [${it_lib}]")
		set(JANUS_LINK_LIBRARIES ${JANUS_LINK_LIBRARIES} ${it_lib} CACHE INTERNAL "janus link libraries" FORCE)
		#endif (${index} EQUAL -1)
	endforeach (it_lib ${ARGN})
endfunction(janus_append_link_libraries)

function(janus_append_link_directories)
	foreach (it_dir ${ARGN})
		list(FIND JANUS_LINK_DIRECTORIES ${it_dir} index)
		if (${index} EQUAL -1)
			janus_verbose_message("Append link library directory [${it_dir}]")
			set(JANUS_LINK_DIRECTORIES ${JANUS_LINK_DIRECTORIES} ${it_dir} CACHE INTERNAL "janus link directories" FORCE)
		endif (${index} EQUAL -1)
	endforeach (it_dir ${ARGN})
endfunction(janus_append_link_directories)

function(janus_append_link_libraries_name)
	foreach (it_name ${ARGN})
		list(FIND JANUS_LINK_LIBRARIES_NAME ${it_name} index)
		if (${index} EQUAL -1)
			janus_verbose_message("Append link library name [${it_name}]")
			set(JANUS_LINK_LIBRARIES_NAME ${JANUS_LINK_LIBRARIES_NAME} ${it_name} CACHE INTERNAL "janus link library names" FORCE)
		endif (${index} EQUAL -1)
	endforeach (it_name ${ARGN})
endfunction(janus_append_link_libraries_name)

function(janus_append_include_directories)
	foreach (it_dir ${ARGN})
		list(FIND JANUS_INCLUDE_DIRECTORIES ${it_dir} index)
		if (${index} EQUAL -1)
			janus_verbose_message("Append include directory [${it_dir}]")
			set(JANUS_INCLUDE_DIRECTORIES ${JANUS_INCLUDE_DIRECTORIES} ${it_dir} CACHE INTERNAL "janus include directory" FORCE)
		endif (${index} EQUAL -1)
	endforeach (it_dir ${ARGN})
endfunction(janus_append_include_directories)

function(janus_append_compile_flags)
	foreach (it_flag ${ARGN})
		#list(FIND JANUS_COMPILE_FLAGS ${it_flag} index)
		#if (${index} EQUAL -1)
		janus_verbose_message("Append compile flag [${it_flag}]")
		set(JANUS_COMPILE_FLAGS ${JANUS_COMPILE_FLAGS} ${it_flag} CACHE INTERNAL "janus compile flags" FORCE)
		#endif (${index} EQUAL -1)
	endforeach (it_flag ${ARGN})
endfunction(janus_append_compile_flags)

function(janus_append_compile_definitions)
	foreach (it_definition ${ARGN})
		#list(FIND JANUS_COMPILE_DEFINITIONS ${it_definition} index)
		#if (${index} EQUAL -1)
		janus_verbose_message("Append compile definition [${it_definition}]")
		set(JANUS_COMPILE_DEFINITIONS ${JANUS_COMPILE_DEFINITIONS} ${it_definition} CACHE INTERNAL "janus compile definitions" FORCE)
		#endif (${index} EQUAL -1)
	endforeach (it_definition ${ARGN})
endfunction(janus_append_compile_definitions)

function(janus_append_ld_flags)
	foreach (it_flag ${ARGN})
		#list(FIND JANUS_LD_FLAGS ${it_flag} index)
		#if (${index} EQUAL -1)
		janus_verbose_message("Append ld flag [${it_flag}]")
		set(JANUS_LD_FLAGS ${JANUS_LD_FLAGS} ${it_flag} CACHE INTERNAL "janus ld flags" FORCE)
		#endif (${index} EQUAL -1)
	endforeach (it_flag ${ARGN})
endfunction(janus_append_ld_flags)

function(janus_append_source_file)
	foreach (it_file ${ARGN})
		list(FIND JANUS_EXTRA_SOURCE_FILES ${it_file} index)
		if (${index} EQUAL -1)
			janus_verbose_message("Append source file [${it_file}]")
			set(JANUS_EXTRA_SOURCE_FILES ${JANUS_EXTRA_SOURCE_FILES} ${it_file} CACHE INTERNAL "janus extra source" FORCE)
		else ()
			message(FATAL_ERROR "Duplicate source file [${it_file}].")
		endif (${index} EQUAL -1)
	endforeach (it_file ${ARGN})
endfunction(janus_append_source_file)

function(janus_append_config_file)
	foreach (it_file ${ARGN})
		list(FIND JANUS_CONF_FILES ${it_file} index)
		if (${index} EQUAL -1)
			janus_verbose_message("Append config file [${it_file}]")
			set(JANUS_CONF_FILES ${JANUS_CONF_FILES} ${it_file} CACHE INTERNAL "janus conf source" FORCE)
		else ()
			message(FATAL_ERROR "Duplicate config file [${it_file}].")
		endif (${index} EQUAL -1)
	endforeach (it_file ${ARGN})
endfunction(janus_append_config_file)

function(
		janus_append_extra_libraries
		name
		source
		dest_path
		config_path

		link_libraries
		link_directories
		include_directories
		compile_flags
		ld_flags
)
	janus_verbose_message(
			"Build library [${name}]\n"
			"--> source: [${source}]\n"
			"--> dest_path: [${dest_path}]\n"
			"--> config_path: [${config_path}]\n"
			"--> link_libraries: [${link_libraries}]\n"
			"--> link_directories: [${link_directories}]\n"
			"--> include_directories: [${include_directories}]\n"
			"--> compile_flags: [${compile_flags}]\n"
			"--> ld_flags: [${ld_flags}]\n"
	)

	add_library(
			${name}
			MODULE
			${source}
	)
	set_target_properties(
			${name}
			PROPERTIES
			LIBRARY_OUTPUT_DIRECTORY ${dest_path}
	)
	add_dependencies(
			janus_dummy_lib_do_not_build_it
			${name}
	)
	target_include_directories(
			${name}
			PUBLIC

			$<BUILD_INTERFACE:${JANUS_HEADER_FILES_PATH}>
			$<INSTALL_INTERFACE:${JANUS_INSTALL_HEADERS}/${PROJECT_NAME}-${PROJECT_VERSION}>
	)

	set(JANUS_EXTRA_LIBRARIES ${JANUS_EXTRA_LIBRARIES} ${name} CACHE INTERNAL "janus extra libraries" FORCE)

	foreach (file IN LISTS source)
		list(FIND JANUS_EXTRA_LIBRARIES_SOURCE_FILES ${file} source_file_index)
		if (NOT ${source_file_index} EQUAL -1)
			message(FATAL_ERROR "Duplicate source file --> ${file}.")
		endif (NOT ${source_file_index} EQUAL -1)

		set(JANUS_EXTRA_LIBRARIES_SOURCE_FILES ${JANUS_EXTRA_LIBRARIES_SOURCE_FILES} ${file} CACHE INTERNAL "janus extra libraries source files" FORCE)
	endforeach (file IN LISTS source)

	foreach (file IN LISTS config_path)
		list(FIND JANUS_EXTRA_LIBRARIES_CONF_FILES ${file} index)
		if (${index} EQUAL -1)
			janus_verbose_message("Append config file [${file}]")
			set(JANUS_EXTRA_LIBRARIES_CONF_FILES ${JANUS_EXTRA_LIBRARIES_CONF_FILES} ${file} CACHE INTERNAL "janus extra libraries conf files" FORCE)
		else ()
			message(FATAL_ERROR "Duplicate config file [${file}].")
		endif (${index} EQUAL -1)
	endforeach (file IN LISTS config_path)

	list(LENGTH link_libraries link_libraries_length)
	if (NOT ${link_libraries_length} EQUAL 0)
		target_link_libraries(
				${name}
				PRIVATE
				${link_libraries}
		)
	endif (NOT ${link_libraries_length} EQUAL 0)

	list(LENGTH link_directories link_directories_length)
	if (NOT ${link_directories_length} EQUAL 0)
		target_link_directories(
				${name}
				PRIVATE
				${link_directories}
		)
	endif (NOT ${link_directories_length} EQUAL 0)

	list(LENGTH include_directories include_directories_length)
	if (NOT ${include_directories_length} EQUAL 0)
		target_include_directories(
				${name}
				PRIVATE
				${include_directories}
		)
	endif (NOT ${include_directories_length} EQUAL 0)

	list(LENGTH compile_flags compile_flags_length)
	if (NOT ${compile_flags_length} EQUAL 0)
		target_compile_options(
				${name}
				PRIVATE
				${compile_flags}
		)
	endif (NOT ${compile_flags_length} EQUAL 0)
	target_compile_options(
			${name}
			PRIVATE
			${JANUS_EXTRA_LIBRARIES_COMMON_COMPILE_FLAGS}
	)

	list(LENGTH ld_flags ld_flags_length)
	if (NOT ${ld_flags_length} EQUAL 0)
		target_link_options(
				${name}
				PRIVATE
				${ld_flags}
		)
	endif (NOT ${ld_flags_length} EQUAL 0)
	target_link_options(
			${name}
			PRIVATE
			${JANUS_EXTRA_LIBRARIES_COMMON_LD_FLAGS}
	)
endfunction(
		janus_append_extra_libraries
		name
		source
		dest_path
		config_path

		link_libraries
		link_directories
		include_directories
		compile_flags
		ld_flags
)
