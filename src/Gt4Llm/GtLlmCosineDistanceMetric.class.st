Class {
	#name : #GtLlmCosineDistanceMetric,
	#superclass : #GtLlmDistanceMetric,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmCosineDistanceMetric class >> metricName [
	^ 'cosine'
]

{ #category : #accessing }
GtLlmCosineDistanceMetric >> distanceFrom: anEmbedding to: aQueryEmbedding [
	^ ((GtLlmCorrelationDistanceMetric new distanceFrom: anEmbedding to: aQueryEmbedding) min: 2.0)
		max: 0
]
