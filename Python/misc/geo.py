from geopy.distance import vincenty

jaragua = (-23.45833, -46.76527)
centro = (-23.5489, -46.6388)

print(vincenty(jaragua, centro).kilometers)
