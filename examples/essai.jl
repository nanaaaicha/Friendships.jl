
 
using Friendships     
import Friendships: Population, Person, relationships!, similarity,poids0,poidsM,store, influence!

pop = Population(10)           # 10 personnes


relationships!(pop, 0.3)      # 40% de chance de créer une amitié

# Afficher la population
println(pop)

scores = poids0(pop)
for ((p1,p2),(intensity,delta)) in scores
    println("Amitié ($p1,$p2) : intensité=$(intensity), delta=$(delta)")
end



poidsM(scores, pop; alpha=0.7, beta=0.2, gamma=0.1)
for ((p1,p2),(intensity,delta)) in scores
    println("Amitié ($p1, $p2) : intensité=$intensity, delta=$delta")
end



historique = store(pop, 10)  # 10 étapes


historique = store(pop, 50)   
p1 = pop[1]
p2 = pop[2]
poids=poids0(pop)

println("Avant influence !")
println("Personne $(p1.id) émotions = $(p1.emotions)")
println("Personne $(p2.id) émotions = $(p2.emotions)")

influence!(p1, p2, poids)

# Affiche après influence
println("Après influence !")
println("Personne $(p1.id) émotions = $(p1.emotions)")
println("Personne $(p2.id) émotions = $(p2.emotions)")

#je vais revoir ça parce que mes personnes ont les memes traits