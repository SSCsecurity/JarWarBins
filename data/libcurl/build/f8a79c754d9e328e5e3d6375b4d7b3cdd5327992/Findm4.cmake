

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAME ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAME ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findm4.cmake")
# Global approach
set(m4_FOUND 1)
set(m4_VERSION "1.4.19")

find_package_handle_standard_args(m4 REQUIRED_VARS
                                  m4_VERSION VERSION_VAR m4_VERSION)
mark_as_advanced(m4_FOUND m4_VERSION)


set(m4_INCLUDE_DIRS )
set(m4_INCLUDE_DIR "")
set(m4_INCLUDES )
set(m4_RES_DIRS )
set(m4_DEFINITIONS )
set(m4_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(m4_COMPILE_DEFINITIONS )
set(m4_COMPILE_OPTIONS_LIST "" "")
set(m4_COMPILE_OPTIONS_C "")
set(m4_COMPILE_OPTIONS_CXX "")
set(m4_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(m4_LIBRARIES "") # Will be filled later
set(m4_LIBS "") # Same as m4_LIBRARIES
set(m4_SYSTEM_LIBS )
set(m4_FRAMEWORK_DIRS )
set(m4_FRAMEWORKS )
set(m4_FRAMEWORKS_FOUND "") # Will be filled later
set(m4_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(m4_FRAMEWORKS_FOUND "${m4_FRAMEWORKS}" "${m4_FRAMEWORK_DIRS}")

mark_as_advanced(m4_INCLUDE_DIRS
                 m4_INCLUDE_DIR
                 m4_INCLUDES
                 m4_DEFINITIONS
                 m4_LINKER_FLAGS_LIST
                 m4_COMPILE_DEFINITIONS
                 m4_COMPILE_OPTIONS_LIST
                 m4_LIBRARIES
                 m4_LIBS
                 m4_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to m4_LIBS and m4_LIBRARY_LIST
set(m4_LIBRARY_LIST )
set(m4_LIB_DIRS )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_m4_DEPENDENCIES "${m4_FRAMEWORKS_FOUND} ${m4_SYSTEM_LIBS} ")

conan_package_library_targets("${m4_LIBRARY_LIST}"  # libraries
                              "${m4_LIB_DIRS}"      # package_libdir
                              "${_m4_DEPENDENCIES}"  # deps
                              m4_LIBRARIES            # out_libraries
                              m4_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "m4")                                      # package_name

set(m4_LIBS ${m4_LIBRARIES})

foreach(_FRAMEWORK ${m4_FRAMEWORKS_FOUND})
    list(APPEND m4_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND m4_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${m4_SYSTEM_LIBS})
    list(APPEND m4_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND m4_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(m4_LIBRARIES_TARGETS "${m4_LIBRARIES_TARGETS};")
set(m4_LIBRARIES "${m4_LIBRARIES};")

set(CMAKE_MODULE_PATH "/opt/.conan/data/m4/1.4.19/_/_/package/24647d9fe8ec489125dfbae4b3ebefaf7581674c/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/opt/.conan/data/m4/1.4.19/_/_/package/24647d9fe8ec489125dfbae4b3ebefaf7581674c/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET m4::m4)
        add_library(m4::m4 INTERFACE IMPORTED)
        if(m4_INCLUDE_DIRS)
            set_target_properties(m4::m4 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${m4_INCLUDE_DIRS}")
        endif()
        set_property(TARGET m4::m4 PROPERTY INTERFACE_LINK_LIBRARIES
                     "${m4_LIBRARIES_TARGETS};${m4_LINKER_FLAGS_LIST}")
        set_property(TARGET m4::m4 PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${m4_COMPILE_DEFINITIONS})
        set_property(TARGET m4::m4 PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${m4_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${m4_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
