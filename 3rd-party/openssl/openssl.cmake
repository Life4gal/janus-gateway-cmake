if (JANUS_PLATFORM_MACOS)
	# todo: A better solution
	set(ENV{PKG_CONFIG_PATH} "/usr/local/opt/openssl@3/lib/pkgconfig")
endif (JANUS_PLATFORM_MACOS)

pkg_check_modules(LIB_OPENSSL QUIET REQUIRED openssl)

janus_append_link_libraries(${LIB_OPENSSL_LIBRARIES})
janus_append_link_directories(${LIB_OPENSSL_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_OPENSSL_LIBRARIES}-${LIB_OPENSSL_VERSION})
janus_append_include_directories(${LIB_OPENSSL_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_OPENSSL_CFLAGS})
janus_append_ld_flags(${LIB_OPENSSL_LDFLAGS})
