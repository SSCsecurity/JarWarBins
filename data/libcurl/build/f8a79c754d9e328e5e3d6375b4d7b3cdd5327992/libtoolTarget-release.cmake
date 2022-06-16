
set(libtool_INCLUDE_DIRS_RELEASE "/opt/.conan/data/libtool/2.4.6/_/_/package/7220a8d356f22477137df1a1547bcd812718c470/include")
set(libtool_INCLUDE_DIR_RELEASE "/opt/.conan/data/libtool/2.4.6/_/_/package/7220a8d356f22477137df1a1547bcd812718c470/include")
set(libtool_INCLUDES_RELEASE "/opt/.conan/data/libtool/2.4.6/_/_/package/7220a8d356f22477137df1a1547bcd812718c470/include")
set(libtool_RES_DIRS_RELEASE "/opt/.conan/data/libtool/2.4.6/_/_/package/7220a8d356f22477137df1a1547bcd812718c470/res")
set(libtool_DEFINITIONS_RELEASE )
set(libtool_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(libtool_COMPILE_DEFINITIONS_RELEASE )
set(libtool_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(libtool_COMPILE_OPTIONS_C_RELEASE "")
set(libtool_COMPILE_OPTIONS_CXX_RELEASE "")
set(libtool_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(libtool_LIBRARIES_RELEASE "") # Will be filled later
set(libtool_LIBS_RELEASE "") # Same as libtool_LIBRARIES
set(libtool_SYSTEM_LIBS_RELEASE dl)
set(libtool_FRAMEWORK_DIRS_RELEASE )
set(libtool_FRAMEWORKS_RELEASE )
set(libtool_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(libtool_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(libtool_FRAMEWORKS_FOUND_RELEASE "${libtool_FRAMEWORKS_RELEASE}" "${libtool_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(libtool_INCLUDE_DIRS_RELEASE
                 libtool_INCLUDE_DIR_RELEASE
                 libtool_INCLUDES_RELEASE
                 libtool_DEFINITIONS_RELEASE
                 libtool_LINKER_FLAGS_RELEASE_LIST
                 libtool_COMPILE_DEFINITIONS_RELEASE
                 libtool_COMPILE_OPTIONS_RELEASE_LIST
                 libtool_LIBRARIES_RELEASE
                 libtool_LIBS_RELEASE
                 libtool_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to libtool_LIBS and libtool_LIBRARY_LIST
set(libtool_LIBRARY_LIST_RELEASE ltdl)
set(libtool_LIB_DIRS_RELEASE "/opt/.conan/data/libtool/2.4.6/_/_/package/7220a8d356f22477137df1a1547bcd812718c470/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_libtool_DEPENDENCIES_RELEASE "${libtool_FRAMEWORKS_FOUND_RELEASE} ${libtool_SYSTEM_LIBS_RELEASE} automake::automake")

conan_package_library_targets("${libtool_LIBRARY_LIST_RELEASE}"  # libraries
                              "${libtool_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_libtool_DEPENDENCIES_RELEASE}"  # deps
                              libtool_LIBRARIES_RELEASE            # out_libraries
                              libtool_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "libtool")                                      # package_name

set(libtool_LIBS_RELEASE ${libtool_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${libtool_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND libtool_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND libtool_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${libtool_SYSTEM_LIBS_RELEASE})
    list(APPEND libtool_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND libtool_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(libtool_LIBRARIES_TARGETS_RELEASE "${libtool_LIBRARIES_TARGETS_RELEASE};automake::automake")
set(libtool_LIBRARIES_RELEASE "${libtool_LIBRARIES_RELEASE};automake::automake")

set(CMAKE_MODULE_PATH "/opt/.conan/data/libtool/2.4.6/_/_/package/7220a8d356f22477137df1a1547bcd812718c470/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/opt/.conan/data/libtool/2.4.6/_/_/package/7220a8d356f22477137df1a1547bcd812718c470/" ${CMAKE_PREFIX_PATH})
