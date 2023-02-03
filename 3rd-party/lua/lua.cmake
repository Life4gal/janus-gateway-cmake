function(try_use_lua)
	if (NOT JANUS_PLUGIN_LUA AND NOT JANUS_PLUGIN_LUA_TRY_USE)
		return()
	endif (NOT JANUS_PLUGIN_LUA AND NOT JANUS_PLUGIN_LUA_TRY_USE)

	pkg_check_modules(LIB_LUA QUIET lua)

	if (NOT ${LIB_LUA_FOUND})
		if (JANUS_PLUGIN_LUA)
			message(FATAL_ERROR "LUA not found. See README.md for installation instructions or set JANUS_PLUGIN_LUA off")
		elseif (JANUS_PLUGIN_LUA_TRY_USE)
			return()
		endif (JANUS_PLUGIN_LUA)
	endif (NOT ${LIB_LUA_FOUND})

	janus_append_link_libraries(${LIB_LUA_LIBRARIES})
	janus_append_link_directories(${LIB_LUA_LIBRARY_DIRS})
	janus_append_link_libraries_name(${LIB_LUA_LIBRARIES}-${LIB_LUA_VERSION})
	janus_append_include_directories(${LIB_LUA_INCLUDE_DIRS})
	janus_append_compile_flags(${LIB_LUA_CFLAGS})
	janus_append_ld_flags(${LIB_LUA_LDFLAGS})
endfunction(try_use_lua)

try_use_lua()
