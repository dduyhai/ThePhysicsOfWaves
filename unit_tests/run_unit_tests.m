function test_res = run_unit_tests(opt)
    arguments
        opt.Pattern {mustBeTextScalar} = "*"
    end
    cur_dir = fileparts(mfilename('fullpath'));
    src_dir = fullfile(cur_dir, "../src/");
    old_path = addpath(src_dir);

    test_res = [];
    test_suites = matlab.unittest.TestSuite.fromFolder(pwd(), ...
        Name = opt.Pattern);
    if isempty(test_suites)
        return;
    end

    try
        test_res = run(test_suites);
    catch ME
        err_rpt = getReport(ME);
        disp(err_rpt);
    end
    path(old_path);
    if nargout() == 0
        disp(table(test_res));
    end
end
