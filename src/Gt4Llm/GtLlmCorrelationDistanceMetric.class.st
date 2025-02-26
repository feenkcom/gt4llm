Class {
	#name : #GtLlmCorrelationDistanceMetric,
	#superclass : #GtLlmDistanceMetric,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmCorrelationDistanceMetric class >> metricName [
	^ 'correlation'
]

{ #category : #accessing }
GtLlmCorrelationDistanceMetric >> distanceFrom: anEmbedding to: aQueryEmbedding [
	| uv uu vv dist |
	uv := anEmbedding dot: aQueryEmbedding.
	uu := anEmbedding dot: anEmbedding.
	vv := aQueryEmbedding dot: aQueryEmbedding.
	dist := (1.0 - uv) / (uu * vv) sqrt.
	^ dist abs
]
