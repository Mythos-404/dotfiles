{
  "$user_scripts" = "$HOME/.config/hypr/scripts";

  "$mainMod" = "Super";

  bind = [
    "$mainMod, Return, exec, $TERMINAL"
    "$mainMod, E, exec, $FILE_MANAGER"
    "$mainMod+Shift, E, exec, thunar"
  ];
}
