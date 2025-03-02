Class {
	#name : #GtLlmDistanceMetric,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmDistanceMetric class >> metricName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmDistanceMetric >> distanceFrom: anEmbedding to: aQueryEmbedding [
	^ self subclassResponsibility
]
