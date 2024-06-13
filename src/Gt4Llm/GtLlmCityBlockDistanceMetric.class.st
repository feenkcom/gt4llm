Class {
	#name : #GtLlmCityBlockDistanceMetric,
	#superclass : #GtLlmDistanceMetric,
	#category : #'Gt4Llm-Embeddings'
}

{ #category : #accessing }
GtLlmCityBlockDistanceMetric class >> metricName [
	^ 'cityblock'
]

{ #category : #accessing }
GtLlmCityBlockDistanceMetric >> distanceFrom: anEmbedding to: aQueryEmbedding [
	| diff |
	diff := (anEmbedding - aQueryEmbedding) abs.
	^ diff sum
]
