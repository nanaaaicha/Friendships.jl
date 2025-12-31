using Random
using Statistics
using GLMakie
using Friendships # si tu mets les fonctions dans un autre fichier

pop = Population(5)
println("Population initiale :")
println(pop)

relationships!(pop, 0.5)
println("\nRelations après génération :")
println(pop)

poids = poids0(pop)
println("\nPoids initiaux :")
for ((i,j),(intensity,delta)) in poids
    println("Amitié ($i,$j) : intensité=$intensity, delta=$delta")
end


poidsM(poids, pop; alpha=0.3, beta=0.2, gamma=0.1)
println("\nPoids après modification :")
for ((i,j),(intensity,delta)) in poids
    println("Amitié ($i,$j) : intensité=$intensity, delta=$delta")
end

# Influence entre deux amis
p1, p2 = pop[1], pop[2]
println("\nAvant influence : $(p1.emotions) et $(p2.emotions)")
influence!(p1, p2, poids)
println("Après influence : $(p1.emotions) et $(p2.emotions)")
 ()

 people = Population(50)
relationships!(people, 0.3)

steps = 50
hist = store(people, steps)






hist = store(people, 50; alpha = 0.2, beta = 0.8, gamma = 0.4)

# choisir quelques relations
edges = collect(keys(hist[1]))
sample_edges = rand(edges, min(10, length(edges)))

# récupérer l'évolution
trajectories = Dict(e => [hist[t][e][1] for t in 1:length(hist)] for e in sample_edges)

fig = Figure(resolution = (800, 450))
ax = Axis(
    fig[1,1],
    xlabel = "Temps",
    ylabel = "Intensité",
    title = "Évolution de quelques relations d’amitié",
    limits = ((1, length(hist)), (0, 1))
)

lines_dict = Dict(e => Observable(Point2f[]) for e in sample_edges)

for (e, obs) in lines_dict
    lines!(ax, obs, linewidth = 2)
end

record(fig, "relations_trajectoires.gif", 1:length(hist); framerate = 10) do t
    for e in sample_edges
        push!(lines_dict[e][], Point2f(t, trajectories[e][t]))
        notify(lines_dict[e])
    end
end


person_id = 1   # tu peux changer
# toutes les relations impliquant la personne
edges = [
    e for e in keys(hist[1])
    if e[1] == person_id || e[2] == person_id
]

trajectories = Dict(
    e => [hist[t][e][1] for t in 1:length(hist)]
    for e in edges
)


fig = Figure(resolution = (800, 450))
ax = Axis(
    fig[1,1],
    xlabel = "Temps",
    ylabel = "Intensité de la relation",
    title = "Évolution des relations de la personne $person_id",
    limits = ((1, length(hist)), (0, 1))
)

lines_obs = Dict(e => Observable(Point2f[]) for e in edges)

for (e, obs) in lines_obs
    friend = e[1] == person_id ? e[2] : e[1]
    lines!(ax, obs, linewidth = 2, label = "ami $friend")
end

axislegend(ax, position = :rb)

record(fig, "personne_$person_id.gif", 1:length(hist); framerate = 10) do t
    for e in edges
        push!(lines_obs[e][], Point2f(t, trajectories[e][t]))
        notify(lines_obs[e])
    end
end

using Random

edges = collect(keys(hist[1]))
chosen_edges = rand(edges, min(2, length(edges)))
trajectories = Dict(
    e => [hist[t][e][1] for t in 1:length(hist)]
    for e in chosen_edges
)

fig = Figure(resolution = (800, 450))
ax = Axis(
    fig[1,1],
    xlabel = "Temps",
    ylabel = "Intensité de la relation",
    title = "Évolution de relations sélectionnées",
    limits = ((1, length(hist)), (0, 1))
)


lines_obs = Dict(e => Observable(Point2f[]) for e in chosen_edges)

for (e, obs) in lines_obs
    lines!(ax, obs, linewidth = 3, label = "relation $(e)")
end

axislegend(ax, position = :rb)

record(fig, "relations_selectionnees.gif", 1:length(hist); framerate = 10) do t
    for e in chosen_edges
        push!(lines_obs[e][], Point2f(t, trajectories[e][t]))
        notify(lines_obs[e])
    end
end
