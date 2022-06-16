
set(fmt_INCLUDE_DIRS_RELEASE "/opt/.conan/data/fmt/8.1.1/_/_/package/30a9781670e6fb2f17b8355b17a15cf916045317/include")
set(fmt_INCLUDE_DIR_RELEASE "/opt/.conan/data/fmt/8.1.1/_/_/package/30a9781670e6fb2f17b8355b17a15cf916045317/include")
set(fmt_INCLUDES_RELEASE "/opt/.conan/data/fmt/8.1.1/_/_/package/30a9781670e6fb2f17b8355b17a15cf916045317/include")
set(fmt_RES_DIRS_RELEASE )
set(fmt_DEFINITIONS_RELEASE )
set(fmt_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(fmt_COMPILE_DEFINITIONS_RELEASE )
set(fmt_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(fmt_COMPILE_OPTIONS_C_RELEASE "")
set(fmt_COMPILE_OPTIONS_CXX_RELEASE "")
set(fmt_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(fmt_LIBRARIES_RELEASE "") # Will be filled later
set(fmt_LIBS_RELEASE "") # Same as fmt_LIBRARIES
set(fmt_SYSTEM_LIBS_RELEASE )
set(fmt_FRAMEWORK_DIRS_RELEASE )
set(fmt_FRAMEWORKS_RELEASE )
set(fmt_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(fmt_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(fmt_FRAMEWORKS_FOUND_RELEASE "${fmt_FRAMEWORKS_RELEASE}" "${fmt_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(fmt_INCLUDE_DIRS_RELEASE
                 fmt_INCLUDE_DIR_RELEASE
                 fmt_INCLUDES_RELEASE
                 fmt_DEFINITIONS_RELEASE
                 fmt_LINKER_FLAGS_RELEASE_LIST
                 fmt_COMPILE_DEFINITIONS_RELEASE
                 fmt_COMPILE_OPTIONS_RELEASE_LIST
                 fmt_LIBRARIES_RELEASE
                 fmt_LIBS_RELEASE
                 fmt_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to fmt_LIBS and fmt_LIBRARY_LIST
set(fmt_LIBRARY_LIST_RELEASE fmt)
set(fmt_LIB_DIRS_RELEASE "/opt/.conan/data/fmt/8.1.1/_/_/package/30a9781670e6fb2f17b8355b17a15cf916045317/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_fmt_DEPENDENCIES_RELEASE "${fmt_FRAMEWORKS_FOUND_RELEASE} ${fmt_SYSTEM_LIBS_RELEASE} ")

conan_package_library_targets("${fmt_LIBRARY_LIST_RELEASE}"  # libraries
                              "${fmt_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_fmt_DEPENDENCIES_RELEASE}"  # deps
                              fmt_LIBRARIES_RELEASE            # out_libraries
                              fmt_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "fmt")                                      # package_name

set(fmt_LIBS_RELEASE ${fmt_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${fmt_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND fmt_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND fmt_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${fmt_SYSTEM_LIBS_RELEASE})
    list(APPEND fmt_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND fmt_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(fmt_LIBRARIES_TARGETS_RELEASE "${fmt_LIBRARIES_TARGETS_RELEASE};")
set(fmt_LIBRARIES_RELEASE "${fmt_LIBRARIES_RELEASE};")

set(CMAKE_MODULE_PATH "/opt/.conan/data/fmt/8.1.1/_/_/package/30a9781670e6fb2f17b8355b17a15cf916045317/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/opt/.conan/data/fmt/8.1.1/_/_/package/30a9781670e6fb2f17b8355b17a15cf916045317/" ${CMAKE_PREFIX_PATH})
