Extension { #name : #Exception }

{ #category : #'*Gt4LlmCore' }
Exception >> serializeToOpenAIResponseData [
	^ "GtLPrimitiveCompositeData with:" (GtLPrimitiveDictionaryData 
		for: (NeoJSONObject new
			at: #exception put: (GtLValueSerializer new
				serializeValue: self);
			at: #stacktrace put: (self signalerContext
				ifNotNil: [ :anInterruptedContext | 
					anInterruptedContext stack
						ifNotNil: [ :aStack | (aStack collect: #gtDisplayString) asArray ] ]);
						yourself ))
]

{ #category : #'*Gt4LlmCore' }
Exception >> serializeToOpenAIResponseImages [
	^{}
]
