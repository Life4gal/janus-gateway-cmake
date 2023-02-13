function(prepare_header_path)
	function(do_replace this_file_abs_path)
		# .c or .h ?
		string(REGEX MATCH "^.*[.]h$" this_file_is_header_file "${this_file_abs_path}")
		if (NOT this_file_is_header_file)
			string(REGEX MATCH "^.*[.]c$" this_file_is_source_file "${this_file_abs_path}")

			if (NOT this_file_is_source_file)
				message(FATAL_ERROR "Unsupported file [${this_file_abs_path}].")
			endif (NOT this_file_is_source_file)
		endif (NOT this_file_is_header_file)

		# TODO: It looks like the headers don't need to be replaced and can be skipped.
		if (this_file_is_header_file)
			return()
		endif (this_file_is_header_file)

		message("Replacing the path of the included header file in the file [${this_file_abs_path}], this may take a while...")

		# 3.20^
		# cmake_path(GET ${this_file_abs_path} PARENT_PATH folder_name)
		# 3.20v
		get_filename_component(parent_path ${this_file_abs_path} DIRECTORY)

		if (this_file_is_header_file)
			file(RELATIVE_PATH folder_name ${JANUS_HEADER_FILES_PATH} ${parent_path})
		else ()
			file(RELATIVE_PATH folder_name ${JANUS_SOURCE_FILES_PATH} ${parent_path})
		endif (this_file_is_header_file)
		file(RELATIVE_PATH file_name ${parent_path} ${this_file_abs_path})

		set(this_file_cache_entry_name JANUS_HEADER_PATH_REPLACED_${folder_name}_${file_name})

		# force process?
		if (NOT DEFINED CACHE{JANUS_PROJECT_FILES_RECOPY_FROM_SOURCE})
			# already cached?
			if ($CACHE{${this_file_cache_entry_name}})
				return()
			endif ($CACHE{${this_file_cache_entry_name}})
		endif (NOT DEFINED CACHE{JANUS_PROJECT_FILES_RECOPY_FROM_SOURCE})

		string(LENGTH ${folder_name} folder_name_length)
		if (${folder_name_length} EQUAL 0)
			message(FATAL_ERROR "The `replace included header path` function only supports files in nested folders. (Files in top-level directories do not need to be processed)")
		endif (${folder_name_length} EQUAL 0)

		# generate temp file for write
		set(temp_file_path "${this_file_abs_path}.generated")
		file(WRITE ${temp_file_path})

		function(do_append line)
			file(APPEND ${temp_file_path} "// Modified by 'janus-gateway-cmake', !!! DO NOT EDIT !!!\n")
			file(APPEND ${temp_file_path} "${line}\n")
		endfunction(do_append line)

		# read content
		file(STRINGS ${this_file_abs_path} file_content)

		# iteration
		foreach (line IN LISTS file_content)
			# include "../xxx.h" --> include <xxx.h>
			string(REGEX MATCH "^#include[ ]*\"[.][.]/(.*)[.]h\"(.*)$" this_line_parent_folder_matched "${line}")
			if (this_line_parent_folder_matched)
				# replace
				# message("0: ${CMAKE_MATCH_0} -- 1: ${${CMAKE_MATCH_1}}")
				string(REGEX REPLACE "^#include[ ]*\"[.][.]/(.*)[.]h\"(.*)$" "#include <\\1.h> \\2" out_line "${line}")
				# message("${line} --> ${out_line}")
				# append
				do_append(${out_line})

				continue()
			endif (this_line_parent_folder_matched)

			# There are two possible cases about include "xxx.h"
			#   1. include "xxx.h" --> include <category/xxx.h>
			#   2. include "xxx.h" --> include <xxx.h> (system include path)
			string(REGEX MATCH "^#include[ ]*\"(.*)[.]h\"(.*)$" this_line_current_folder_matched "${line}")
			if (this_line_current_folder_matched)
				set(include_header_path "${JANUS_HEADER_FILES_PATH}/${folder_name}/${CMAKE_MATCH_1}.h")

				# case 1:
				#   must be in a nested folder. (and not the top-level directory `src`)
				#   target file must exists.
				if (EXISTS ${include_header_path})
					# replace
					# message("0: ${CMAKE_MATCH_0} -- 1: ${${CMAKE_MATCH_1}}")
					string(REGEX REPLACE "^#include[ ]*\"(.*)[.]h\"(.*)$" "#include <${folder_name}/\\1.h> \\2" out_line "${line}")
					# message("${line} --> ${out_line}")
					# append
					do_append(${out_line})

					continue()
				endif (EXISTS ${include_header_path})

				# case 2:
				#   just replace `""` to `<>`
				# replace
				# message("0: ${CMAKE_MATCH_0} -- 1: ${${CMAKE_MATCH_1}}")
				string(REGEX REPLACE "^#include[ ]*\"(.*)[.]h\"(.*)$" "#include <\\1.h> \\2" out_line "${line}")
				# message("${line} --> ${out_line}")
				# append
				do_append(${out_line})

				continue()
			endif (this_line_current_folder_matched)

			# note: Multi-line macro definitions will be parsed incorrectly.
			# such as:
			# #define macro_name \
			#   macro_definition_line_1 \
			#   macro_definition_line_2 \
			#   macro_definition_line_3 \
			#   ...
			# parsed as: #define macro_name ; macro_definition_line_1 ; macro_definition_line_2 ; macro_definition_line_3 ; ...
			string(REGEX MATCH "^#define .*$" this_line_macro_definition_matched "${line}")
			string(FIND "${line}" ";" this_line_macro_definition_multi_line_index)
			if (this_line_macro_definition_matched AND NOT ${this_line_macro_definition_multi_line_index} EQUAL -1)
				# note: NOT A LIST
				#foreach (macro_line ${line})
				#	message("macro_line --> ${macro_line}")
				#endforeach (macro_line ${line})

				# ';' --> '\' + '\n'
				string(REPLACE ";" "\\\n" real_macro "${line}")

				# append
				file(APPEND ${temp_file_path} "${real_macro}\n")
				continue()
			endif (this_line_macro_definition_matched AND NOT ${this_line_macro_definition_multi_line_index} EQUAL -1)

			# just append
			file(APPEND ${temp_file_path} "${line}\n")
		endforeach (line IN LISTS file_content)

		# replace file
		file(RENAME ${temp_file_path} ${this_file_abs_path})

		# !!! CACHE THIS FILE !!!
		set(${this_file_cache_entry_name} ON CACHE INTERNAL "Mark file ${this_file_abs_path} has been processed." FORCE)
	endfunction(do_replace this_file_abs_path)

	# =============================
	# Necessary source files
	# =============================

	# plugins
	# plugin.c
	do_replace(${JANUS_SOURCE_FILES_PATH}/plugins/plugin.c)

	# transport
	# transport.c
	do_replace(${JANUS_SOURCE_FILES_PATH}/transports/transport.c)

	# =============================
	# Extra source files
	# =============================
	foreach (file IN LISTS JANUS_EXTRA_SOURCE_FILES)
		do_replace(${file})
	endforeach (file IN LISTS JANUS_EXTRA_SOURCE_FILES)

	# =============================
	# Extra libraries source files
	# =============================
	foreach (file IN LISTS JANUS_EXTRA_LIBRARIES_SOURCE_FILES)
		do_replace(${file})
	endforeach (file IN LISTS JANUS_EXTRA_LIBRARIES_SOURCE_FILES)
endfunction(prepare_header_path)

prepare_header_path()
if ($CACHE{JANUS_PROJECT_FILES_RECOPY_FROM_SOURCE})
	unset(JANUS_PROJECT_FILES_RECOPY_FROM_SOURCE CACHE)
endif ($CACHE{JANUS_PROJECT_FILES_RECOPY_FROM_SOURCE})
