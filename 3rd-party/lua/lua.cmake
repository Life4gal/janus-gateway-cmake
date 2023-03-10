function(try_use_lua)
	if (NOT JANUS_PLUGIN_LUA AND NOT JANUS_PLUGIN_LUA_TRY_USE)
		return()
	endif (NOT JANUS_PLUGIN_LUA AND NOT JANUS_PLUGIN_LUA_TRY_USE)

	# TODO: maybe there is no .pc file?
	pkg_check_modules(LIB_LUA QUIET lua)

	if (NOT LIB_LUA_FOUND)
		find_system_library(
				lua
				INNER
		)

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
	set(CACHE_LUA_LIBRARY_NAME lua-${LIB_LUA_VERSION} CACHE INTERNAL "lua." FORCE)
	set(CACHE_LUA_INCLUDE_DIRECTORIES ${LIB_LUA_INCLUDE_DIRS} CACHE INTERNAL "lua." FORCE)
	set(CACHE_LUA_COMPILE_FLAGS ${LIB_LUA_CFLAGS} CACHE INTERNAL "lua." FORCE)
	set(CACHE_LUA_LD_FLAGS ${LIB_LUA_LDFLAGS} CACHE INTERNAL "lua." FORCE)
endfunction(try_use_lua)

try_use_lua()
