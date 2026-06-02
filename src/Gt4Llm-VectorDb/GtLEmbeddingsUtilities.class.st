Class {
	#name : #GtLEmbeddingsUtilities,
	#superclass : #Object,
	#category : #'Gt4Llm-VectorDb-Model'
}

{ #category : #accessing }
GtLEmbeddingsUtilities class >> defaultMetric [
	^ GtLlmCosineDistanceMetric new
]

{ #category : #distances }
GtLEmbeddingsUtilities class >> distanceFrom: anEmbedding to: aQueryEmbedding usingMetric: aMetric [
	^ aMetric distanceFrom: anEmbedding to: aQueryEmbedding
]

{ #category : #view }
GtLEmbeddingsUtilities class >> distanceMetrics [
	^ GtLlmDistanceMetric allSubclasses
]

{ #category : #distances }
GtLEmbeddingsUtilities class >> distancesFromEmbeddings: listOfEmbeddings to: anEmbedding [ 
	^ self distancesFromEmbeddings: listOfEmbeddings to: anEmbedding usingMetric: self defaultMetric
]

{ #category : #distances }
GtLEmbeddingsUtilities class >> distancesFromEmbeddings: listOfEmbeddings to: aQueryEmbedding usingMetric: aMetric [
	^ listOfEmbeddings
		collect: [ :anEmbedding | 
			GtLNearestEmbedding new
				distance: (self
						distanceFrom: anEmbedding embedding
						to: aQueryEmbedding embedding
						usingMetric: aMetric);
				embedding: anEmbedding ]
		as: GtLNearestEmbeddingGroup
]

{ #category : #view }
GtLEmbeddingsUtilities class >> gtDistanceMetricsFor: aView [
	<gtClassView>
	^ aView list
		title: 'Distance Metrics';
		priority: 50;
		items: [ self distanceMetrics ];
		itemText: [ :aClass | aClass metricName ]
]
