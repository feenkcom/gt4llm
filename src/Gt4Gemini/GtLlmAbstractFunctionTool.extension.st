Extension { #name : #GtLlmAbstractFunctionTool }

{ #category : #'*Gt4Gemini' }
GtLlmAbstractFunctionTool >> functionGemini [
	^ {'name' -> self name.
		'description' -> self description.
		'parameters'
			-> {'type' -> 'object'.
					'properties'
						-> (self parameters collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> self parameters} asDictionary} asDictionary
]
