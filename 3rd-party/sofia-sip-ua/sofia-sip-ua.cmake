function(try_use_ssu)
	if (NOT JANUS_PLUGIN_SIP AND NOT JANUS_PLUGIN_SIP_TRY_USE)
		return()
	endif (NOT JANUS_PLUGIN_SIP AND NOT JANUS_PLUGIN_SIP_TRY_USE)

	pkg_check_modules(LIB_SOFIA_SIP_UA QUIET sofia-sip-ua)

	if (NOT ${LIB_SOFIA_SIP_UA_FOUND})
		if (JANUS_PLUGIN_SIP)
			message(FATAL_ERROR "sofia-sip-ua not found. See README.md for installation instructions or set JANUS_PLUGIN_SIP off")
		elseif (JANUS_PLUGIN_SIP_TRY_USE)
			return()
		endif (JANUS_PLUGIN_SIP)
	endif (NOT ${LIB_SOFIA_SIP_UA_FOUND})

	janus_append_link_libraries(${LIB_SOFIA_SIP_UA_LIBRARIES})
	janus_append_link_directories(${LIB_SOFIA_SIP_UA_LIBRARY_DIRS})
	janus_append_link_libraries_name(${LIB_SOFIA_SIP_UA_LIBRARIES}-${LIB_SOFIA_SIP_UA_VERSION})
	janus_append_include_directories(${LIB_SOFIA_SIP_UA_INCLUDE_DIRS})
	janus_append_compile_flags(${LIB_SOFIA_SIP_UA_CFLAGS})
	janus_append_ld_flags(${LIB_SOFIA_SIP_UA_LDFLAGS})
endfunction(try_use_ssu)

try_use_ssu()
