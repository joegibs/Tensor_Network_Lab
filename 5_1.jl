using ITensors
using PyCall
n=20
en_vec= zeros(n)
for N in 10:10:200
    sites = siteinds("S=1/2",N)

    ampo = OpSum()
    #handwaving hamiltonian wrong
    #cited paper has 2 in coupling term
    for j=1:N-1
        ampo -= 2,"Sx",j,"Sx",j+1
    end
    for j=1:N
        ampo -= "Sz",j
    end
    H = MPO(ampo,sites)

    sweeps = Sweeps(5) # number of sweeps is 5
    maxdim!(sweeps,10,20,100,100,200) # gradually increase dim kept
    cutoff!(sweeps,1E-10) # desired truncation error

    psi0 = randomMPS(sites,10)
    energy,psi = dmrg(H,psi0,sweeps)
    global en_vec[Int((N-10)/10)+1] = energy
end


np = pyimport("numpy")
scipy  = pyimport("scipy")

#the function in handwaving is incorrect cited paper has a 1/2
py"""
import numpy as np
def func(x, a, b):
    return (1/2)*(1- 1/np.sin(np.pi/(a*x+b)))
"""  
               
xdata = np.linspace(10,200,n)
ydata = en_vec

popt, pcov = scipy.optimize.curve_fit(py"func", xdata, ydata)
#with correction for cited paper we get the right answer
print("α : ",popt[1], "\nβ : ",popt[2])