using ITensors

#init indicies
α = Index(3,"α")
β = Index(3,"β")
γ = Index(3,"γ")
δ = Index(3,"δ")
ϵ = Index(3,"ϵ")
#init data
a = [x*x-2*y for x in 0:2, y in 0:2]
b = [-3^(x)*y+z for x in 0:2, y in 0:2, z in 0:2]
c = [y for x in 0:2,y in 0:2]
d = [x*y*z for x in 0:2, y in 0:2, z in 0:2]
#init tensors
A = ITensor(a,α,β)
B = ITensor(b,β,γ,δ)
C = ITensor(c,δ,ϵ)
D = ITensor(d,α,γ,ϵ)
#compute contraction
res = A*B*C*D
print(res.tensor)

#equivalent for-loop calculation
s=0
for a in 0:2
    for b in 0:2
        for d in 0:2
            for e in 0:2
                for g in 0:2
                    global s += (b^2 - 2 * a) * (-(3^a) * g + d) * g * b * e^2
                end
            end
        end
    end
end
print(s)