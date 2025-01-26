// For Github Url: https://github.com/butterw/bShaders/blob/master/mpv/settings/scripts/switch-shader.js
// 修复了无法正常工作的 Bug

"use strict"
var shaders_status = ""
var vf_status = ""

mp.register_script_message("switch-shaders", function () {
    var shaders_str = mp.get_property("glsl-shaders")
    if (!shaders_str.length && shaders_status.length) {
        //shaders-on: restore glsl-shaders (but only if empty!)
        mp.set_property("glsl-shaders", shaders_status)
        mp.osd_message(mp.get_property("glsl-shaders"), 0.5)
        print("shaders-on:", shaders_status)
        shaders_status = ""
    } else {
        //shaders-off: store current glsl-shaders
        shaders_status = mp.get_property("glsl-shaders")
        mp.set_property("glsl-shaders", "")
        mp.osd_message("shaders-off", 0.5)
        print("shaders-off", shaders_status)
    }
})

mp.register_script_message("switch-vf", function () {
    var vf_str = mp.get_property("vf")
    if (!vf_str.length && vf_status.length) {
        //video filter-on: restore vf (but only if vf is empty!)
        mp.set_property("vf", vf_status)
        print("vf-on:", vf_status)
        vf_status = ""
    } else {
        //vfilter-off: store current vf
        vf_status = mp.get_property("vf").split(",")
        mp.set_property("vf", "")
        mp.osd_message("vf-off", 0.5)
        print("vf-off", vf_status)
    }
})
