function(try_use_opus)
	if (NOT JANUS_PLUGIN_AUDIO_BRIDGE AND NOT JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE)
		return()
	endif (NOT JANUS_PLUGIN_AUDIO_BRIDGE AND NOT JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE)

	pkg_check_modules(LIB_OPUS QUIET opus)

	if (NOT ${LIB_OPUS_FOUND})
		if (JANUS_PLUGIN_AUDIO_BRIDGE)
			message(FATAL_ERROR "opus not found. See README.md for installation instructions or set JANUS_PLUGIN_AUDIO_BRIDGE off")
		elseif (JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE)
			return()
		endif (JANUS_PLUGIN_AUDIO_BRIDGE)
	endif (NOT ${LIB_OPUS_FOUND})

	set(CACHE_OPUS "opus" CACHE INTERNAL "opus." FORCE)
	set(CACHE_OPUS_LIBRARIES ${LIB_OPUS_LIBRARIES} CACHE INTERNAL "opus." FORCE)
	set(CACHE_OPUS_DIRECTORIES ${LIB_OPUS_LIBRARY_DIRS} CACHE INTERNAL "opus." FORCE)
	set(CACHE_OPUS_LIBRARY_NAME ${LIB_OPUS_LIBRARIES}-${LIB_OPUS_VERSION} CACHE INTERNAL "opus." FORCE)
	set(CACHE_OPUS_INCLUDE_DIRECTORIES ${LIB_OPUS_INCLUDE_DIRS} CACHE INTERNAL "opus." FORCE)
	set(CACHE_OPUS_COMPILE_FLAGS ${LIB_OPUS_CFLAGS} CACHE INTERNAL "opus." FORCE)
	set(CACHE_OPUS_LD_FLAGS ${LIB_OPUS_LDFLAGS} CACHE INTERNAL "opus." FORCE)
endfunction(try_use_opus)

try_use_opus()
