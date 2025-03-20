#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cba_main",
            "hal_main"
        };
        author = "MiszczuZPolski, Radek";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
