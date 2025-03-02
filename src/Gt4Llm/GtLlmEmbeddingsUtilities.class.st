Class {
	#name : #GtLlmEmbeddingsUtilities,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmEmbeddingsUtilities class >> defaultMetric [
	^ GtLlmCosineDistanceMetric new
]

{ #category : #distances }
GtLlmEmbeddingsUtilities class >> distanceFrom: anEmbedding to: aQueryEmbedding usingMetric: aMetric [
	^ aMetric distanceFrom: anEmbedding to: aQueryEmbedding
]

{ #category : #view }
GtLlmEmbeddingsUtilities class >> distanceMetrics [
	^ GtLlmDistanceMetric allSubclasses
]

{ #category : #distances }
GtLlmEmbeddingsUtilities class >> distancesFromEmbeddings: listOfEmbeddings to: anEmbedding [ 
	^ self distancesFromEmbeddings: listOfEmbeddings to: anEmbedding usingMetric: self defaultMetric
]

{ #category : #distances }
GtLlmEmbeddingsUtilities class >> distancesFromEmbeddings: listOfEmbeddings to: aQueryEmbedding usingMetric: aMetric [
	^ listOfEmbeddings
		collect: [ :anEmbedding | 
			GtLlmNearestEmbedding new
				distance: (self
						distanceFrom: anEmbedding embedding
						to: aQueryEmbedding embedding
						usingMetric: aMetric);
				embedding: anEmbedding ]
]

{ #category : #view }
GtLlmEmbeddingsUtilities class >> gtDistanceMetricsFor: aView [
	<gtClassView>
	^ aView list
		title: 'Distance Metrics';
		priority: 50;
		items: [ self distanceMetrics ];
		itemText: [ :aClass | aClass metricName ]
]

{ #category : #accessing }
GtLlmEmbeddingsUtilities class >> yourself [
	<gtExample>
	^ self
]
