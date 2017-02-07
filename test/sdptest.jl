#  Copyright 2016, Los Alamos National Laboratory, LANS LLC.
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at http://mozilla.org/MPL/2.0/.

function runsdptests(mip_solver_drives, mip_solver, sdp_solver, log)
    @testset "Max problem with SDP defaults" begin
        x = Convex.Variable(1,:Int)
        y = Convex.Variable(1, Convex.Positive())
        z = Convex.Semidefinite(2)

        problem = Convex.maximize(3x + y,
                            x >= 0,
                            3x + 2y <= 10,
                            x^2 <= 4,
                            y >= z[2,2])

        Convex.solve!(problem, PajaritoSolver(mip_solver_drives=mip_solver_drives, mip_solver=mip_solver, cont_solver=sdp_solver, log_level=log))

        @test isapprox(problem.optval, 8.0, atol=TOL)
    end

    @testset "Max problem without eig cuts" begin
        x = Convex.Variable(1,:Int)
        y = Convex.Variable(1, Convex.Positive())
        z = Convex.Semidefinite(2)

        problem = Convex.maximize(3x + y,
                            x >= 0,
                            3x + 2y <= 10,
                            x^2 <= 4,
                            y >= z[2,2])

        Convex.solve!(problem, PajaritoSolver(sdp_eig=false, mip_solver_drives=mip_solver_drives, mip_solver=mip_solver, cont_solver=sdp_solver, log_level=log))

        @test isapprox(problem.optval, 8.0, atol=TOL)
    end
end
