Class {
	#name : #GtLlmEmbeddingRegistry,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'embeddings'
	],
	#category : #'Gt4Llm-Embeddings'
}

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

	sortedByDistance := (embeddingsWithDistances sorted: [ :a :b | a distance < b distance ]).

	^ GtLlmNearestEmbeddingsGroup withAll: (sortedByDistance first: aNumber)
]

{ #category : #accessing }
GtLlmEmbeddingRegistry >> gtEmbeddingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Embeddings';
		priority: 1;
		items: [ embeddings associations ];
		column: 'Input' text: [ :aPair | aPair value input ];
		column: 'Actions'
			stencil: [ :aPair | 
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					label: 'Remove';
					icon: BrGlamorousVectorIcons remove;
					action: [ :aButton | 
						embeddings removeKey: aPair key.
						aButton phlow fireUpdateWish ] ]
			width: 80;
		send: #value
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
