-- -*- lua -*-
--
-- Binary in an ubuntu container
--

whatis([[Name : Geeqie]])
whatis([[Version : 1.4]])
whatis([[Target : x86_64]])
whatis([[Short description : Geeqie is a viewer.]])

help([[ Geeqie is a free open software image viewer and organiser program for Linux, FreeBSD and other Unix-like operating systems ]])

-- Set variables to notify the provider of the new services

setenv("GEEQIE_ROOT", "/lfs/software/misc/geeqie/1.4")
prepend_path("PATH", "/lfs/software/misc/geeqie/1.4/bin")
