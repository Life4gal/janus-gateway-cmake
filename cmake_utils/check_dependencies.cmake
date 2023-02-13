include(${PROJECT_SOURCE_DIR}/cmake_utils/prepare_dependencies.cmake)

# config
janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.jcfg.sample)

find_package(PkgConfig REQUIRED)

# math
janus_append_link_libraries("m")
janus_append_ld_flags("-lm")

# LIB_GLIB AND LIB_GIO
include(${JANUS_3RD_PARTY_PATH}/glib/gio.cmake)
janus_append_link_libraries($CACHE{CACHE_GIO_LIBRARIES})
janus_append_link_directories($CACHE{CACHE_GIO_DIRECTORIES})
janus_append_link_libraries_name($CACHE{CACHE_GIO_LIBRARY_NAME})
janus_append_include_directories($CACHE{CACHE_GIO_INCLUDE_DIRECTORIES})
janus_append_compile_flags($CACHE{CACHE_GIO_COMPILE_FLAGS})
janus_append_ld_flags($CACHE{CACHE_GIO_LD_FLAGS})

# LIB_LIBCONFIG
include(${JANUS_3RD_PARTY_PATH}/libconfig/libconfig.cmake)
janus_append_link_libraries($CACHE{CACHE_LIBCONFIG_LIBRARIES})
janus_append_link_directories($CACHE{CACHE_LIBCONFIG_DIRECTORIES})
janus_append_link_libraries_name($CACHE{CACHE_LIBCONFIG_LIBRARY_NAME})
janus_append_include_directories($CACHE{CACHE_LIBCONFIG_INCLUDE_DIRECTORIES})
janus_append_compile_flags($CACHE{CACHE_LIBCONFIG_COMPILE_FLAGS})
janus_append_ld_flags($CACHE{CACHE_LIBCONFIG_LD_FLAGS})

# LIB_NICE
include(${JANUS_3RD_PARTY_PATH}/nice/nice.cmake)

# LIB_JANSSON
include(${JANUS_3RD_PARTY_PATH}/jansson/jansson.cmake)
janus_append_link_libraries($CACHE{CACHE_JANSSON_LIBRARIES})
janus_append_link_directories($CACHE{CACHE_JANSSON_DIRECTORIES})
janus_append_link_libraries_name($CACHE{CACHE_JANSSON_LIBRARY_NAME})
janus_append_include_directories($CACHE{CACHE_JANSSON_INCLUDE_DIRECTORIES})
janus_append_compile_flags($CACHE{CACHE_JANSSON_COMPILE_FLAGS})
janus_append_ld_flags($CACHE{CACHE_JANSSON_LD_FLAGS})

# LIB_ZLIB
include(${JANUS_3RD_PARTY_PATH}/zlib/zlib.cmake)
janus_append_link_libraries($CACHE{CACHE_ZLIB_LIBRARIES})
janus_append_link_directories($CACHE{CACHE_ZLIB_DIRECTORIES})
janus_append_link_libraries_name($CACHE{CACHE_ZLIB_LIBRARY_NAME})
janus_append_include_directories($CACHE{CACHE_ZLIB_INCLUDE_DIRECTORIES})
janus_append_compile_flags($CACHE{CACHE_ZLIB_COMPILE_FLAGS})
janus_append_ld_flags($CACHE{CACHE_ZLIB_LD_FLAGS})

# TODO
#if (NOT JANUS_PLATFORM_IS_BSD)
#	# LIB_LIBSSL
#	include(${JANUS_3RD_PARTY_PATH}/libssl/libssl.cmake)
#	# LIB_LIBCRYPTO
#	include(${JANUS_3RD_PARTY_PATH}/libcrypto/libcrypto.cmake)
#endif (NOT JANUS_PLATFORM_IS_BSD)

# TODO: variable name?
# LIB_OPENSSL OR LIB_BORINGSSL
if (JANUS_BORINGSSL)
	message(STATUS "Trying to use BoringSSL instead of OpenSSL...")
	include(${JANUS_3RD_PARTY_PATH}/boringssl/boringssl.cmake)

	set(CACHE_SSL $CACHE{CACHE_BORINGSSL} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_LIBRARIES $CACHE{CACHE_BORINGSSL_LIBRARIES} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_DIRECTORIES $CACHE{CACHE_BORINGSSL_DIRECTORIES} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_LIBRARY_NAME $CACHE{CACHE_BORINGSSL_LIBRARY_NAME} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_INCLUDE_DIRECTORIES $CACHE{CACHE_BORINGSSL_INCLUDE_DIRECTORIES} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_COMPILE_FLAGS $CACHE{CACHE_BORINGSSL_COMPILE_FLAGS} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_LD_FLAGS $CACHE{CACHE_BORINGSSL_LD_FLAGS} CACHE INTERNAL "ssl." FORCE)
else ()
	include(${JANUS_3RD_PARTY_PATH}/openssl/openssl.cmake)

	set(CACHE_SSL $CACHE{CACHE_OPENSSL} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_LIBRARIES $CACHE{CACHE_OPENSSL_LIBRARIES} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_DIRECTORIES $CACHE{CACHE_OPENSSL_DIRECTORIES} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_LIBRARY_NAME $CACHE{CACHE_OPENSSL_LIBRARY_NAME} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_INCLUDE_DIRECTORIES $CACHE{CACHE_OPENSSL_INCLUDE_DIRECTORIES} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_COMPILE_FLAGS $CACHE{CACHE_OPENSSL_COMPILE_FLAGS} CACHE INTERNAL "ssl." FORCE)
	set(CACHE_SSL_LD_FLAGS $CACHE{CACHE_OPENSSL_LD_FLAGS} CACHE INTERNAL "ssl." FORCE)
endif (JANUS_BORINGSSL)
janus_append_link_libraries($CACHE{CACHE_SSL_LIBRARIES})
janus_append_link_directories($CACHE{CACHE_SSL_DIRECTORIES})
janus_append_link_libraries_name($CACHE{CACHE_SSL_LIBRARY_NAME})
janus_append_include_directories($CACHE{CACHE_SSL_INCLUDE_DIRECTORIES})
janus_append_compile_flags($CACHE{CACHE_SSL_COMPILE_FLAGS})
janus_append_ld_flags($CACHE{CACHE_SSL_LD_FLAGS})

if (JANUS_DTLS_SET_TIMEOUT)
	message(STATUS "Assuming DTLSv1_set_initial_timeout_duration is available")
	janus_append_compile_definitions(HAVE_DTLS_SETTIMEOUT)
endif (JANUS_DTLS_SET_TIMEOUT)

if (JANUS_PTHREAD_MUTEX)
	message(STATUS "Will use pthread_mutex instead of GMutex")
	janus_append_compile_definitions(USE_PTHREAD_MUTEX)

	set(JANUS_EXTRA_LIBRARIES_COMMON_COMPILE_FLAGS ${JANUS_TRANSPORT_COMPILE_FLAGS} "-DUSE_PTHREAD_MUTEX" CACHE INTERNAL "janus extra transport compile flags" FORCE)
	set(JANUS_EXTRA_LIBRARIES_COMMON_LD_FLAGS ${JANUS_TRANSPORT_LD_FLAGS} "-lpthread" CACHE INTERNAL "janus extra transport ld flags" FORCE)
endif (JANUS_PTHREAD_MUTEX)

# LIB_DL
janus_append_link_libraries(${CMAKE_DL_LIBS})
janus_append_link_libraries_name(${CMAKE_DL_LIBS})

# LIB_SRTP
include(${JANUS_3RD_PARTY_PATH}/srtp/srtp.cmake)
janus_append_link_libraries($CACHE{CACHE_SRTP_LIBRARIES})
janus_append_link_directories($CACHE{CACHE_SRTP_DIRECTORIES})
janus_append_link_libraries_name($CACHE{CACHE_SRTP_LIBRARY_NAME})
janus_append_include_directories($CACHE{CACHE_SRTP_INCLUDE_DIRECTORIES})
janus_append_compile_flags($CACHE{CACHE_SRTP_COMPILE_FLAGS})
janus_append_ld_flags($CACHE{CACHE_SRTP_LD_FLAGS})

# LIB_USRSCTP
if (JANUS_DATA_CHANNELS)
	include(${JANUS_3RD_PARTY_PATH}/usrsctp/usrsctp.cmake)
endif (JANUS_DATA_CHANNELS)

# LIB_LIBCURL
if (JANUS_TURN_REST_API OR JANUS_HANDLER_SAMPLE)
	include(${JANUS_3RD_PARTY_PATH}/libcurl/libcurl.cmake)

	if (DEFINED CACHE{CACHE_LIBCURL})
		if (JANUS_TURN_REST_API)
			janus_append_compile_definitions(HAVE_TURNRESTAPI)

			janus_append_link_libraries($CACHE{CACHE_LIBCURL_LIBRARIES})
			janus_append_link_directories($CACHE{CACHE_LIBCURL_DIRECTORIES})
			janus_append_link_libraries_name($CACHE{CACHE_LIBCURL_LIBRARY_NAME})
			janus_append_include_directories($CACHE{CACHE_LIBCURL_INCLUDE_DIRECTORIES})
			janus_append_compile_flags($CACHE{CACHE_LIBCURL_COMPILE_FLAGS})
			janus_append_ld_flags($CACHE{CACHE_LIBCURL_LD_FLAGS})
		endif (JANUS_TURN_REST_API)

		if (JANUS_HANDLER_SAMPLE)
			janus_append_compile_definitions(HAVE_SAMPLEEVH)

			set(janus_sampleevh_ld_flags $CACHE{CACHE_LIBCURL_LD_FLAGS} $CACHE{CACHE_GIO_LD_FLAGS} "-lm")

			janus_append_extra_libraries(
					# name
					janus_sampleevh
					# source
					"${JANUS_SOURCE_FILES_PATH}/events/janus_sampleevh.c"
					# dest_path
					"${JANUS_INSTALL_EVENT_DIR}"
					# config_path
					"${JANUS_CONF_FILES_PATH}/janus.eventhandler.sampleevh.jcfg.sample"

					# link_libraries
					"$CACHE{CACHE_LIBCURL_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
					# link_directories
					"$CACHE{CACHE_LIBCURL_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
					# include_directories
					"$CACHE{CACHE_LIBCURL_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
					# compile_flags
					"$CACHE{CACHE_LIBCURL_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
					# ld_flags
					"${janus_sampleevh_ld_flags}"
			)
		endif (JANUS_HANDLER_SAMPLE)
	endif (DEFINED CACHE{CACHE_LIBCURL})
endif (JANUS_TURN_REST_API OR JANUS_HANDLER_SAMPLE)

# DOXYGEN AND DOT
if (JANUS_DOC)
	find_program(DOXYGEN_EXE NAMES doxygen)
	find_program(DOT_EXE NAMES dot)

	if (DOXYGEN_EXE-NOTFOUND AND DOT_EXE-NOTFOUND)
		message(FATAL_ERROR "doxygen or dot not found. See README.md for installation instructions or set JANUS_DOC off")
	endif (DOXYGEN_EXE-NOTFOUND AND DOT_EXE-NOTFOUND)

	# TODO: check doxygen version here...
endif (JANUS_DOC)

# LIB_LIBMICROHTTPD
if (JANUS_TRANSPORT_REST OR JANUS_TRANSPORT_REST_TRY_USE)
	include(${JANUS_3RD_PARTY_PATH}/libmicrohttpd/libmicrohttpd.cmake)

	if (DEFINED CACHE{CACHE_LIBMICROHTTPD})
		# TODO: Maybe we can just cache the version?
		string(REPLACE "libmicrohttpd-" "" mhd_version $CACHE{CACHE_LIBMICROHTTPD_LIBRARY_NAME})

		if (${mhd_version} VERSION_GREATER_EQUAL "0.9.71")
			set(janus_http_hmd_compile_flags $CACHE{CACHE_LIBMICROHTTPD_COMPILE_FLAGS};-DHAVE_ENUM_MHD_RESULT)
		else ()
			set(janus_http_hmd_compile_flags $CACHE{CACHE_LIBMICROHTTPD_COMPILE_FLAGS})
		endif (${mhd_version} VERSION_GREATER_EQUAL "0.9.71")

		janus_append_extra_libraries(
				# name
				janus_http
				# source
				"${JANUS_SOURCE_FILES_PATH}/transports/janus_http.c"
				# dest_path
				"${JANUS_INSTALL_TRANSPORT_DIR}"
				# config_path
				"${JANUS_CONF_FILES_PATH}/janus.transport.http.jcfg.sample"

				# link_libraries
				"$CACHE{CACHE_LIBMICROHTTPD_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
				# link_directories
				"$CACHE{CACHE_LIBMICROHTTPD_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
				# include_directories
				"$CACHE{CACHE_LIBMICROHTTPD_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
				# compile_flags
				"${janus_http_hmd_compile_flags};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
				# ld_flags
				"$CACHE{CACHE_LIBMICROHTTPD_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
		)
	endif (DEFINED CACHE{CACHE_LIBMICROHTTPD})
endif (JANUS_TRANSPORT_REST OR JANUS_TRANSPORT_REST_TRY_USE)

# LIB_LIBWEBSOCKETS
if (JANUS_TRANSPORT_WEBSOCKETS OR JANUS_HANDLER_WEBSOCKETS)
	include(${JANUS_3RD_PARTY_PATH}/libwebsockets/libwebsockets.cmake)

	if (DEFINED CACHE{CACHE_LIBWEBSCOKETS})
		if (JANUS_TRANSPORT_WEBSOCKETS)
			janus_append_extra_libraries(
					# name
					janus_websockets
					# source
					"${JANUS_SOURCE_FILES_PATH}/transports/janus_websockets.c"
					# dest_path
					"${JANUS_INSTALL_TRANSPORT_DIR}"
					# config_path
					"${JANUS_CONF_FILES_PATH}/janus.transport.websockets.jcfg.sample"

					# link_libraries
					"$CACHE{CACHE_LIBWEBSCOKETS_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
					# link_directories
					"$CACHE{CACHE_LIBWEBSCOKETS_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
					# include_directories
					"$CACHE{CACHE_LIBWEBSCOKETS_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
					# compile_flags
					"$CACHE{CACHE_LIBWEBSCOKETS_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
					# ld_flags
					"$CACHE{CACHE_LIBWEBSCOKETS_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
			)
		endif (JANUS_TRANSPORT_WEBSOCKETS)

		if (JANUS_HANDLER_WEBSOCKETS)
			janus_append_extra_libraries(
					# name
					janus_wsevh
					# source
					"${JANUS_SOURCE_FILES_PATH}/events/janus_wsevh.c"
					# dest_path
					"${JANUS_INSTALL_EVENT_DIR}"
					# config_path
					"${JANUS_CONF_FILES_PATH}/janus.eventhandler.wsevh.jcfg.sample"

					# link_libraries
					"$CACHE{CACHE_LIBWEBSCOKETS_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
					# link_directories
					"$CACHE{CACHE_LIBWEBSCOKETS_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
					# include_directories
					"$CACHE{CACHE_LIBWEBSCOKETS_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
					# compile_flags
					"$CACHE{CACHE_LIBWEBSCOKETS_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
					# ld_flags
					"$CACHE{CACHE_LIBWEBSCOKETS_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
			)
		endif (JANUS_HANDLER_WEBSOCKETS)
	endif (DEFINED CACHE{CACHE_LIBWEBSCOKETS})
endif (JANUS_TRANSPORT_WEBSOCKETS OR JANUS_HANDLER_WEBSOCKETS)

# LIB_LIBRABBITMQ
if (JANUS_TRANSPORT_RABBITMQ OR JANUS_HANDLER_RABBITMQ)
	include(${JANUS_3RD_PARTY_PATH}/librabbitmq/librabbitmq.cmake)

	if (DEFINED CACHE{CACHE_LIBRABBITMQ})
		# TODO: Maybe we can just cache the version?
		string(REPLACE "librabbitmq-" "" rabbitmq_version $CACHE{CACHE_LIBRABBITMQ_LIBRARY_NAME})

		if (${rabbitmq_version} VERSION_GREATER_EQUAL "0.12.0")
			set(janus_rabbitmq_rabbitmq_compile_flags $CACHE{CACHE_LIBRABBITMQ_COMPILE_FLAGS};-DHAVE_RABBITMQ_C_AMQP_H)
		else ()
			set(janus_rabbitmq_rabbitmq_compile_flags $CACHE{CACHE_LIBRABBITMQ_COMPILE_FLAGS})
		endif (${rabbitmq_version} VERSION_GREATER_EQUAL "0.12.0")

		if (JANUS_TRANSPORT_RABBITMQ)
			janus_append_extra_libraries(
					# name
					janus_rabbitmq
					# source
					"${JANUS_SOURCE_FILES_PATH}/transports/janus_rabbitmq.c"
					# dest_path
					"${JANUS_INSTALL_TRANSPORT_DIR}"
					# config_path
					"${JANUS_CONF_FILES_PATH}/janus.transport.rabbitmq.jcfg.sample"

					# link_libraries
					"$CACHE{CACHE_LIBRABBITMQ_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
					# link_directories
					"$CACHE{CACHE_LIBRABBITMQ_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
					# include_directories
					"$CACHE{CACHE_LIBRABBITMQ_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
					# compile_flags
					"${janus_rabbitmq_rabbitmq_compile_flags};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
					# ld_flags
					"$CACHE{CACHE_LIBRABBITMQ_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
			)
		endif (JANUS_TRANSPORT_RABBITMQ)

		if (JANUS_HANDLER_RABBITMQ)
			janus_append_extra_libraries(
					# name
					janus_rabbitmqevh
					# source
					"${JANUS_SOURCE_FILES_PATH}/events/janus_rabbitmqevh.c"
					# dest_path
					"${JANUS_INSTALL_EVENT_DIR}"
					# config_path
					"${JANUS_CONF_FILES_PATH}/janus.eventhandler.rabbitmqevh.jcfg.sample"

					# link_libraries
					"$CACHE{CACHE_LIBRABBITMQ_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
					# link_directories
					"$CACHE{CACHE_LIBRABBITMQ_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
					# include_directories
					"$CACHE{CACHE_LIBRABBITMQ_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
					# compile_flags
					"${janus_rabbitmq_rabbitmq_compile_flags};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
					# ld_flags
					"$CACHE{CACHE_LIBRABBITMQ_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
			)
		endif (JANUS_HANDLER_RABBITMQ)
	endif (DEFINED CACHE{CACHE_LIBRABBITMQ})
endif (JANUS_TRANSPORT_RABBITMQ OR JANUS_HANDLER_RABBITMQ)

# LIB_LIBPAHO-MQTT3AS
if (JANUS_TRANSPORT_MQTT OR JANUS_HANDLER_MQTT)
	include(${JANUS_3RD_PARTY_PATH}/libpaho-mqtt3as/libpaho-mqtt3as.cmake)

	if (DEFINED CACHE{CACHE_PAHO-MQTT3AS})
		if (JANUS_TRANSPORT_MQTT)
			janus_append_extra_libraries(
					# name
					janus_mqtt
					# source
					"${JANUS_SOURCE_FILES_PATH}/transports/janus_mqtt.c"
					# dest_path
					"${JANUS_INSTALL_TRANSPORT_DIR}"
					# config_path
					"${JANUS_CONF_FILES_PATH}/janus.transport.mqtt.jcfg.sample"

					# link_libraries
					"$CACHE{CACHE_PAHO-MQTT3AS_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
					# link_directories
					"$CACHE{CACHE_PAHO-MQTT3AS_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
					# include_directories
					"$CACHE{CACHE_PAHO-MQTT3AS_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
					# compile_flags
					"$CACHE{CACHE_PAHO-MQTT3AS_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
					# ld_flags
					"$CACHE{CACHE_PAHO-MQTT3AS_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
			)
		endif (JANUS_TRANSPORT_MQTT)

		if (JANUS_HANDLER_MQTT)
			janus_append_extra_libraries(
					# name
					janus_mqttevh
					# source
					"${JANUS_SOURCE_FILES_PATH}/events/janus_mqttevh.c"
					# dest_path
					"${JANUS_INSTALL_EVENT_DIR}"
					# config_path
					"${JANUS_CONF_FILES_PATH}/janus.eventhandler.mqttevh.jcfg.sample"

					# link_libraries
					"$CACHE{CACHE_PAHO-MQTT3AS_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
					# link_directories
					"$CACHE{CACHE_PAHO-MQTT3AS_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
					# include_directories
					"$CACHE{CACHE_PAHO-MQTT3AS_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
					# compile_flags
					"$CACHE{CACHE_PAHO-MQTT3AS_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
					# ld_flags
					"$CACHE{CACHE_PAHO-MQTT3AS_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
			)
		endif (JANUS_HANDLER_MQTT)
	endif (DEFINED CACHE{CACHE_PAHO-MQTT3AS})
endif (JANUS_TRANSPORT_MQTT OR JANUS_HANDLER_MQTT)

# LIB_NANOMSG
if (JANUS_TRANSPORT_NANOMSG OR JANUS_HANDLER_NANOMSG)
	include(${JANUS_3RD_PARTY_PATH}/nanomsg/nanomsg.cmake)

	if (DEFINED CACHE{CACHE_NANOMSG})
		if (JANUS_TRANSPORT_NANOMSG)
			janus_append_extra_libraries(
					# name
					janus_nanomsg
					# source
					"${JANUS_SOURCE_FILES_PATH}/transports/janus_nanomsg.c"
					# dest_path
					"${JANUS_INSTALL_TRANSPORT_DIR}"
					# config_path
					"${JANUS_CONF_FILES_PATH}/janus.transport.nanomsg.jcfg.sample"

					# link_libraries
					"$CACHE{CACHE_NANOMSG_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
					# link_directories
					"$CACHE{CACHE_NANOMSG_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
					# include_directories
					"$CACHE{CACHE_NANOMSG_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
					# compile_flags
					"$CACHE{CACHE_NANOMSG_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
					# ld_flags
					"$CACHE{CACHE_NANOMSG_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
			)
		endif (JANUS_TRANSPORT_NANOMSG)

		if (JANUS_HANDLER_NANOMSG)
			janus_append_extra_libraries(
					# name
					janus_nanomsgevh
					# source
					"${JANUS_SOURCE_FILES_PATH}/events/janus_nanomsgevh.c"
					# dest_path
					"${JANUS_INSTALL_EVENT_DIR}"
					# config_path
					"${JANUS_CONF_FILES_PATH}/janus.eventhandler.nanomsgevh.jcfg.sample"

					# link_libraries
					"$CACHE{CACHE_NANOMSG_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
					# link_directories
					"$CACHE{CACHE_NANOMSG_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
					# include_directories
					"$CACHE{CACHE_NANOMSG_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
					# compile_flags
					"$CACHE{CACHE_NANOMSG_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
					# ld_flags
					"$CACHE{CACHE_NANOMSG_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
			)
		endif (JANUS_HANDLER_NANOMSG)
	endif (DEFINED CACHE{CACHE_NANOMSG})
endif (JANUS_TRANSPORT_NANOMSG OR JANUS_HANDLER_NANOMSG)

# GELF
if (JANUS_HANDLER_GELF)
	janus_append_extra_libraries(
			# name
			janus_gelfevh
			# source
			"${JANUS_SOURCE_FILES_PATH}/events/janus_gelfevh.c"
			# dest_path
			"${JANUS_INSTALL_EVENT_DIR}"
			# config_path
			"${JANUS_CONF_FILES_PATH}/janus.eventhandler.gelfevh.jcfg.sample"

			# link_libraries
			"$CACHE{CACHE_GIO_LIBRARIES}"
			# link_directories
			"$CACHE{CACHE_GIO_DIRECTORIES}"
			# include_directories
			"$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
			# compile_flags
			"$CACHE{CACHE_GIO_COMPILE_FLAGS}"
			# ld_flags
			"$CACHE{CACHE_GIO_LD_FLAGS}"
	)
endif (JANUS_HANDLER_GELF)

# JSON LOGGER
if (JANUS_LOGGER_JSON)
	janus_append_extra_libraries(
			# name
			janus_jsonlog
			# source
			"${JANUS_SOURCE_FILES_PATH}/loggers/janus_jsonlog.c"
			# dest_path
			"${JANUS_INSTALL_LOGGER_DIR}"
			# config_path
			"${JANUS_CONF_FILES_PATH}/janus.logger.jsonlog.jcfg.sample"

			# link_libraries
			"$CACHE{CACHE_GIO_LIBRARIES}"
			# link_directories
			"$CACHE{CACHE_GIO_DIRECTORIES}"
			# include_directories
			"$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
			# compile_flags
			"$CACHE{CACHE_GIO_COMPILE_FLAGS}"
			# ld_flags
			"$CACHE{CACHE_GIO_LD_FLAGS}"
	)
endif (JANUS_LOGGER_JSON)

# JANUS_TRANSPORT_UNIX_SOCKETS
function(janus_check_unix_sockets)
	if (JANUS_TRANSPORT_UNIX_SOCKETS)
		include(CheckCSourceCompiles)

		check_c_source_compiles(
				"
			#include <stdlib.h>
               #include <sys/socket.h>
               #include <sys/un.h>
               void main() {
                 int pfd = socket(PF_UNIX, SOCK_SEQPACKET | SOCK_NONBLOCK, 0);
                 if(pfd < 0)
                   exit(1);
               }
			"

				has_unix_sockets
		)

		if (NOT ${has_unix_sockets})
			message(FATAL_ERROR "SOCK_SEQPACKET not defined in your OS. Set JANUS_TRANSPORT_UNIX_SOCKETS off")
		else ()
			# This macro definition doesn't seem to do anything?
			janus_append_compile_definitions(HAVE_PFUNIX)

			# LIB_LIBSYSTEMD
			if (JANUS_SYSTEMD_SOCKETS)
				include(${JANUS_3RD_PARTY_PATH}/libsystemd/libsystemd.cmake)

				set(janus_pfunix_systemd_libraries "$CACHE{CACHE_LIBSYSTEMD_LIBRARIES}")
				set(janus_pfunix_systemd_directories "$CACHE{CACHE_LIBSYSTEMD_DIRECTORIES}")
				set(janus_pfunix_systemd_include_directories "$CACHE{CACHE_LIBSYSTEMD_INCLUDE_DIRECTORIES}")
				set(janus_pfunix_systemd_compile_flags "$CACHE{CACHE_LIBSYSTEMD_COMPILE_FLAGS};-DHAVE_LIBSYSTEMD")
				set(janus_pfunix_systemd_ld_flags "$CACHE{CACHE_LIBSYSTEMD_LD_FLAGS}")
			else ()
				set(janus_pfunix_systemd_libraries "")
				set(janus_pfunix_systemd_directories "")
				set(janus_pfunix_systemd_include_directories "")
				set(janus_pfunix_systemd_compile_flags "")
				set(janus_pfunix_systemd_ld_flags "")
			endif (JANUS_SYSTEMD_SOCKETS)

			janus_append_extra_libraries(
					# name
					janus_pfunix
					# source
					"${JANUS_SOURCE_FILES_PATH}/transports/janus_pfunix.c"
					# dest_path
					"${JANUS_INSTALL_TRANSPORT_DIR}"
					# config_path
					"${JANUS_CONF_FILES_PATH}/janus.transport.pfunix.jcfg.sample"

					# link_libraries
					"${janus_pfunix_systemd_libraries};$CACHE{CACHE_GIO_LIBRARIES}"
					# link_directories
					"${janus_pfunix_systemd_directories};$CACHE{CACHE_GIO_DIRECTORIES}"
					# include_directories
					"${janus_pfunix_systemd_include_directories};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
					# compile_flags
					"${janus_pfunix_systemd_compile_flags};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
					# ld_flags
					"${janus_pfunix_systemd_ld_flags};$CACHE{CACHE_GIO_LD_FLAGS}"
			)
		endif (NOT ${has_unix_sockets})
	endif (JANUS_TRANSPORT_UNIX_SOCKETS)
endfunction(janus_check_unix_sockets)
janus_check_unix_sockets()

# TODO: ogg support is optional, but if we support ogg, other plugins can also use ogg, which requires us to check in advance.
# LIB_OGG
if (JANUS_PLUGIN_VOICE_MAIL OR JANUS_PLUGIN_VOICE_MAIL_TRY_USE)
	include(${JANUS_3RD_PARTY_PATH}/ogg/ogg.cmake)
endif (JANUS_PLUGIN_VOICE_MAIL OR JANUS_PLUGIN_VOICE_MAIL_TRY_USE)

# LIB_OPUS
if (JANUS_PLUGIN_AUDIO_BRIDGE OR JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE)
	include(${JANUS_3RD_PARTY_PATH}/opus/opus.cmake)

	if (DEFINED CACHE{CACHE_OGG})
		set(janus_audiobridge_ogg_libraries "$CACHE{CACHE_OGG_LIBRARIES}")
		set(janus_audiobridge_ogg_directories "$CACHE{CACHE_OGG_DIRECTORIES}")
		set(janus_audiobridge_ogg_include_directories "$CACHE{CACHE_OGG_INCLUDE_DIRECTORIES}")
		set(janus_audiobridge_ogg_compile_flags "$CACHE{CACHE_OGG_COMPILE_FLAGS};-DHAVE_LIBOGG")
		set(janus_audiobridge_ogg_ld_flags "$CACHE{CACHE_OGG_LD_FLAGS}")
	else ()
		set(janus_audiobridge_ogg_libraries "")
		set(janus_audiobridge_ogg_directories "")
		set(janus_audiobridge_ogg_include_directories "")
		set(janus_audiobridge_ogg_compile_flags "")
		set(janus_audiobridge_ogg_ld_flags "")
	endif (DEFINED CACHE{CACHE_OGG})

	if (DEFINED CACHE{CACHE_OPUS})
		janus_append_extra_libraries(
				# name
				janus_audiobridge
				# source
				"${JANUS_SOURCE_FILES_PATH}/plugins/janus_audiobridge.c"
				# dest_path
				"${JANUS_INSTALL_PLUGIN_DIR}"
				# config_path
				"${JANUS_CONF_FILES_PATH}/janus.plugin.audiobridge.jcfg.sample"

				# link_libraries
				"$CACHE{CACHE_OPUS_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES};$CACHE{CACHE_SRTP_LIBRARIES};${janus_audiobridge_ogg_libraries}"
				# link_directories
				"$CACHE{CACHE_OPUS_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES};$CACHE{CACHE_SRTP_DIRECTORIES};${janus_audiobridge_ogg_directories}"
				# include_directories
				"$CACHE{CACHE_OPUS_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES};$CACHE{CACHE_SRTP_INCLUDE_DIRECTORIES};${janus_audiobridge_ogg_include_directories}"
				# compile_flags
				"$CACHE{CACHE_OPUS_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS};$CACHE{CACHE_SRTP_COMPILE_FLAGS};${janus_audiobridge_ogg_compile_flags}"
				# ld_flags
				"$CACHE{CACHE_OPUS_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS};$CACHE{CACHE_SRTP_LD_FLAGS};${janus_audiobridge_ogg_ld_flags}"
		)
	endif (DEFINED CACHE{CACHE_OPUS})
endif (JANUS_PLUGIN_AUDIO_BRIDGE OR JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE)

# LIB_DUKTAPE
# TODO: need .pc file
if (JANUS_PLUGIN_DUKTAPE OR JANUS_PLUGIN_DUKTAPE_TRY_USE)
	message(WARNING "FIXME DUKTAPE")

	#janus_append_extra_source_file(
	#		${JANUS_SOURCE_FILES_PATH}/plugins/janus_duktape.c
	#		${JANUS_SOURCE_FILES_PATH}/plugins/janus_duktape_extra.c
	#		${JANUS_SOURCE_FILES_PATH}/plugins/duktape-deps/duk_module_duktape.c
	#		${JANUS_SOURCE_FILES_PATH}/plugins/duktape-deps/duk_console.c

	#		${JANUS_HEADER_FILES_PATH}plugins/janus_duktape_data.h
	#		${JANUS_HEADER_FILES_PATH}plugins/janus_duktape_extra.h
	#		${JANUS_HEADER_FILES_PATH}plugins/duktape-deps/duk_module_duktape.h
	#		${JANUS_HEADER_FILES_PATH}plugins/duktape-deps/duk_console.h
	#)
	#janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.duktape.jcfg.sample)
endif (JANUS_PLUGIN_DUKTAPE OR JANUS_PLUGIN_DUKTAPE_TRY_USE)

if (JANUS_PLUGIN_RECORD_PLAY)
	janus_append_extra_libraries(
			# name
			janus_recordplay
			# source
			"${JANUS_SOURCE_FILES_PATH}/plugins/janus_recordplay.c"
			# dest_path
			"${JANUS_INSTALL_PLUGIN_DIR}"
			# config_path
			"${JANUS_CONF_FILES_PATH}/janus.plugin.recordplay.jcfg.sample"

			# link_libraries
			"$CACHE{CACHE_GIO_LIBRARIES}"
			# link_directories
			"$CACHE{CACHE_GIO_DIRECTORIES}"
			# include_directories
			"$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
			# compile_flags
			"$CACHE{CACHE_GIO_COMPILE_FLAGS}"
			# ld_flags
			"$CACHE{CACHE_GIO_LD_FLAGS}"
	)

	# copy data files
	set(
			janus_recordplay_data_files
			${JANUS_SOURCE_FILES_PATH}/plugins/recordings/1234.nfo
			${JANUS_SOURCE_FILES_PATH}/plugins/recordings/rec-sample-audio.mjr
			${JANUS_SOURCE_FILES_PATH}/plugins/recordings/rec-sample-video.mjr
	)
	foreach (file IN LISTS janus_recordplay_data_files)
		file(RELATIVE_PATH filename ${JANUS_SOURCE_FILES_PATH}/plugins/recordings ${file})

		configure_file(
				${file}
				${JANUS_INSTALL_RECORDING_DIR}/${filename}
				COPYONLY
		)
	endforeach (file IN LISTS janus_recordplay_data_files)
endif (JANUS_PLUGIN_RECORD_PLAY)

# LIB_LUA
if (JANUS_PLUGIN_LUA OR JANUS_PLUGIN_LUA_TRY_USE)
	include(${JANUS_3RD_PARTY_PATH}/lua/lua.cmake)

	if (DEFINED CACHE{CACHE_LUA})
		set(
				janus_pfunix_source
				${JANUS_SOURCE_FILES_PATH}/plugins/janus_lua.c
				${JANUS_SOURCE_FILES_PATH}/plugins/janus_lua_extra.c

				${JANUS_HEADER_FILES_PATH}/plugins/janus_lua_data.h
				${JANUS_HEADER_FILES_PATH}/plugins/janus_lua_extra.h
		)
		janus_append_extra_libraries(
				# name
				janus_lua
				# source
				"${janus_pfunix_source}"
				# dest_path
				"${JANUS_INSTALL_PLUGIN_DIR}"
				# config_path
				"${JANUS_CONF_FILES_PATH}/janus.plugin.lua.jcfg.sample"

				# link_libraries
				"$CACHE{CACHE_LUA_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
				# link_directories
				"$CACHE{CACHE_LUA_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
				# include_directories
				"$CACHE{CACHE_LUA_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
				# compile_flags
				"$CACHE{CACHE_LUA_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
				# ld_flags
				"$CACHE{CACHE_LUA_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
		)

		# copy data files
		set(
				janus_lua_data_files
				${JANUS_SOURCE_FILES_PATH}/plugins/lua/echotest.lua
				${JANUS_SOURCE_FILES_PATH}/plugins/lua/videoroom.lua
				${JANUS_SOURCE_FILES_PATH}/plugins/lua/janus-logger.lua
				${JANUS_SOURCE_FILES_PATH}/plugins/lua/janus-sdp.lua
		)
		foreach (file IN LISTS janus_lua_data_files)
			file(RELATIVE_PATH filename ${JANUS_SOURCE_FILES_PATH}/plugins/lua ${file})

			configure_file(
					${file}
					${JANUS_INSTALL_LUA_DIR}/${filename}
					COPYONLY
			)
		endforeach (file IN LISTS janus_lua_data_files)
	endif (DEFINED CACHE{CACHE_LUA})
endif (JANUS_PLUGIN_LUA OR JANUS_PLUGIN_LUA_TRY_USE)

if (JANUS_PLUGIN_ECHO_TEST)
	janus_append_extra_libraries(
			# name
			janus_echotest
			# source
			"${JANUS_SOURCE_FILES_PATH}/plugins/janus_echotest.c"
			# dest_path
			"${JANUS_INSTALL_PLUGIN_DIR}"
			# config_path
			"${JANUS_CONF_FILES_PATH}/janus.plugin.echotest.jcfg.sample"

			# link_libraries
			"$CACHE{CACHE_GIO_LIBRARIES}"
			# link_directories
			"$CACHE{CACHE_GIO_DIRECTORIES}"
			# include_directories
			"$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
			# compile_flags
			"$CACHE{CACHE_GIO_COMPILE_FLAGS}"
			# ld_flags
			"$CACHE{CACHE_GIO_LD_FLAGS}"
	)
endif (JANUS_PLUGIN_ECHO_TEST)

# LIB_SOFIA-SIP-UA
if (JANUS_PLUGIN_SIP OR JANUS_PLUGIN_SIP_TRY_USE)
	include(${JANUS_3RD_PARTY_PATH}/sofia-sip-ua/sofia-sip-ua.cmake)

	if (DEFINED CACHE{CACHE_SOFIA_SIP_UA})
		janus_append_extra_libraries(
				# name
				janus_sip
				# source
				"${JANUS_SOURCE_FILES_PATH}/plugins/janus_sip.c"
				# dest_path
				"${JANUS_INSTALL_PLUGIN_DIR}"
				# config_path
				"${JANUS_CONF_FILES_PATH}/janus.plugin.sip.jcfg.sample"

				# link_libraries
				"$CACHE{CACHE_SOFIA_SIP_UA_LIBRARIES};$CACHE{CACHE_SRTP_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
				# link_directories
				"$CACHE{CACHE_SOFIA_SIP_UA_DIRECTORIES};$CACHE{CACHE_SRTP_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
				# include_directories
				"$CACHE{CACHE_SOFIA_SIP_UA_INCLUDE_DIRECTORIES};$CACHE{CACHE_SRTP_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
				# compile_flags
				"$CACHE{CACHE_SOFIA_SIP_UA_COMPILE_FLAGS};$CACHE{CACHE_SRTP_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
				# ld_flags
				"$CACHE{CACHE_SOFIA_SIP_UA_LD_FLAGS};$CACHE{CACHE_SRTP_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
		)
	endif (DEFINED CACHE{CACHE_SOFIA_SIP_UA})
endif (JANUS_PLUGIN_SIP OR JANUS_PLUGIN_SIP_TRY_USE)

if (JANUS_PLUGIN_NO_SIP)
	janus_append_extra_libraries(
			# name
			janus_nosip
			# source
			"${JANUS_SOURCE_FILES_PATH}/plugins/janus_nosip.c"
			# dest_path
			"${JANUS_INSTALL_PLUGIN_DIR}"
			# config_path
			"${JANUS_CONF_FILES_PATH}/janus.plugin.nosip.jcfg.sample"

			# link_libraries
			"$CACHE{CACHE_SRTP_LIBRARIES}"
			# link_directories
			"$CACHE{CACHE_SRTP_DIRECTORIES}"
			# include_directories
			"$CACHE{CACHE_SRTP_INCLUDE_DIRECTORIES}"
			# compile_flags
			"$CACHE{CACHE_SRTP_COMPILE_FLAGS}"
			# ld_flags
			"$CACHE{CACHE_SRTP_LD_FLAGS}"
	)
endif (JANUS_PLUGIN_NO_SIP)

if (JANUS_PLUGIN_STREAMING)
	if (NOT DEFINED CACHE{CACHE_LIBCURL})
		include(${JANUS_3RD_PARTY_PATH}/libcurl/libcurl.cmake)
	endif (NOT DEFINED CACHE{CACHE_LIBCURL})
	if (NOT DEFINED CACHE{CACHE_OGG})
		include(${JANUS_3RD_PARTY_PATH}/ogg/ogg.cmake)
	endif (NOT DEFINED CACHE{CACHE_OGG})

	janus_append_extra_libraries(
			# name
			janus_streaming
			# source
			"${JANUS_SOURCE_FILES_PATH}/plugins/janus_streaming.c"
			# dest_path
			"${JANUS_INSTALL_PLUGIN_DIR}"
			# config_path
			"${JANUS_CONF_FILES_PATH}/janus.plugin.streaming.jcfg.sample"

			# link_libraries
			"$CACHE{CACHE_LIBCURL_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES};$CACHE{CACHE_OGG_LIBRARIES};$CACHE{CACHE_SRTP_LIBRARIES}"
			# link_directories
			"$CACHE{CACHE_LIBCURL_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES};$CACHE{CACHE_OGG_DIRECTORIES};$CACHE{CACHE_SRTP_DIRECTORIES}"
			# include_directories
			"$CACHE{CACHE_LIBCURL_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES};$CACHE{CACHE_OGG_INCLUDE_DIRECTORIES};$CACHE{CACHE_SRTP_INCLUDE_DIRECTORIES}"
			# compile_flags
			"$CACHE{CACHE_LIBCURL_COMPILE_FLAGS};-DHAVE_LIBCURL;$CACHE{CACHE_GIO_COMPILE_FLAGS};$CACHE{CACHE_OGG_COMPILE_FLAGS};-DHAVE_LIBOGG;$CACHE{CACHE_SRTP_COMPILE_FLAGS}"
			# ld_flags
			"$CACHE{CACHE_LIBCURL_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS};$CACHE{CACHE_OGG_LD_FLAGS};$CACHE{CACHE_SRTP_LD_FLAGS}"
	)

	# copy data files
	set(
			janus_streaming_data_files
			${JANUS_SOURCE_FILES_PATH}/plugins/streams/music.mulaw
			${JANUS_SOURCE_FILES_PATH}/plugins/streams/radio.alaw
			${JANUS_SOURCE_FILES_PATH}/plugins/streams/test_gstreamer.sh
			${JANUS_SOURCE_FILES_PATH}/plugins/streams/test_gstreamer1.sh
			${JANUS_SOURCE_FILES_PATH}/plugins/streams/test_gstreamer_multistream.sh
			${JANUS_SOURCE_FILES_PATH}/plugins/streams/test_gstreamer1_multistream.sh
	)
	foreach (file IN LISTS janus_streaming_data_files)
		file(RELATIVE_PATH filename ${JANUS_SOURCE_FILES_PATH}/plugins/streams ${file})

		configure_file(
				${file}
				${JANUS_INSTALL_STREAM_DIR}/${filename}
				COPYONLY
		)
	endforeach (file IN LISTS janus_streaming_data_files)
endif (JANUS_PLUGIN_STREAMING)

if (JANUS_PLUGIN_TEXT_ROOM)
	janus_append_extra_libraries(
			# name
			janus_textroom
			# source
			"${JANUS_SOURCE_FILES_PATH}/plugins/janus_textroom.c"
			# dest_path
			"${JANUS_INSTALL_PLUGIN_DIR}"
			# config_path
			"${JANUS_CONF_FILES_PATH}/janus.plugin.textroom.jcfg.sample"

			# link_libraries
			"$CACHE{CACHE_GIO_LIBRARIES}"
			# link_directories
			"$CACHE{CACHE_GIO_DIRECTORIES}"
			# include_directories
			"$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
			# compile_flags
			"$CACHE{CACHE_GIO_COMPILE_FLAGS}"
			# ld_flags
			"$CACHE{CACHE_GIO_LD_FLAGS}"
	)
endif (JANUS_PLUGIN_TEXT_ROOM)

if (JANUS_PLUGIN_VIDEO_CALL)
	janus_append_extra_libraries(
			# name
			janus_videocall
			# source
			"${JANUS_SOURCE_FILES_PATH}/plugins/janus_videocall.c"
			# dest_path
			"${JANUS_INSTALL_PLUGIN_DIR}"
			# config_path
			"${JANUS_CONF_FILES_PATH}/janus.plugin.videocall.jcfg.sample"

			# link_libraries
			"$CACHE{CACHE_GIO_LIBRARIES}"
			# link_directories
			"$CACHE{CACHE_GIO_DIRECTORIES}"
			# include_directories
			"$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
			# compile_flags
			"$CACHE{CACHE_GIO_COMPILE_FLAGS}"
			# ld_flags
			"$CACHE{CACHE_GIO_LD_FLAGS}"
	)
endif (JANUS_PLUGIN_VIDEO_CALL)

if (JANUS_PLUGIN_VIDEO_ROOM)
	janus_append_extra_libraries(
			# name
			janus_videoroom
			# source
			"${JANUS_SOURCE_FILES_PATH}/plugins/janus_videoroom.c"
			# dest_path
			"${JANUS_INSTALL_PLUGIN_DIR}"
			# config_path
			"${JANUS_CONF_FILES_PATH}/janus.plugin.videoroom.jcfg.sample"

			# link_libraries
			"$CACHE{CACHE_SRTP_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
			# link_directories
			"$CACHE{CACHE_SRTP_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
			# include_directories
			"$CACHE{CACHE_SRTP_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
			# compile_flags
			"$CACHE{CACHE_SRTP_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
			# ld_flags
			"$CACHE{CACHE_SRTP_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
	)
endif (JANUS_PLUGIN_VIDEO_ROOM)

# LIB_OGG
if (JANUS_PLUGIN_VOICE_MAIL OR JANUS_PLUGIN_VOICE_MAIL_TRY_USE)
	if (NOT DEFINED CACHE{CACHE_OGG})
		include(${JANUS_3RD_PARTY_PATH}/ogg/ogg.cmake)
	endif (NOT DEFINED CACHE{CACHE_OGG})

	if (DEFINED CACHE{CACHE_OGG})
		janus_append_extra_libraries(
				# name
				janus_voicemail
				# source
				"${JANUS_SOURCE_FILES_PATH}/plugins/janus_voicemail.c"
				# dest_path
				"${JANUS_INSTALL_PLUGIN_DIR}"
				# config_path
				"${JANUS_CONF_FILES_PATH}/janus.plugin.voicemail.jcfg.sample"

				# link_libraries
				"$CACHE{CACHE_OGG_LIBRARIES};$CACHE{CACHE_GIO_LIBRARIES}"
				# link_directories
				"$CACHE{CACHE_OGG_DIRECTORIES};$CACHE{CACHE_GIO_DIRECTORIES}"
				# include_directories
				"$CACHE{CACHE_OGG_INCLUDE_DIRECTORIES};$CACHE{CACHE_GIO_INCLUDE_DIRECTORIES}"
				# compile_flags
				"$CACHE{CACHE_OGG_COMPILE_FLAGS};$CACHE{CACHE_GIO_COMPILE_FLAGS}"
				# ld_flags
				"$CACHE{CACHE_OGG_LD_FLAGS};$CACHE{CACHE_GIO_LD_FLAGS}"
		)
	endif (DEFINED CACHE{CACHE_OGG})
endif (JANUS_PLUGIN_VOICE_MAIL OR JANUS_PLUGIN_VOICE_MAIL_TRY_USE)

# JS MODULE
if (JANUS_JS_MODULE_ES OR JANUS_JS_MODULE_UMD OR JANUS_JS_MODULE_IIFE OR JANUS_JS_MODULE_COMMON)
	find_program(NPM_EXE NAMES npm)

	if (NPM_EXE-NOTFOUND)
		message(FATAL_ERROR "npm not found.")
	endif (NPM_EXE-NOTFOUND)

	# TODO: check doxygen version here...
endif (JANUS_JS_MODULE_ES OR JANUS_JS_MODULE_UMD OR JANUS_JS_MODULE_IIFE OR JANUS_JS_MODULE_COMMON)

# Post-processing
if (JANUS_POST_PROCESSING)
	# include(${JANUS_3RD_PARTY_PATH}/jansson/jansson.cmake)
	# include(${JANUS_3RD_PARTY_PATH}/libssl/libssl.cmake)
	# include(${JANUS_3RD_PARTY_PATH}/libcrypto/libcrypto.cmake)
	# include(${JANUS_3RD_PARTY_PATH}/zlib/zlib.cmake)
	# include(${JANUS_3RD_PARTY_PATH}/ogg/ogg.cmake)

	include(${JANUS_3RD_PARTY_PATH}/libav/libavutil.cmake)
	include(${JANUS_3RD_PARTY_PATH}/libav/libavcodec.cmake)
	include(${JANUS_3RD_PARTY_PATH}/libav/libavformat.cmake)
endif (JANUS_POST_PROCESSING)

# LIB_LIBPCAP
set(JANUS_ENABLE_PCAP2MJR OFF)
function(janus_check_libpcap)
	pkg_check_modules(LIB_LIBPCAP QUIET libpcap)

	if (${LIB_LIBPCAP_FOUND})
		janus_append_compile_definitions(HAVE_LIBPCAP)
		set(JANUS_ENABLE_PCAP2MJR ON PARENT_SCOPE)
	endif (${LIB_LIBPCAP_FOUND})
endfunction(janus_check_libpcap)
janus_check_libpcap()

# TODO: janus-pp-rec and mjr2pcap


# copy config file
file(MAKE_DIRECTORY ${JANUS_INSTALL_CONFIG_DIR})
foreach (file IN LISTS JANUS_CONF_FILES JANUS_EXTRA_LIBRARIES_CONF_FILES)
	file(RELATIVE_PATH relative_conf_file "${JANUS_CONF_FILES_PATH}" "${file}")

	# xxx.sample -> xxx
	string(REPLACE ".sample" "" basename ${relative_conf_file})

	file(COPY_FILE ${file} ${JANUS_INSTALL_CONFIG_DIR}/${relative_conf_file})

	# TODO: overwritten?
	if (NOT EXISTS ${JANUS_INSTALL_CONFIG_DIR}/${basename})
		file(COPY_FILE ${file} ${JANUS_INSTALL_CONFIG_DIR}/${basename})
	endif (NOT EXISTS ${JANUS_INSTALL_CONFIG_DIR}/${basename})
endforeach (file IN LISTS JANUS_CONF_FILES JANUS_EXTRA_LIBRARIES_CONF_FILES)
