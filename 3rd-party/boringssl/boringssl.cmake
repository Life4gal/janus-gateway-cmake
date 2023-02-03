pkg_check_modules(LIB_BORINGSSL QUIET REQUIRED boringssl)

janus_append_link_libraries(${LIB_BORINGSSL_LIBRARIES})
janus_append_link_directories(${LIB_BORINGSSL_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_BORINGSSL_LIBRARIES}-${LIB_BORINGSSL_VERSION})
janus_append_include_directories(${LIB_BORINGSSL_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_BORINGSSL_CFLAGS})
janus_append_ld_flags(${LIB_BORINGSSL_LDFLAGS})
