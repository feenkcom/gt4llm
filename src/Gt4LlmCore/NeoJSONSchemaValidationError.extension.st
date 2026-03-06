Extension { #name : #NeoJSONSchemaValidationError }

{ #category : #'*Gt4LlmCore' }
NeoJSONSchemaValidationError >> asGtLErrorReturnObject [
	(self message beginsWith: 'required properties missing')
		ifTrue: [
			^ GtLMissingRequiredPropertiesDomainObject new
				path: self location asArray;
				errorMessage: self messageText;
				missingPropertyNames: (((((message 
					removePrefix: 'required properties missing') trimBoth
					removePrefix: '[')
					removeSuffix: ']') splitOn: '', '')
						collect: [ :each | each trimBoth ]) ].
	^ GtLJSONSchemaValidationErrorDomainObject new 
			path: self location asArray;
			errorMessage: self messageText
]
