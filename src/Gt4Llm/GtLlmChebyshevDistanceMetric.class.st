Class {
	#name : #GtLlmChebyshevDistanceMetric,
	#superclass : #GtLlmDistanceMetric,
	#category : #'Gt4Llm-Embeddings'
}

{ #category : #accessing }
GtLlmChebyshevDistanceMetric class >> metricName [
	^ 'chebyshev'
]

{ #category : #accessing }
GtLlmChebyshevDistanceMetric >> distanceFrom: anEmbedding to: aQueryEmbedding [
	| diff |
	diff := (anEmbedding - aQueryEmbedding) abs.
	^ diff max
]
