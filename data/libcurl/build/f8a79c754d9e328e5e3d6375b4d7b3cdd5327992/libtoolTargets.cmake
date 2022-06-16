
if(NOT TARGET libtool::libtool)
    add_library(libtool::libtool INTERFACE IMPORTED)
endif()

# Load the debug and release library finders
get_filename_component(_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
file(GLOB CONFIG_FILES "${_DIR}/libtoolTarget-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()
