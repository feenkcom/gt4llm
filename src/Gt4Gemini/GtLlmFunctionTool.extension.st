Extension { #name : #GtLlmFunctionTool }

{ #category : #'*Gt4Gemini' }
GtLlmFunctionTool >> functionGemini [
	^ {'name' -> name.
		'description' -> self description.
		'parameters'
			-> {'type' -> 'object'.
					'properties'
						-> (parameters collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> parameters} asDictionary} asDictionary
]
