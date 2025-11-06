# Module pour gérer les personnes et leurs amitiés
module Friendships

using Random
using LinearAlgebra: norm


# Type Person
mutable struct Person
    id::Int
    values::Vector{Float64} 
    emotions::Vector{Float64}
    friends::Vector{Int}
end

const Population=Vector{Person}

export Population, relationships!,similarity,poids0,poidsM,store,influence

# Générer une population

function Population(n::Int)
    [Person(i, rand(5), rand(3), Int[]) for i in 1:n]
end

# Créer des amitiés

function relationships!(people::Population,prob::Float64=0.5)
    for i in 1:length(people)
        for j in i+1:length(people)

            if rand() < prob
                push!(people[i].friends, j)
                push!(people[j].friends, i)
            end
        end
    end
end
 
function similarity(p1::Person, p2::Person)
    return 1 - norm(p1.values - p2.values)/sqrt(length(p1.values))
end

function poids0(people::Population)
    poids = Dict{Tuple{Int,Int}, Tuple{Float64, Float64}}()  # (intensity,delta)

    for i in 1:length(people)
        for j in people[i].friends
            if i < j
                poids[(i,j)] = (0.1, 0.0)  # intensite initiale 0.1, delta 0
            end
        end
    end

    return poids
end


function poidsM(poids::Dict{Tuple{Int,Int}, Tuple{Float64, Float64}}, people::Population;
                alpha=0.7, beta=0.2, gamma=0.1)

    for ((i,j), (intensite,_)) in poids
        p1 = people[i]
        p2 = people[j]

        compat = similarity(p1, p2)
        epsilon = gamma * randn() * compat

        delta = alpha * intensite + beta * compat + epsilon - intensite
        intensiteM = clamp(intensite + delta, 0, 1)

        poids[(i,j)] = (intensiteM, delta)
    end
end

# Simuler et stocker l'évolution des scores
function store(people::Population, steps=50; alpha=0.7, beta=0.2, gamma=0.1)

    poids = poids0(people)
    
    historique = Vector{Dict{Tuple{Int,Int}, Tuple{Float64, Float64}}}(undef, steps)
    
    for t in 1:steps
    
        poidsM(poids, people; alpha=alpha, beta=beta, gamma=gamma)
        
    
        historique[t] = deepcopy(poids)
    end
    
    return historique
end

# influence
function influence!(p1::Person, p2::Person, poids::Dict{Tuple{Int,Int}, Tuple{Float64,Float64}};
                                     alpha=0.5, beta=0.3, gamma=0.2, seuil=0.7)

    if !(p2.id in p1.friends && p1.id in p2.friends)
        return 
    end

    key = sort((p1.id, p2.id))
    score = poids[key][1]

    if score < seuil
        return  
    end

    compat = similarity(p1, p2)

    intensite = 0.5 * (mean(p1.emotions) + mean(p2.emotions))

    epsilon = gamma * randn()

    delta = alpha * intensite + beta * compat + epsilon - intensite
    
    for i in 1:length(p1.emotions)
        p1.emotions[i] = clamp(p1.emotions[i] + 0.5*delta, 0, 1)
    end
    for i in 1:length(p2.emotions)
        p2.emotions[i] = clamp(p2.emotions[i] + 0.5*delta, 0, 1)
    end
end


function Base.show(io::IO, person::Person)
    print(io, "Personne $(person.id) avec amis $(person.friends)")

end

function Base.show(io::IO, people::Population)
    println(io, "Population :")
    for p in people
        Base.show(io, p)   # appelle le show déjà défini pour Person
        println(io)        # saut de ligne
    end
end


end
 # module
