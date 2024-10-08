MacOSVersion = MacOSVersion or "14.5"

project "GLFW"
	kind "StaticLib"
	language "C"
	warnings "Off"

	targetdir ("%{wks.location}/bin/" .. outputdir .. "/%{prj.name}")
	objdir ("%{wks.location}/bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"include/GLFW/glfw3.h",
		"include/GLFW/glfw3native.h",
		"src/glfw_config.h",
		"src/context.c",
		"src/init.c",
		"src/input.c",
		"src/monitor.c",

		"src/null_init.c",
		"src/null_joystick.c",
		"src/null_monitor.c",
		"src/null_window.c",

		"src/platform.c",
		"src/vulkan.c",
		"src/window.c",
	}

	filter "system:windows"
		staticruntime "on"
		systemversion "latest"

		files
		{
			"src/win32_init.c",
			"src/win32_joystick.c",
			"src/win32_module.c",
			"src/win32_monitor.c",
			"src/win32_time.c",
			"src/win32_thread.c",
			"src/win32_window.c",
			"src/wgl_context.c",
			"src/egl_context.c",
			"src/osmesa_context.c"
		}

		defines
		{
			"_GLFW_WIN32",
			"_CRT_SECURE_NO_WARNINGS"
		}

	filter "system:linux"
		staticruntime "on"
        systemversion "latest"
		pic "On"

        files
        {
            "src/xkb_unicode.c",
            "src/posix_module.c",
			"src/posix_time.c",
			"src/posix_thread.c",
			"src/posix_module.c",
			"src/egl_context.c",
			"src/osmesa_context.c",
			"src/linux_joystick.c"
        }

        -- Check if system is running wayland
        if os.getenv("WAYLAND_DISPLAY") then -- Note: Wayland has never been tested.
            defines { "_GLFW_WAYLAND" }

            files
            {
               "src/wl_init.c",
               "src/wl_monitor.c",
               "src/wl_window.c",
            }

         -- Else check if system is running x11
        elseif os.getenv("DISPLAY") then
            defines { "_GLFW_X11" }

            files
            {
                "src/x11_init.c",
                "src/x11_monitor.c",
                "src/x11_window.c",
                "src/glx_context.c",
            }
        else -- Default to X11
            defines { "_GLFW_X11" }

            files
            {
                "src/x11_init.c",
                "src/x11_monitor.c",
                "src/x11_window.c",
                "src/xkb_unicode.c",
            }
        end

	filter "system:macosx"
		staticruntime "on"
		systemversion(MacOSVersion)
		pic "On"

		defines
		{
			"_GLFW_COCOA"
		}

		files
		{
			"src/cocoa_init.m",
			"src/cocoa_monitor.m",
			"src/cocoa_window.m",
			"src/cocoa_joystick.m",
			"src/cocoa_time.c",
			"src/nsgl_context.m",
			"src/posix_thread.c",
			"src/posix_module.c",
			"src/osmesa_context.c",
			"src/egl_context.c"
		}

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"

    filter "configurations:Dist"
		runtime "Release"
		optimize "Full"
