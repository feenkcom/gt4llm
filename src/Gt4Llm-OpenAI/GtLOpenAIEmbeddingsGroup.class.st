Class {
	#name : #GtLOpenAIEmbeddingsGroup,
	#superclass : #GtLOpenAIGroup,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIEmbeddingsGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data')
				collect: [ :aModel | GtLOpenAIEmbedding from: (aModel at: 'embedding') ])
]

{ #category : #'gt - extensions' }
GtLOpenAIEmbeddingsGroup >> gtEmbeddingsFor: aView [
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
