Class {
	#name : #GtLCorrelationDistanceMetric,
	#superclass : #GtLDistanceMetric,
	#category : #'Gt4Llm-VectorDb'
}

{ #category : #accessing }
GtLCorrelationDistanceMetric class >> metricName [
	^ 'correlation'
]

{ #category : #accessing }
GtLCorrelationDistanceMetric >> distanceFrom: anEmbedding to: aQueryEmbedding [
	| uv uu vv dist |
	uv := anEmbedding dot: aQueryEmbedding.
	uu := anEmbedding dot: anEmbedding.
	vv := aQueryEmbedding dot: aQueryEmbedding.
	dist := (1.0 - uv) / (uu * vv) sqrt.
	^ dist abs
]
