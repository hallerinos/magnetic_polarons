"""
Construct a cubical lattice (3D)
"""
function cube(Nx::Int, Ny::Int, Nz::Int; kwargs...)
    yperiodic = get(kwargs, :yperiodic, false)
    yperiodic = yperiodic && (Nz > 2)
    yperiodic == true ? error("PBC not yet implemented.") : nothing

    ex = [1.0, 0.0, 0.0]
    ey = [0.0, 1.0, 0.0]
    ez = [0.0, 0.0, 1.0]

    lattPos = []
    for nz in 1:Nz, nx in 1:Nx, ny in 1:Ny
      pos = ex.*nx + ey.*ny + ez.*nz
      append!(lattPos, [pos])
    end

    latt = []
    for (idr, r) in enumerate(lattPos) #, (idrpr, rpr) in enumerate(lattPos)
      # don't sum twice :)
      for (idrpr, rpr) in enumerate(lattPos[idr+1:end])
        rmrpr = rpr .- r
        for (iddir, dir) in enumerate([ex, ey, ez])
          rmrpr == dir ? append!(latt, [Bond(idr, idr+idrpr, r, rpr, "$iddir")]) : nothing
          # rmrpr == dir ? append!(latt, [LatticeBond(idr, idrpr, r, rpr, "$iddir")]) : nothing
        end
      end
    end

    return length(lattPos), latt, lattPos
end