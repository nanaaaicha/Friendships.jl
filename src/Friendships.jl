# Module pour gérer les personnes et leurs amitiés
module Friendships

using Random
using LinearAlgebra: norm

export Population, relationships!,similarity,poids0,poidsM,store,influence!


 

include("evolution.jl")

end
 # module
