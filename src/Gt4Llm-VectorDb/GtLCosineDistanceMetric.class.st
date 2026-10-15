Class {
	#name : #GtLCosineDistanceMetric,
	#superclass : #GtLDistanceMetric,
	#category : #'Gt4Llm-VectorDb'
}

{ #category : #accessing }
GtLCosineDistanceMetric class >> metricName [
	^ 'cosine'
]

{ #category : #accessing }
GtLCosineDistanceMetric >> distanceFrom: anEmbedding to: aQueryEmbedding [
	^ ((GtLCorrelationDistanceMetric new distanceFrom: anEmbedding to: aQueryEmbedding) min: 2.0)
		max: 0
]
