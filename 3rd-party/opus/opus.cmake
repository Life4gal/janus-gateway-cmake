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

	janus_append_link_libraries(${LIB_OPUS_LIBRARIES})
	janus_append_link_directories(${LIB_OPUS_LIBRARY_DIRS})
	janus_append_link_libraries_name(${LIB_OPUS_LIBRARIES}-${LIB_OPUS_VERSION})
	janus_append_include_directories(${LIB_OPUS_INCLUDE_DIRS})
	janus_append_compile_flags(${LIB_OPUS_CFLAGS})
	janus_append_ld_flags(${LIB_OPUS_LDFLAGS})

	set(JANUS_DEPENDENCY_OPUS_USED ON)
endfunction(try_use_opus)

try_use_opus()
