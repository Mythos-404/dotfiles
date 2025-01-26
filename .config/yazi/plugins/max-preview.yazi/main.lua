--- @sync entry
return {
    entry = function(st)
        if st.old then
            Tab.layout, st.old = st.old, nil
        else
            st.old = Tab.layout
            Tab.layout = function(self)
                self._chunks = ui.Layout()
                    :direction(ui.Layout.HORIZONTAL)
                    :constraints({
                        ui.Constraint.Percentage(1),
                        ui.Constraint.Percentage(1),
                        ui.Constraint.Percentage(100),
                    })
                    :split(self._area)
            end
        end
        ya.app_emit("resize", {})
    end,
    enabled = function(st)
        return st.old ~= nil
    end,
}
