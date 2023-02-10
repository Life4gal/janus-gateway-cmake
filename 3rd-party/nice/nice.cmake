pkg_check_modules(LIB_NICE QUIET nice)

if (NOT ${LIB_NICE_FOUND})
	message(FATAL_ERROR "Cannot find nice on your platform, install it first...")
endif (NOT ${LIB_NICE_FOUND})

janus_append_link_libraries(${LIB_NICE_LIBRARIES})
janus_append_link_directories(${LIB_NICE_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_NICE_LIBRARIES}-${LIB_NICE_VERSION})
janus_append_include_directories(${LIB_NICE_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_NICE_CFLAGS})
janus_append_ld_flags(${LIB_NICE_LDFLAGS})

include(CheckLibraryExists)

CHECK_LIBRARY_EXISTS(
		nice
		nice_agent_set_port_range
		"${LIB_NICE_LIBRARY_DIRS}"
		LIB_NICE_HAS_nice_agent_set_port_range
)
if (LIB_NICE_HAS_nice_agent_set_port_range)
	janus_append_compile_definitions(HAVE_PORTRANGE)
else ()
	message(WARNING "nice-${LIB_NICE_VERSION} does not have nice_agent_set_port_range")
endif (LIB_NICE_HAS_nice_agent_set_port_range)

CHECK_LIBRARY_EXISTS(
		nice
		nice_address_equal_no_port
		"${LIB_NICE_LIBRARY_DIRS}"
		LIB_NICE_HAS_nice_address_equal_no_port
)
if (LIB_NICE_HAS_nice_address_equal_no_port)
	janus_append_compile_definitions(HAVE_LIBNICE_TCP)
else ()
	message(WARNING "nice-${LIB_NICE_VERSION} does not support TCP candidates")
endif (LIB_NICE_HAS_nice_address_equal_no_port)

CHECK_LIBRARY_EXISTS(
		nice
		nice_agent_close_async
		"${LIB_NICE_LIBRARY_DIRS}"
		LIB_NICE_HAS_nice_agent_close_async
)
if (LIB_NICE_HAS_nice_agent_close_async)
	janus_append_compile_definitions(HAVE_CLOSE_ASYNC)
else ()
	message(WARNING "nice-${LIB_NICE_VERSION} does not have nice_agent_close_async")
endif (LIB_NICE_HAS_nice_agent_close_async)

CHECK_LIBRARY_EXISTS(
		nice
		nice_agent_new_full
		"${LIB_NICE_LIBRARY_DIRS}"
		LIB_NICE_HAS_nice_agent_new_full
)
if (LIB_NICE_HAS_nice_agent_new_full)
	janus_append_compile_definitions(HAVE_ICE_NOMINATION)
else ()
	message(WARNING "nice-${LIB_NICE_VERSION} does not have nice_agent_new_full")
endif (LIB_NICE_HAS_nice_agent_new_full)
