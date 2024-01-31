Class {
	#name : #Gt4OpenEmbeddingsList,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenEmbeddingsList class >> from: aList [
	^ self
		withAll: ((aList at: 'data')
				collect: [ :aModel | Gt4OpenAIEmbedding from: (aModel at: 'embedding') ])
]

{ #category : #accessing }
Gt4OpenEmbeddingsList >> gtEmbeddingsFor: aView [
	<gtView>
	
	^ aView columnedList title: 'Embeddings';
	priority: 1; items: [self items];
	column: 'Size' text: #size
]
