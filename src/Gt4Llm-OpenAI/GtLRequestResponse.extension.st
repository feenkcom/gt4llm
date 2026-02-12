Extension { #name : #GtLRequestResponse }

{ #category : #'*Gt4Llm-OpenAI' }
GtLRequestResponse >> resultUsageDetails [ 
	self result ifNil: [ ^ nil ].

	^(result 
		at: 'usage'
		ifPresent: [ :each | GtLMessageTokensData from: each ] 
		ifAbsent: [ nil ])
]
