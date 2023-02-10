pkg_check_modules(LIB_LIBSSL libssl>=1.0.1)

if (NOT LIB_LIBSSL_FOUND)
	message(FATAL_ERROR "Cannot find libssl on your platform, install it first...")
endif (NOT LIB_LIBSSL_FOUND)

janus_append_link_libraries(${LIB_LIBSSL_LIBRARIES})
janus_append_link_directories(${LIB_LIBSSL_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_LIBSSL_LIBRARIES}-${LIB_LIBSSL_VERSION})
janus_append_include_directories(${LIB_LIBSSL_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_LIBSSL_CFLAGS})
janus_append_ld_flags(${LIB_LIBSSL_LDFLAGS})
