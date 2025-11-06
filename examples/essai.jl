
 
using Friendships     
import .Friendships: Population, Person, relationships!, similarity,poids0,poidsM,store
using GLMakie
using Graphs

# ================================
# 1. Création de la population
# ================================
pop = Population(10)           # 10 personnes
relationships!(pop, 0.4)      # 40% de chance de créer une amitié

# Afficher la population
println(pop)

# ================================
# 2. Simuler et stocker l'évolution des scores
# ================================
historique = store(pop, 50)   # 50 steps

# Afficher l’historique pour vérifier
for t in 1:length(historique)
    println("Step $t : ", historique[t])
end

# ================================
# 3. Fonction pour visualiser le réseau
# ================================
function plot_population_makie(pop::Population)
    n = length(pop)
    g = SimpleGraph(n)

    # Ajouter les arêtes selon les amitiés
    for p in pop
        for f in p.friends
            add_edge!(g, p.id, f)
        end
    end

    # Positions aléatoires pour les nœuds
    pos = [(rand(), rand()) for i in 1:n]
    xs = [p[1] for p in pos]
    ys = [p[2] for p in pos]

    fig = GLMakie.Figure(resolution=(600,600))
    ax = GLMakie.Axis(fig[1,1]; aspect=1)

    # Tracer les arêtes
    for e in edges(g)
        i, j = src(e), dst(e)
        GLMakie.lines!(ax, [xs[i], xs[j]], [ys[i], ys[j]], color=:gray)
    end

    # Tracer les nœuds
    GLMakie.scatter!(ax, xs, ys, color=:skyblue, markersize=15)
    fig
end

# Tracer le réseau
plot_population_makie(pop)

# ================================
# 4. Fonction pour visualiser l'évolution des scores
# ================================
function plot_scores(historique)
    fig = GLMakie.Figure(resolution=(800,600))
    ax = GLMakie.Axis(fig[1,1], xlabel="Step", ylabel="Score d'amitié")

    # Pour chaque paire d'amis
    for ((i,j), _) in historique[1]
        scores = [h[(i,j)][1] for h in historique]  # intensité à chaque step
        GLMakie.lines!(ax, 1:length(scores), scores, label="Amis $i-$j")
    end

    GLMakie.Legend(fig[1,2], ax)
    display(fig)
end

# Tracer l’évolution des scores
plot_scores(historique)
