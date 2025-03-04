Extension { #name : #GtLlmFineTuningFile }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmFineTuningFile >> costsForEpochs: anInteger [ 
	| numberOfTokens |
	numberOfTokens := self numberOfTokens * anInteger.
	
	"this model is free until september 23rd 2024 for under 2M tokens"
	((self model beginsWith: 'gpt-4o-mini')
		and: [ Date today
				< (Date
						year: 2024
						month: 9
						day: 23) and: [ numberOfTokens < 2000000 ] ])
		ifTrue: [ ^ GtTCurrencyMoney new
				amount: 0;
				currency: GtTCurrency usd ].

	^ GtTCurrencyMoney new
		amount: numberOfTokens * self pricePerToken;
		currency: GtTCurrency usd
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmFineTuningFile >> costsPerEpoch [
	| numberOfTokens |
	numberOfTokens := self numberOfTokens.
	
	"this model is free until september 23rd 2024 for under 2M tokens"
	((self model beginsWith: 'gpt-4o-mini')
		and: [ Date today
				< (Date
						year: 2024
						month: 9
						day: 23) and: [ numberOfTokens < 2000000 ] ])
		ifTrue: [ ^ GtTCurrencyMoney new
				amount: 0;
				currency: GtTCurrency usd ].

	^ GtTCurrencyMoney new
		amount: numberOfTokens * self pricePerToken;
		currency: GtTCurrency usd
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmFineTuningFile >> gtCostFor: aView [
	<gtView>
	^ aView forward
		title: 'Cost';
		priority: 3;
		object: [ self costsPerEpoch ];
		view: #gtDetailsFor:
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmFineTuningFile >> numberOfTokens [
	^ (GtLlmTokenizer new
		tokenizeMessages: (conversations flatCollect: #items)
		usingModel: self model) tokenCount
]
