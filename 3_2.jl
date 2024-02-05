using ITensors

#differnt BC from handwaving
X = [0 1 ; 1 0]
I = [1 0; 0 1]
A = reshape([[1 0 ; 0 1]  [0 1 ; 1 0]],(2,2,2))

#initialize sites and MPS
N = 3
sites = siteinds(2,N)
psi = MPS(sites,linkdims=2)
for i in 1:N
    if i==1||i==N
        psi[i] = ITensor(I,inds(psi[i]))
    else
        psi[i] = ITensor(A,inds(psi[i]))
    end
end

#Evaluate a state for each site and contract with the mps
el = [2,2,2]
V = ITensor(1.)
for j=1:N
  V *= (psi[j]*state(sites[j],el[j]))
end
v = scalar(V)