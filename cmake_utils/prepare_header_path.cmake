function(prepare_header_path)
	function(do_replace directory_abs_path this_file_abs_path)
		file(RELATIVE_PATH folder_name ${JANUS_SOURCE_FILES_PATH} ${directory_abs_path})

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

			# include "xxx.h" --> include <category/xxx.h>
			# note: must be in a nested folder. (and not the top-level directory `src`)
			string(REGEX MATCH "^#include[ ]*\"(.*)[.]h\"(.*)$" this_line_current_folder_matched "${line}")
			if (this_line_current_folder_matched)
				# replace
				# message("0: ${CMAKE_MATCH_0} -- 1: ${${CMAKE_MATCH_1}}")
				string(REGEX REPLACE "^#include[ ]*\"(.*)[.]h\"(.*)$" "#include <${folder_name}/\\1.h> \\2" out_line "${line}")
				# message("${line} --> ${out_line}")
				# append
				do_append(${out_line})

				continue()
			endif (this_line_current_folder_matched)

			# just append
			file(APPEND ${temp_file_path} "${line}\n")
		endforeach (line IN LISTS file_content)

		# replace file
		file(RENAME ${temp_file_path} ${this_file_abs_path})
	endfunction(do_replace directory_abs_path this_file_abs_path)

	# =============================
	# Necessary source files
	# =============================

	# plugins
	# plugin.c
	do_replace(${JANUS_SOURCE_FILES_PATH}/plugins ${JANUS_SOURCE_FILES_PATH}/plugins/plugin.c)

	# transport
	# transport.c
	do_replace(${JANUS_SOURCE_FILES_PATH}/transports ${JANUS_SOURCE_FILES_PATH}/transports/transport.c)
endfunction(prepare_header_path)

prepare_header_path()
