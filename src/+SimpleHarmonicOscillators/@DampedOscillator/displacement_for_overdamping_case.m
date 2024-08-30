function [x, t] = displacement_for_overdamping_case(sho, t_end, opt)
    arguments
        sho SimpleHarmonicOscillators.DampedOscillator
        t_end (1,1) double {mustBeNonnegative} = 1.0
        opt.TimeResolution (1,1) double {mustBePositive} = 0.1
        opt.InitialPosition (1,1) double = 1.0
        opt.InitialVelocity (1,1) double = 0.0
    end

    if ~sho.is_overdamping()
        err_id = mfilename('class') + "." + mfilename() + ".wrong_damping_type";
        err_id = strrep(err_id, ".", ":");
        err_msg = "Coefficients are not compatible with overdamping type.";
        error(err_id, err_msg);
    end

    x_0 = opt.InitialPosition;
    v_0 = opt.InitialVelocity;

    half_gamma = 0.5 * sho.damping_coef;
    omega_f = sqrt(half_gamma^2 - sho.natural_angular_freq^2);
    omega_s = half_gamma - omega_f;
    omega_f = half_gamma + omega_f;
    c = [1, 1; -omega_f, -omega_s] \ [x_0; v_0];
    c_f = c(1);
    c_s = c(2);

    t_beg = 0.0;
    t = (t_beg:opt.TimeResolution:t_end);
    x = c_f * exp(-omega_f * t) + c_s * exp(-omega_s * t);
end
