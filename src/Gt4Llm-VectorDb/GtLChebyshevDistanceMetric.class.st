Class {
	#name : #GtLChebyshevDistanceMetric,
	#superclass : #GtLDistanceMetric,
	#category : #'Gt4Llm-VectorDb'
}

{ #category : #accessing }
GtLChebyshevDistanceMetric class >> metricName [
	^ 'chebyshev'
]

{ #category : #accessing }
GtLChebyshevDistanceMetric >> distanceFrom: anEmbedding to: aQueryEmbedding [
	| diff |
	diff := (anEmbedding - aQueryEmbedding) abs.
	^ diff max
]
