Class {
	#name : #GtLlmEmbeddingsUtilities,
	#superclass : #Object,
	#category : #'Gt4Llm-Embeddings'
}

{ #category : #distances }
GtLlmEmbeddingsUtilities class >> distanceFrom: anEmbedding to: aQueryEmbedding usingMetric: aMetric [
	^ self
		perform: #distance , aMetric , 'From:to:'
		withArguments: {anEmbedding.
				aQueryEmbedding}
]

{ #category : #view }
GtLlmEmbeddingsUtilities class >> distanceMetrics [
	^ Pragma allNamed: #distanceMetric: in: self class
]

{ #category : #distances }
GtLlmEmbeddingsUtilities class >> distancecorrelationFrom: anEmbedding to: aQueryEmbedding [
	<distanceMetric: 'correlation'>
	| uv uu vv dist |
	uv := anEmbedding dot: aQueryEmbedding.
	uu := anEmbedding dot: anEmbedding.
	vv := aQueryEmbedding dot: aQueryEmbedding.
	dist := (1.0 - uv) / (uu * vv) sqrt.
	^ dist abs
]

{ #category : #distances }
GtLlmEmbeddingsUtilities class >> distancecosineFrom: anEmbedding to: aQueryEmbedding [
	<distanceMetric: 'cosine'>
	^ ((self distancecorrelationFrom: anEmbedding to: aQueryEmbedding) min: 2.0)
		max: 0
]

{ #category : #distances }
GtLlmEmbeddingsUtilities class >> distancesFromEmbeddings: listOfEmbeddings to: anEmbedding [ 
	^ self distancesFromEmbeddings: listOfEmbeddings to: anEmbedding usingMetric: 'cosine'
]

{ #category : #distances }
GtLlmEmbeddingsUtilities class >> distancesFromEmbeddings: listOfEmbeddings to: aQueryEmbedding usingMetric: aMetric [
	^ listOfEmbeddings
		collect: [ :anEmbedding | 
			(self
				distanceFrom: anEmbedding embedding
				to: aQueryEmbedding embedding
				usingMetric: aMetric) -> anEmbedding ]
]

{ #category : #view }
GtLlmEmbeddingsUtilities class >> gtDistanceMetricsFor: aView [
	<gtClassView>
	^ aView list
		title: 'Distance Metrics';
		priority: 50;
		items: [ self distanceMetrics ];
		itemText: [ :aPragma | aPragma arguments first ];
		send: [ :aPragma | aPragma method ]
]

{ #category : #accessing }
GtLlmEmbeddingsUtilities class >> yourself [
	<gtExample>
	^ self
]
