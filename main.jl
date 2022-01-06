using ITensors
include("bonds.jl")
include("lattices.jl")
include("bonds_plotter.jl")

Nx = Ny = 4
Nz = 1

N, graph = cube(Nx, Ny, Nz)
plot_graph3d(graph)
sites = siteinds("S=1/2", N; conserve_qns = false)

# Define the Heisenberg spin Hamiltonian on this graph
ampo = OpSum()
for b in graph
    ampo .+= 0.5, "S+", b.s1, "S-", b.s2
    ampo .+= 0.5, "S-", b.s1, "S+", b.s2
    ampo .+=      "Sz", b.s1, "Sz", b.s2
end
H = MPO(ampo,sites)

state = [isodd(n) ? "Up" : "Dn" for n=1:N]
# Initialize wavefunction to a random MPS
# of bond-dimension 10 with same quantum
# numbers as `state`
psi = randomMPS(sites,state,10)

sweeps = Sweeps(10)
maxdim!(sweeps, 32)
cutoff!(sweeps, 1E-12)
# @show sweeps

energy,psi = dmrg(H, psi, sweeps)
figure(); [plot(expect(psi, loc)) for loc in ["Sx", "Sy", "Sz"]]
# figure(); [plot(expect(psi, loc)) for loc in ["Sz"]]
0;