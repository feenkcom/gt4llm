Extension { #name : #GtLlmFunctionTool }

{ #category : #'*Gt4Anthropic' }
GtLlmFunctionTool >> functionAnthropic [
	^ {'name' -> name.
		'description' -> self description.
		'input_schema'
			-> {'type' -> 'object'.
					'properties'
						-> (parameters collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> parameters} asDictionary} asDictionary
]
