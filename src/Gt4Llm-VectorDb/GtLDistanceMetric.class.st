Class {
	#name : #GtLDistanceMetric,
	#superclass : #Object,
	#category : #'Gt4Llm-VectorDb'
}

{ #category : #accessing }
GtLDistanceMetric class >> metricName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLDistanceMetric >> distanceFrom: anEmbedding to: aQueryEmbedding [
	^ self subclassResponsibility
]
