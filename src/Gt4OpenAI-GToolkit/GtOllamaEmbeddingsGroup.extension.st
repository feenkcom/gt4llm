Extension { #name : #GtOllamaEmbeddingsGroup }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOllamaEmbeddingsGroup >> gtEmbeddingsFor: aView [
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
