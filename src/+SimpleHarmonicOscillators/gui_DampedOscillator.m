classdef gui_DampedOscillator < matlab.apps.AppBase
properties (Access = public, Constant = true)
    AppWidth = 1280
    AppHeight = 720
end
properties (GetAccess = public, SetAccess = private)
    ge_figure matlab.ui.Figure
    ge_layout_grid matlab.ui.container.GridLayout
    ge_angular_freq_label matlab.ui.control.Label
    ge_angular_freq matlab.ui.control.NumericEditField
    ge_damping_coef_label matlab.ui.control.Label
    ge_damping_coef matlab.ui.control.NumericEditField
    ge_ending_time_label matlab.ui.control.Label
    ge_ending_time matlab.ui.control.NumericEditField
    ge_time_step_label matlab.ui.control.Label
    ge_time_step matlab.ui.control.NumericEditField
    ge_save_damped_osc matlab.ui.control.Button
    ge_plot_panel = matlab.ui.container.Panel

    n_saved_oscs = 0;
    damped_oscs SimpleHarmonicOscillators.DampedOscillator
    tmp_damped_osc SimpleHarmonicOscillators.DampedOscillator
end

methods (Access = public)
    function god = gui_DampedOscillator()
        god.create_gui_elements();
        god.damped_oscs(10) = SimpleHarmonicOscillators.DampedOscillator();
        god.n_saved_oscs = 0;
        registerApp(god, god.ge_figure);
        if nargout == 0
            clear('god');
        end
    end

    function delete(god)
        delete(god.ge_figure);
    end

end

methods (Access = private)
    function create_gui_elements(god)
        god.ge_figure = uifigure(Name = "Damped Osilator", ...
            Visible = "off", Resize = "on", Scrollable = "off");
        god.ge_figure.Position = [10, 0, god.AppWidth, god.AppHeight];
        movegui(god.ge_figure, "center");

        n_layout_columns = 9;
        n_layout_rows = 2;
        god.ge_layout_grid = uigridlayout(god.ge_figure, [n_layout_rows, n_layout_columns]);
        god.ge_layout_grid.RowHeight = {25, '1x'};
        god.ge_layout_grid.ColumnWidth = repmat({'1x'}, 1, n_layout_columns);

        current_row = 1;

        god.ge_angular_freq_label = uilabel(god.ge_layout_grid, ...
            HorizontalAlignment = 'right', ...
            Text = "Angular freq. $\omega_0$ (rad/s):", Interpreter = 'latex');
        god.ge_angular_freq_label.Layout.Row = current_row;
        god.ge_angular_freq_label.Layout.Column = 1;

        god.ge_angular_freq = uieditfield(god.ge_layout_grid, "numeric", ...
            Value = 1.0, Limits = [0.0, Inf], LowerLimitInclusive = 'off', ...
            ValueChangedFcn=@(src, event) plot_new_oscillation(god, src, event));
        god.ge_angular_freq.Layout.Column = god.ge_angular_freq_label.Layout.Column + 1;
        god.ge_angular_freq.Layout.Row = current_row;

        god.ge_damping_coef_label = uilabel(god.ge_layout_grid, ...
            HorizontalAlignment = 'right', ...
            Text = "Damping coef. $\gamma$: ", Interpreter = 'latex');
        god.ge_damping_coef_label.Layout.Column = god.ge_angular_freq.Layout.Column+ 1;
        god.ge_damping_coef_label.Layout.Row = current_row;

        god.ge_damping_coef = uieditfield(god.ge_layout_grid, "numeric", ...
            Value = 1.0, Limits = [0.0, Inf], ...
            ValueChangedFcn=@(src, event) plot_new_oscillation(god, src, event));
        god.ge_damping_coef.Layout.Column = god.ge_damping_coef_label.Layout.Column + 1;
        god.ge_damping_coef.Layout.Row = current_row;

        god.ge_ending_time_label = uilabel(god.ge_layout_grid, Text = "Ending time:" , ...
            HorizontalAlignment = 'right');
        god.ge_ending_time_label.Layout.Column = god.ge_damping_coef.Layout.Column + 1;
        god.ge_ending_time_label.Layout.Row = current_row;

        god.ge_ending_time = uieditfield(god.ge_layout_grid, "numeric", ...
            Value = 1.0, Limits = [0.0, Inf], LowerLimitInclusive = 'off', ...
            ValueChangedFcn=@(src, event) plot_oscillation(god, src, event));
        god.ge_ending_time.Layout.Column = god.ge_ending_time_label.Layout.Column + 1;
        god.ge_ending_time.Layout.Row = current_row;

        god.ge_time_step_label = uilabel(god.ge_layout_grid, Text = "Time step:", ...
            HorizontalAlignment = 'right');
        god.ge_time_step_label.Layout.Column = god.ge_ending_time.Layout.Column + 1;
        god.ge_time_step_label.Layout.Row = current_row;

        god.ge_time_step = uieditfield(god.ge_layout_grid, "numeric", ...
            Value = 0.01, Limits = [0.0, Inf], LowerLimitInclusive = 'off', ....
            ValueChangedFcn = @(src, event) plot_oscillation(god, src, event));
        god.ge_time_step.Layout.Column = god.ge_time_step_label.Layout.Column + 1;
        god.ge_time_step.Layout.Row = current_row;

        god.ge_save_damped_osc = uibutton(god.ge_layout_grid, Text = "Save current osc.",...
            WordWrap = 'on', ButtonPushedFcn=@(src, event) save_oscillation(god));
        god.ge_save_damped_osc.Layout.Column = god.ge_time_step.Layout.Column + 1;
        god.ge_save_damped_osc.Layout.Row = current_row;

        current_row = current_row + 1;
        god.ge_plot_panel = uipanel(god.ge_layout_grid, BorderType = 'none');
        god.ge_plot_panel.Layout.Column = [1, n_layout_columns];
        god.ge_plot_panel.Layout.Row = current_row;

        god.plot_oscillation();
        
        god.ge_figure.Visible = "on";
    end

    function val = angular_freq(god)
        val = god.ge_angular_freq.Value;
    end

    function val = damping_coef(god)
        val = god.ge_damping_coef.Value;
    end

    function val = ending_time(god)
        val = god.ge_ending_time.Value;
    end

    function val = time_step(god)
        val = god.ge_time_step.Value;
    end

    function val = save_oscillation(god)
        god.n_saved_oscs = god.n_saved_oscs + 1;
        god.damped_oscs(god.n_saved_oscs) = god.tmp_damped_osc; 
        god.ge_save_damped_osc.Enable = 'off';
    end

    function val = plot_new_oscillation(god, ~, ~)
        god.ge_save_damped_osc.Enable = 'on';
        god.plot_oscillation();
    end

    function plot_oscillation(god, ~, ~)
        tlo = tiledlayout(god.ge_plot_panel, 1, 1);
        ax_help = nexttile(tlo, 1);
        for id = 1 : god.n_saved_oscs
            [x, t] = god.damped_oscs(id).displacement(god.ending_time, ...
                TimeResolution = min(god.ending_time() / 10, god.time_step()));
            hold(ax_help, 'on');
            plot(ax_help, t, x, DisplayName = god.damped_oscs(id).display_name());
            hold(ax_help, 'off');
        end
        god.tmp_damped_osc = SimpleHarmonicOscillators.DampedOscillator(god.angular_freq(), god.damping_coef());
        [x, t] = god.tmp_damped_osc.displacement(god.ending_time, ...
            TimeResolution = min(god.ending_time() / 10, god.time_step()));
        hold(ax_help, 'on');
        plot(ax_help, t, x, DisplayName = god.tmp_damped_osc.display_name());
        hold(ax_help, 'off');
        ax_help.XGrid = 'on';
        ax_help.YGrid = 'on';
        ax_help.Title.String = compose("Q factor = %f", god.tmp_damped_osc.q_value());
        ax_help.XLabel.String = 'Time t';
        ax_help.YLabel.String = 'Amplitude x';
        lgd = legend(ax_help);
        lgd.Layout.Tile = 'east';
    end

end

end
