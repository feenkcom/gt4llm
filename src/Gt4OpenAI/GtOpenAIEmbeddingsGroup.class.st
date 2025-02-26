Class {
	#name : #GtOpenAIEmbeddingsGroup,
	#superclass : #GtOpenAIGroup,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIEmbeddingsGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data')
				collect: [ :aModel | GtOpenAIEmbedding from: (aModel at: 'embedding') ])
]

{ #category : #accessing }
GtOpenAIEmbeddingsGroup >> gtEmbeddingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Embeddings';
		priority: 1;
		items: [ self items withIndexCollect: [ :anItem :anIndex | anIndex -> anItem ] ];
		column: 'Index'
			text: [ :aPair | aPair key asRopedText foreground: BrGlamorousColors disabledButtonTextColor ]
			width: 50;
		column: 'Size' text: [ :aPair | aPair value size ];
		send: #value
]
