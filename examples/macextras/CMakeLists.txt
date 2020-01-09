# Generated from macextras.pro.

add_subdirectory(macfunctions)
if(APPLE_OSX)
    add_subdirectory(embeddedqwindow)
    # TODO: add_subdirectory(macpasteboardmime) # special case
    add_subdirectory(mactoolbar)
endif()
