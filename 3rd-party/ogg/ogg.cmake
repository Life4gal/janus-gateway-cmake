function(try_use_ogg)
	if (NOT JANUS_PLUGIN_VOICE_MAIL AND NOT JANUS_PLUGIN_VOICE_MAIL_TRY_USE)
		return()
	endif (NOT JANUS_PLUGIN_VOICE_MAIL AND NOT JANUS_PLUGIN_VOICE_MAIL_TRY_USE)

	pkg_check_modules(LIB_OGG QUIET ogg)

	if (NOT ${LIB_OGG_FOUND})
		if (JANUS_PLUGIN_AUDIO_BRIDGE)
			message(FATAL_ERROR "OGG not found. See README.md for installation instructions or set JANUS_PLUGIN_VOICE_MAIL off")
		elseif (JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE)
			return()
		endif (JANUS_PLUGIN_AUDIO_BRIDGE)
	endif (NOT ${LIB_OGG_FOUND})

	janus_append_link_libraries(${LIB_OGG_LIBRARIES})
	janus_append_link_directories(${LIB_OGG_LIBRARY_DIRS})
	janus_append_link_libraries_name(${LIB_OGG_LIBRARIES}-${LIB_OGG_VERSION})
	janus_append_include_directories(${LIB_OGG_INCLUDE_DIRS})
	janus_append_compile_flags(${LIB_OGG_CFLAGS})
	janus_append_ld_flags(${LIB_OGG_LDFLAGS})

	set(JANUS_DEPENDENCY_OGG_USED ON PARENT_SCOPE)
endfunction(try_use_ogg)

try_use_ogg()
