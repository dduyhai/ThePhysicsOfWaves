function [x, t] = displacement_for_underdamping_case(sho, t_end, opt)
    arguments
        sho SimpleHarmonicOscillators.DampedOscillator
        t_end (1,1) double {mustBeNonnegative} = 1.0
        opt.TimeResolution (1,1) double {mustBePositive} = 0.1
        opt.InitialPosition (1,1) double = 1.0
        opt.InitialVelocity (1,1) double = 0.0
    end

    if ~sho.is_underdamping()
        err_id = mfilename("class") + "." + mfilename() + ".wrong_damping_type";
        err_id = strrep(err_id, ".", ":");
        err_msg = "Coefficients are not compatible with underdamping type.";
        error(err_id, err_msg);
    end

    x_0 = opt.InitialPosition;
    v_0 = opt.InitialVelocity;

    % since the system is underdamping, omega_u > 0
    omega_u = sqrt(sho.natural_angular_freq^2 - (0.5 * sho.damping_coef)^2);
    A = sqrt(x_0^2 * omega_u^2 + v_0^2) / omega_u;
    phi = atan2(-v_0 / (A * omega_u), x_0 / omega_u);

    t_beg = 0;
    t = (t_beg:opt.TimeResolution:t_end);
    x = A .* exp((-0.5 * sho.damping_coef) .* t) .* cos(omega_u .* t + phi); 
end
