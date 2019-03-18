message(STATUS "Downloading and building LibAppImage")

find_package(LibAppImage QUIET)

if(NOT LibAppImage_FOUND)
    include(ExternalProject)

    ExternalProject_Add(LibAppImage_External
        GIT_REPOSITORY https://github.com/AppImage/libappimage.git
        GIT_TAG master
        GIT_SHALLOW On
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -G${CMAKE_GENERATOR} -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} <SOURCE_DIR>
        BUILD_COMMAND make gtest libappimage
        INSTALL_COMMAND make install DESTDIR=<INSTALL_DIR>
        )

    ExternalProject_Get_Property(LibAppImage_External INSTALL_DIR)
    set(LibAppImage_INSTALL_DIR ${INSTALL_DIR})

    set(libappimage_PATH "${LibAppImage_INSTALL_DIR}${CMAKE_INSTALL_PREFIX}/lib/libappimage.so")
    set(libappimage_INCLUDE_DIRECTORIES "${LibAppImage_INSTALL_DIR}${CMAKE_INSTALL_PREFIX}/include/")

    add_library(libappimage SHARED IMPORTED)

    set_target_properties(libappimage PROPERTIES
        IMPORTED_LOCATION ${libappimage_PATH}
        INTERFACE_INCLUDE_DIRECTORIES ${libappimage_INCLUDE_DIRECTORIES}
        INTERFACE_LINK_LIBRARIES "glib-2.0"
        )

    add_dependencies(libappimage LibAppImage_External)
endif(NOT LibAppImage_FOUND)
