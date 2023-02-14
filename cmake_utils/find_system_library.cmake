# find_system_library(
#   my_library_name
#   INNER # or POST
#
#   # Users can add additional search directories
#   EXTRA_PATH
#   /my/extra/path/1
#   /my/extra/path/2
#
#   # Users can specify the name of the variable to be defined (by default `name` is used and converted to upper case)
#   VARIABLE_NAME
#   my-library-name # <- Change variable name from LIB_MY_LIBRARY_NAME_XXX to LIB_MY-LIBRARY-NAME_XXX
#
#   # Is the target library necessary, and if so, will raise an error if not found
#   REQUIRED
# )
#
# note: The order of the parameters is not important, it is the `keywords` that matter.
function(
		find_system_library
		name
		type
)
	set(
			SYSTEM_LIBRARY_NAME_TYPE
			# lib${name} + version + .so
			INNER
			# lib${name} + .so + .version
			POST
	)

	list(FIND SYSTEM_LIBRARY_NAME_TYPE ${type} type_index)
	if (type_index EQUAL -1)
		message(FATAL_ERROR "library name type(${type}) must be one of [${SYSTEM_LIBRARY_NAME_TYPE}]")
	endif (type_index EQUAL -1)

	set(prefix FSL)
	set(options REQUIRED)
	set(single_values VARIABLE_NAME)
	set(multi_values EXTRA_PATH)

	include(CMakeParseArguments)

	cmake_parse_arguments(
			PARSE_ARGV
			# parse after `name` and `type`
			2
			"${prefix}"
			"${options}"
			"${single_values}"
			"${multi_values}")

	# message(STATUS "Library ${name} required: ${FSL_REQUIRED}")
	# message(STATUS "Library ${name} variable name: ${FSL_VARIABLE_NAME}")
	# message(STATUS "Library ${name} extra path: ${FSL_EXTRA_PATH}")

	set(
			SEARCH_PATH
			"/usr/lib/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu"
			"${FSL_EXTRA_PATH}"
	)

	foreach (path IN LISTS SEARCH_PATH)
		message(STATUS "Searching [${name}] in [${path}]...")

		# get all so
		if (type_index EQUAL 0)
			# INNER
			file(
					GLOB_RECURSE
					shared_objects
					RELATIVE ${path}

					# lib${name} + version + .so
					${path}/lib${name}*.so
			)
		else ()
			# POST
			file(
					GLOB_RECURSE
					shared_objects
					RELATIVE ${path}

					# lib${name} + .so + .version
					${path}/lib${name}.so*
			)
		endif (type_index EQUAL 0)

		list(LENGTH shared_objects so_file_size)
		if (${so_file_size} EQUAL 0)
			continue()
		endif (${so_file_size} EQUAL 0)

		if (type_index EQUAL 0)
			# INNER
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

			message(STATUS "Found [${so_name}] for [${name}]...")

			# set variables
			if (DEFINED FSL_VARIABLE_NAME)
				string(TOUPPER ${FSL_VARIABLE_NAME} upper_name)
			else ()
				string(TOUPPER ${name} upper_name)
			endif (DEFINED FSL_VARIABLE_NAME)

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

			# search finish
			return()
		else ()
			# POST
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

			message(STATUS "Found [${longest_so_name}] for [${name}]...")

			# set variables
			if (DEFINED FSL_VARIABLE_NAME)
				string(TOUPPER ${FSL_VARIABLE_NAME} upper_name)
			else ()
				string(TOUPPER ${name} upper_name)
			endif (DEFINED FSL_VARIABLE_NAME)

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

			# search finish
			return()
		endif (type_index EQUAL 0)
	endforeach (path IN LISTS SEARCH_PATH)

	if (${FSL_REQUIRED})
		message(FATAL_ERROR "Cannot find library ${name} in [${SEARCH_PATH}]...")
	endif (${FSL_REQUIRED})
endfunction(
		find_system_library
		type
		name
)
