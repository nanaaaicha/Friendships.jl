
 
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