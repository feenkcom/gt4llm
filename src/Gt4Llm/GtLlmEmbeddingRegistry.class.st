Class {
	#name : #GtLlmEmbeddingRegistry,
	#superclass : #Object,
	#instVars : [
		'embeddings'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmEmbeddingRegistry class >> cleanUniqueInstance [
	uniqueInstance := nil.
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddingRegistry class >> cleanUp [
	self cleanUniqueInstance
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddingRegistry class >> default [
	^ self uniqueInstance
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddingRegistry class >> hasUniqueInstance [

	^ uniqueInstance isNotNil
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddingRegistry class >> instance [
	<gtExample>
	^ self uniqueInstance
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddingRegistry class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #accessing }
GtLlmEmbeddingRegistry >> at: anInput [
	^ embeddings at: anInput
]

{ #category : #accessing }
GtLlmEmbeddingRegistry >> at: anInput ifAbsent: aBlock [
	^ embeddings at: anInput ifAbsent: aBlock
]

{ #category : #accessing }
GtLlmEmbeddingRegistry >> at: anInput ifAbsentCreateEmbedding: aBlock [
	^ embeddings
		at: anInput
		ifAbsent: [ self
				put: (GtLlmEmbedding new
						input: anInput;
						embedding: aBlock value) ]
]

{ #category : #accessing }
GtLlmEmbeddingRegistry >> findNearest: aNumber for: anEmbedding [
	^ self
		findNearest: aNumber
		for: anEmbedding
		usingMetric: GtLlmEmbeddingsUtilities defaultMetric
]

{ #category : #accessing }
GtLlmEmbeddingRegistry >> findNearest: aNumber for: anEmbedding usingMetric: aString [
	| embeddingsWithDistances sortedByDistance |
	embeddingsWithDistances := GtLlmEmbeddingsUtilities
			distancesFromEmbeddings: (embeddings
					reject: [ :embedding | embedding input = anEmbedding input ]) values
			to: anEmbedding
			usingMetric: aString.

	sortedByDistance := embeddingsWithDistances
			sorted: [ :a :b | a distance < b distance ].

	sortedByDistance size > aNumber
		ifTrue: [ sortedByDistance := sortedByDistance first: aNumber ].

	^ GtLlmNearestEmbeddingsGroup withAll: sortedByDistance
]

{ #category : #accessing }
GtLlmEmbeddingRegistry >> initialize [
	embeddings := Dictionary new
]

{ #category : #accessing }
GtLlmEmbeddingRegistry >> put: anEmbedding [
	^ embeddings at: anEmbedding input put: anEmbedding
]

{ #category : #accessing }
GtLlmEmbeddingRegistry >> reset [
	embeddings := Dictionary new
]
