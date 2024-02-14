from quimb.tensor import *
from quimb import *
import numpy as np
import matplotlib.pyplot as plt
#%% coin flip fidelity
true = np.sqrt(np.array([[0.5],[0.5]]))
fidels = []
for j in np.linspace(0,0.5,20):
    fake = np.sqrt(np.array([[j],[1-j]]))
    fidels.append(fidelity(true,fake,squared=True))
plt.plot(np.linspace(0,0.5,20),fidels)
plt.title("Fidelity of a weighted Coin vs Fair Coin")
plt.ylabel("Fidelity")
plt.xlabel("Coin Bias")

#%%

def generate_initial_vector(n=10,n_gates=50):
    # the initial state
    cyclic = False
    psi = MPS_computational_state("1"+"0"*(n-1),cyclic=cyclic, tags='KET', dtype='complex128')    
    # the gates
    gates = [rand_uni(4) for _ in range(n_gates)]
    u_tags = [f'U{i}' for i in range(n_gates)]
    
    for U, t in zip(gates, u_tags):
        # generate a random coordinate
        i = np.random.randint(0, n - int(not cyclic))
        
        # apply the next gate to the coordinate
        #     propagate_tags='sites' (the default in fact) specifies that the
        #     new gate tensor should inherit the site tags from tensors it acts on
        psi.gate_(U, where=[i, i + 1], tags=t, propagate_tags='sites')
        
    return psi.to_dense()

#%%

n=10
init= generate_initial_vector(n,100)

full =MatrixProductState.from_dense(init,[2]*n)
compressed = MatrixProductState.from_dense(init,[2]*n,max_bond=2)
fidelity(compressed.to_dense(),full.to_dense(),squared=True)



#%%
#solution
n=10
fids=[]
for j in np.linspace(0,3,6):
    for trial in range(0,10):
        fids_trial=[]
        init= generate_initial_vector(n,int(10**j))
        full =MatrixProductState.from_dense(init,[2]*n)
        
        bonds = range(32,1,-1)
        for max_bond in bonds:
            compressed = MatrixProductState.from_dense(init,[2]*n,max_bond=max_bond)
            fids_trial.append(fidelity(compressed.to_dense(),full.to_dense(),squared=True))
        fids.append(fids_trial)
    lab = np.round(10**j)
    plt.plot(bonds,np.mean(fids,axis=0),label=rf"{lab}")
plt.ylabel("Fidelity")
plt.xlabel("Condensed max bond_dim")
plt.legend(title="Number of Entangling Gates")
