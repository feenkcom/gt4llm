Extension { #name : #GtLRequestResponse }

{ #category : #'*Gt4Llm-OpenAI' }
GtLRequestResponse >> extractOpenAIUsageDetails [ 
	| parsedResponse |
	(self response contentType sub = 'json') ifFalse: [ ^ nil ].
	
	parsedResponse := STONJSON fromString: self response contents.
	^(parsedResponse 
		at: 'usage'
		ifPresent: [ :each | GtLOpenAIMessageTokensData from: each ] 
		ifAbsent: [ nil ])
]

{ #category : #'*Gt4Llm-OpenAI' }
GtLRequestResponse >> resultOpenAIUsageDetails [ 
	self result ifNil: [ ^ nil ].

	^(result 
		at: 'usage'
		ifPresent: [ :each | GtLOpenAIMessageTokensData from: each ] 
		ifAbsent: [ nil ])
]
