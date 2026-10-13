Class {
	#name : #GtLCityBlockDistanceMetric,
	#superclass : #GtLDistanceMetric,
	#category : #'Gt4Llm-VectorDb'
}

{ #category : #accessing }
GtLCityBlockDistanceMetric class >> metricName [
	^ 'cityblock'
]

{ #category : #accessing }
GtLCityBlockDistanceMetric >> distanceFrom: anEmbedding to: aQueryEmbedding [
	| diff |
	diff := (anEmbedding - aQueryEmbedding) abs.
	^ diff sum
]
