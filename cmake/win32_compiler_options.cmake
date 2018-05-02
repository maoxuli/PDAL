#
# We assume you're using MSVC if you're on WIN32.  This may be a bad
# assumption, in which case things should change.
#

function(pdal_target_compile_settings target)
    message("*** Compile settings for ${target} ***")
    target_compile_definitions(${target} PRIVATE
        -DWIN32_LEAN_AND_MEAN)
    if (MSVC)
        # check for MSVC 8+
        if (NOT (MSVC_VERSION VERSION_LESS 1400))
            target_compile_definitions(${target} PRIVATE
                -D_CRT_SECURE_NO_DEPRECATE
                -D_CRT_SECURE_NO_WARNINGS
                -D_CRT_NONSTDC_NO_WARNING
                -D_SCL_SECURE_NO_WARNINGS
                -DNOMINMAX
            )
            target_compile_options(${target} PRIVATE
                # Nitro makes use of Exception Specifications, which results in
                # numerous warnings when compiling in MSVC. We will ignore
                # them for now.
                /wd4290
                /wd4800
                # Windows warns about integer narrowing like crazy and it's
                # annoying.  In most cases the programmer knows what they're
                # doing.  A good static analysis tool would be better than
                # turning this warning off.
                /wd4267
                # Annoying warning about function hiding with virtual
                # inheritance.
                /wd4250
                )
        endif()

        # check for MSVC 9+
        if (MSVC_VERSION VERSION_GREATER_EQUAL 1500)
            include(ProcessorCount)
            ProcessorCount(N)
            if(NOT N EQUAL 0)
                target_compile_options(${target} PRIVATE "/MP${N}")
            endif()
        endif()

        option(PDAL_USE_STATIC_RUNTIME "Use the static runtime" FALSE)
        if (PDAL_USE_STATIC_RUNTIME)
            target_compile_options(${target} PRIVATE /MT)
        endif()
    endif()
endfunction()

#
# Windows htonl and similar are in winsock :(
#
set(WINSOCK_LIBRARY ws2_32)

set(CMAKE_INCLUDE_PATH "c:/OSGeo4W64/include;$ENV{CMAKE_INCLUDE_PATH}")
set(CMAKE_LIBRARY_PATH "c:/OSGeo4W64/lib;$ENV{CMAKE_LIBRARY_PATH}")
set(CMAKE_PREFIX_PATH "c:/OSGeo4W64/cmake;$ENV{CMAKE_LIBRARY_PATH}")
