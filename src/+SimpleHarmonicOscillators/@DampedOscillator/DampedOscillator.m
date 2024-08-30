classdef DampedOscillator
properties (GetAccess = public, SetAccess = public)
    natural_angular_freq (1,1) double {mustBePositive} = 1.0
    damping_coef (1,1) double {mustBeNonnegative} = 0.0
end

methods (Access = public)
    function obj = DampedOscillator(omega_0, gamma)
        arguments
            omega_0 (1,1) double {mustBePositive} = 1.0
            gamma (1,1) double {mustBeNonnegative} = 0.0
        end
        obj.natural_angular_freq = omega_0;
        obj.damping_coef = gamma;
    end

    function q = q_factor(sho)
        if isequal(sho.damping_coef, 0.0)
            q = Inf;
        else
            q = sho.natural_angular_freq / sho.damping_coef;
        end
    end

    function q = q_value(sho)
        q = sho.q_factor();
    end

    function damping_type = query_damping_type(sho)
        if sho.damping_coef < 2.0 * sho.natural_angular_freq
            damping_type = "underdamping";
        elseif sho.damping_coef == 2.0 * sho.natural_angular_freq
            damping_type = "critical damping";
        else
            damping_type = "overdamping";
        end
    end

    function tf = is_underdamping(sho)
        tf = (sho.damping_coef < 2.0 * sho.natural_angular_freq);
    end

    function tf = is_overdamping(sho)
        tf = (sho.damping_coef > 2.0 * sho.natural_angular_freq);
    end

    function tf = is_critical_damping(sho)
        tf = (sho.damping_coef == 2.0 * sho.natural_angular_freq);
    end

    function str = display_name(sho)
        str = compose("Angular freq. = %6.2f, Damping coef. = %6.2f", ...
            sho.natural_angular_freq, sho.damping_coef);
    end
end

methods
    [x, t] = displacement(sho, t_end, opt);
    [x, t] = displacement_for_underdamping_case(sho, t_end, opt);
    [x, t] = displacement_for_overdamping_case(sho, t_end, opt);
    [x, t] = displacement_for_critical_damping_case(sho, t_end, opt);
end
end
