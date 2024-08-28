classdef DampedOscillatorTest < matlab.unittest.TestCase
    methods (Test)
        function test_default_DampedOscillator(tst)
            import SimpleHarmonicOscillators.DampedOscillator;
            damped_osc = DampedOscillator();
            tst.verifyEqual(damped_osc.damping_coef, 0.0);
            tst.verifyEqual(damped_osc.natural_angular_freq, 1.0);
        end 

        function test_underdamping_DampedOscillator(tst)
            import SimpleHarmonicOscillators.DampedOscillator;
            omega_0 = rand() * 10.0;
            gamma = omega_0 * rand() * 0.49;
            ud_osc =  DampedOscillator(omega_0, gamma);
            tst.verifyTrue(ud_osc.is_underdamping());
            tst.verifyFalse(ud_osc.is_overdamping());
            tst.verifyFalse(ud_osc.is_critical_damping());
            tst.verifyError(@()ud_osc.displacement_for_overdamping_case(), ...
                "SimpleHarmonicOscillators:DampedOscillator:displacement_for_overdamping_case:wrong_damping_type");
            tst.verifyError(@()ud_osc.displacement_for_critical_damping_case(), ...
                "SimpleHarmonicOscillators:DampedOscillator:displacement_for_critical_damping_case:wrong_damping_type");
        end

        function test_overdamping_DampedOscillator(tst)
            import SimpleHarmonicOscillators.DampedOscillator;
            omega_0 = rand() * 10.0;
            gamma = omega_0 * (2.0 + rand()*10.0);
            od_osc = DampedOscillator(omega_0, gamma);
            tst.verifyTrue(od_osc.is_overdamping());
            tst.verifyFalse(od_osc.is_underdamping());
            tst.verifyFalse(od_osc.is_critical_damping());
            tst.verifyError(@()od_osc.displacement_for_underdamping_case(), ...
                "SimpleHarmonicOscillators:DampedOscillator:displacement_for_underdamping_case:wrong_damping_type");
            tst.verifyError(@()od_osc.displacement_for_critical_damping_case(), ...
                "SimpleHarmonicOscillators:DampedOscillator:displacement_for_critical_damping_case:wrong_damping_type");
            x = od_osc.displacement(10);
            tf = islocalmax(x);
            tst.verifyTrue(isempty(x(tf)));
            tf = islocalmin(x);
            tst.verifyTrue(isempty(x(tf)));
        end

        function test_critical_damping_DampedOscillator(tst)
            import SimpleHarmonicOscillators.DampedOscillator;
            omega_0 = rand() * 10.0;
            gamma = 2.0 * omega_0;
            cd_osc = DampedOscillator(omega_0, gamma);
            tst.verifyTrue(cd_osc.is_critical_damping());
            tst.verifyFalse(cd_osc.is_underdamping());
            tst.verifyFalse(cd_osc.is_overdamping());
            tst.verifyError(@()cd_osc.displacement_for_underdamping_case(), ...
                "SimpleHarmonicOscillators:DampedOscillator:displacement_for_underdamping_case:wrong_damping_type");
            tst.verifyError(@()cd_osc.displacement_for_overdamping_case(), ...
                "SimpleHarmonicOscillators:DampedOscillator:displacement_for_overdamping_case:wrong_damping_type");
            x = cd_osc.displacement_for_critical_damping_case(10);
            tf = islocalmax(x);
            tst.verifyTrue(isempty(x(tf)));
            tf = islocalmin(x);
            xmin = x(tf);
            tst.verifyTrue(isempty(x(tf)));
        end
    end
end
