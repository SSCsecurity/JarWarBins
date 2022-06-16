
if(NOT TARGET m4::m4)
    add_library(m4::m4 INTERFACE IMPORTED)
endif()

# Load the debug and release library finders
get_filename_component(_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
file(GLOB CONFIG_FILES "${_DIR}/m4Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()
