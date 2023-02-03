include(${PROJECT_SOURCE_DIR}/cmake_utils/prepare_dependencies.cmake)

find_package(PkgConfig REQUIRED)

# LIB_GLIB AND LIB_GIO
include(${JANUS_3RD_PARTY_PATH}/glib/glib.cmake)
include(${JANUS_3RD_PARTY_PATH}/glib/gio.cmake)

# LIB_LIBCONFIG
include(${JANUS_3RD_PARTY_PATH}/libconfig/libconfig.cmake)

# LIB_NICE
include(${JANUS_3RD_PARTY_PATH}/nice/nice.cmake)

# LIB_JANSSON
include(${JANUS_3RD_PARTY_PATH}/jansson/jansson.cmake)

# LIB_ZLIB
include(${JANUS_3RD_PARTY_PATH}/zlib/zlib.cmake)

if (NOT JANUS_PLATFORM_IS_BSD)
	# LIB_LIBSSL
	include(${JANUS_3RD_PARTY_PATH}/libssl/libssl.cmake)
	# LIB_LIBCRYPTO
	include(${JANUS_3RD_PARTY_PATH}/libcrypto/libcrypto.cmake)
endif ()

# LIB_OPENSSL OR LIB_BORINGSSL
if (JANUS_BORINGSSL)
	message(STATUS "Trying to use BoringSSL instead of OpenSSL...")
	include(${JANUS_3RD_PARTY_PATH}/boringssl/boringssl.cmake)
else ()
	include(${JANUS_3RD_PARTY_PATH}/openssl/openssl.cmake)
endif (JANUS_BORINGSSL)

if (JANUS_DTLS_SET_TIMEOUT)
	message(STATUS "Assuming DTLSv1_set_initial_timeout_duration is available")
	janus_append_compile_definitions(HAVE_DTLS_SETTIMEOUT)
endif (JANUS_DTLS_SET_TIMEOUT)

if (JANUS_PTHREAD_MUTEX)
	message(STATUS "Will use pthread_mutex instead of GMutex")
	janus_append_compile_definitions(USE_PTHREAD_MUTEX)
endif (JANUS_PTHREAD_MUTEX)

# LIB_DL
janus_append_link_libraries(${CMAKE_DL_LIBS})
janus_append_link_libraries_name(${CMAKE_DL_LIBS})

# LIB_SRTP
include(${JANUS_3RD_PARTY_PATH}/srtp/srtp.cmake)

# LIB_USRSCTP
if (JANUS_DATA_CHANNELS)
	include(${JANUS_3RD_PARTY_PATH}/usrsctp/usrsctp.cmake)
endif (JANUS_DATA_CHANNELS)

# LIB_LIBCURL
if (JANUS_TURN_REST_API OR JANUS_HANDLER_SAMPLE)
	include(${JANUS_3RD_PARTY_PATH}/libcurl/libcurl.cmake)
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
include(${JANUS_3RD_PARTY_PATH}/libmicrohttpd/libmicrohttpd.cmake)

# LIB_LIBWEBSOCKETS
if (JANUS_TRANSPORT_WEBSOCKETS OR JANUS_HANDLER_WEBSOCKETS)
	include(${JANUS_3RD_PARTY_PATH}/libwebsockets/libwebsockets.cmake)
endif (JANUS_TRANSPORT_WEBSOCKETS OR JANUS_HANDLER_WEBSOCKETS)

# LIB_LIBRABBITMQ
if (JANUS_TRANSPORT_RABBITMQ OR JANUS_HANDLER_RABBITMQ)
	include(${JANUS_3RD_PARTY_PATH}/librabbitmq/librabbitmq.cmake)
endif (JANUS_TRANSPORT_RABBITMQ OR JANUS_HANDLER_RABBITMQ)

# LIB_PAHO-MQTT3D
# TODO: need .pc file
if (JANUS_TRANSPORT_MQTT OR JANUS_HANDLER_MQTT)
	message(WARNING "FIXME MQTT")
endif (JANUS_TRANSPORT_MQTT OR JANUS_HANDLER_MQTT)

# LIB_NANOMSG
if (JANUS_TRANSPORT_NANOMSG OR JANUS_HANDLER_NANOMSG)
	include(${JANUS_3RD_PARTY_PATH}/nanomsg/nanomsg.cmake)
endif (JANUS_TRANSPORT_NANOMSG OR JANUS_HANDLER_NANOMSG)

# JANUS_TRANSPORT_UNIX_SOCKETS
function(janus_check_unix_sockets)
	if (JANUS_TRANSPORT_UNIX_SOCKETS)
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
			janus_append_compile_definitions(HAVE_PFUNIX)
		endif (NOT ${has_unix_sockets})
	endif (JANUS_TRANSPORT_UNIX_SOCKETS)
endfunction(janus_check_unix_sockets)
janus_check_unix_sockets()

# LIB_LIBSYSTEMD
if (JANUS_SYSTEMD_SOCKETS)
	include(${JANUS_3RD_PARTY_PATH}/libsystemd/libsystemd.cmake)
endif (JANUS_SYSTEMD_SOCKETS)

# LIB_OPUS
if (JANUS_PLUGIN_AUDIO_BRIDGE OR JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE)
	include(${JANUS_3RD_PARTY_PATH}/opus/opus.cmake)
endif (JANUS_PLUGIN_AUDIO_BRIDGE OR JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE)

# LIB_DUKTAPE
# TODO: need .pc file
if (JANUS_PLUGIN_DUKTAPE OR JANUS_PLUGIN_DUKTAPE_TRY_USE)
	message(WARNING "FIXME DUKTAPE")
endif (JANUS_PLUGIN_DUKTAPE OR JANUS_PLUGIN_DUKTAPE_TRY_USE)

# LIB_LUA
if (JANUS_PLUGIN_LUA OR JANUS_PLUGIN_LUA_TRY_USE)
	include(${JANUS_3RD_PARTY_PATH}/lua/lua.cmake)
endif (JANUS_PLUGIN_LUA OR JANUS_PLUGIN_LUA_TRY_USE)

# LIB_SOFIA-SIP-UA
if (JANUS_PLUGIN_SIP OR JANUS_PLUGIN_SIP_TRY_USE)
	include(${JANUS_3RD_PARTY_PATH}/sofia-sip-ua/sofia-sip-ua.cmake)
endif (JANUS_PLUGIN_SIP OR JANUS_PLUGIN_SIP_TRY_USE)

# LIB_OGG
if (JANUS_PLUGIN_VOICE_MAIL OR JANUS_PLUGIN_VOICE_MAIL_TRY_USE)
	include(${JANUS_3RD_PARTY_PATH}/ogg/ogg.cmake)
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
	# include(${JANUS_3RD_PARTY_PATH}/glib/glib.cmake)
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
function(janus_check_libpcap)
	pkg_check_modules(LIB_LIBPCAP QUIET libpcap)

	if (${LIB_LIBPCAP_FOUND})
		janus_append_compile_definitions(HAVE_LIBPCAP)
	endif (${LIB_LIBPCAP_FOUND})
endfunction(janus_check_libpcap)
janus_check_libpcap()
