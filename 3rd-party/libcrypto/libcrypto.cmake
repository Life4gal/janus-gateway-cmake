pkg_check_modules(LIB_LIBCRYPTO QUIET REQUIRED libcrypto)

janus_append_link_libraries(${LIB_LIBCRYPTO_LIBRARIES})
janus_append_link_directories(${LIB_LIBCRYPTO_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_LIBCRYPTO_LIBRARIES}-${LIB_LIBCRYPTO_VERSION})
janus_append_include_directories(${LIB_LIBCRYPTO_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_LIBCRYPTO_CFLAGS})
janus_append_ld_flags(${LIB_LIBCRYPTO_LDFLAGS})
