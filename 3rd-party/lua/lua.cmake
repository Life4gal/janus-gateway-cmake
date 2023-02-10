function(try_use_lua)
	if (NOT JANUS_PLUGIN_LUA AND NOT JANUS_PLUGIN_LUA_TRY_USE)
		return()
	endif (NOT JANUS_PLUGIN_LUA AND NOT JANUS_PLUGIN_LUA_TRY_USE)

	# TODO: maybe there is no .pc file?
	pkg_check_modules(LIB_LUA QUIET lua)

	if (NOT LIB_LUA_FOUND)
		set(SEARCH_PATH "/usr/lib/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu")
		set(SEARCH_NAME lua)
		set(SEARCH_NAME_LIB liblua)

		foreach (path IN LISTS SEARCH_PATH)
			# get all so
			file(
					GLOB_RECURSE
					${SEARCH_NAME}_shared_objects
					RELATIVE ${path}

					# liblua + version + .so
					${path}/${SEARCH_NAME_LIB}*.so
			)

			list(LENGTH ${SEARCH_NAME}_shared_objects so_file_size)
			if (${so_file_size} EQUAL 0)
				continue()
			endif (${so_file_size} EQUAL 0)

			# cmake --> Changed in version 3.6: The results will be ordered lexicographically.
			list(POP_BACK ${SEARCH_NAME}_shared_objects so_name)

			# check
			string(REGEX MATCH "^${SEARCH_NAME_LIB}[0-9.]*[.]so$" so_name_valid ${so_name})
			if (NOT so_name_valid)
				continue()
			endif (NOT so_name_valid)

			# get real name
			string(REGEX REPLACE "^${SEARCH_NAME_LIB}([0-9.]*)[.]so$" "${SEARCH_NAME}\\1" name "${so_name}")
			set(so_version ${CMAKE_MATCH_1})

			# set variables
			set(LIB_LUA_FOUND ON)

			set(LIB_LUA_LIBRARIES ${name})
			set(LIB_LUA_VERSION ${so_version})
			set(LIB_LUA_LIBRARY_DIRS ${path})
			# TODO
			set(LIB_LUA_INCLUDE_DIRS "/usr/include/${name}")
			set(LIB_LUA_CFLAGS "")
			set(LIB_LUA_LDFLAGS "-l${name}")

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
					IMPORTED_IMPLIB ${path}/${SEARCH_NAME_LIB}.a
			)

			break()
		endforeach (path IN LISTS SEARCH_PATH)

		if (NOT ${LIB_LUA_FOUND})
			if (JANUS_PLUGIN_LUA)
				message(FATAL_ERROR "LUA not found. See README.md for installation instructions or set JANUS_PLUGIN_LUA off")
			elseif (JANUS_PLUGIN_LUA_TRY_USE)
				return()
			endif (JANUS_PLUGIN_LUA)
		endif (NOT ${LIB_LUA_FOUND})
	endif (NOT LIB_LUA_FOUND)

	set(CACHE_LUA "lua" CACHE INTERNAL "lua." FORCE)
	set(CACHE_LUA_LIBRARIES ${LIB_LUA_LIBRARIES} CACHE INTERNAL "lua." FORCE)
	set(CACHE_LUA_DIRECTORIES ${LIB_LUA_LIBRARY_DIRS} CACHE INTERNAL "lua." FORCE)
	set(CACHE_LUA_LIBRARY_NAME ${LIB_LUA_LIBRARIES}-${LIB_LUA_VERSION} CACHE INTERNAL "lua." FORCE)
	set(CACHE_LUA_INCLUDE_DIRECTORIES ${LIB_LUA_INCLUDE_DIRS} CACHE INTERNAL "lua." FORCE)
	set(CACHE_LUA_COMPILE_FLAGS ${LIB_LUA_CFLAGS} CACHE INTERNAL "lua." FORCE)
	set(CACHE_LUA_LD_FLAGS ${LIB_LUA_LDFLAGS} CACHE INTERNAL "lua." FORCE)
endfunction(try_use_lua)

try_use_lua()
