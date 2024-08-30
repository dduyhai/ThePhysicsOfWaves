function [x, t] = displacement_for_critical_damping_case(sho, t_end, opt)
    arguments
        sho SimpleHarmonicOscillators.DampedOscillator
        t_end (1,1) double {mustBeNonnegative} = 1.0
        opt.TimeResolution (1,1) double {mustBePositive} = 0.1
        opt.InitialPosition (1,1) double = 1.0
        opt.InitialVelocity (1,1) double = 0.0
    end

    if ~sho.is_critical_damping()
        err_id = mfilename("class") + "." + mfilename() + ".wrong_damping_type";
        err_id = strrep(err_id, ".", ":");
        err_msg = "Coefficients are not compatible with critical damping type.";
        error(err_id, err_msg);
    end

    x_0 = opt.InitialPosition;
    v_0 = opt.InitialVelocity;

    c_0 = x_0;
    c_1 = v_0 + sho.natural_angular_freq * x_0;

    t_beg = 0;
    t = (t_beg : opt.TimeResolution : t_end);
    x = (c_0 + c_1 * t) .* exp(-sho.natural_angular_freq * t);
end
