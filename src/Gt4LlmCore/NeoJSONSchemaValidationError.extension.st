Extension { #name : #NeoJSONSchemaValidationError }

{ #category : #'*Gt4LlmCore' }
NeoJSONSchemaValidationError >> asGtLErrorReturnObject [
	(self message beginsWith: 'required properties missing')
		ifTrue: [
			^ GtLMissingRequiredPropertiesDomainObject new
				path: (self location ifNil: [ { nil } ] ifNotNil: [ :aLocation | aLocation asArray ]);
				errorMessage: self messageText;
				missingPropertyNames: (((((message 
					removePrefix: 'required properties missing') trimBoth
					removePrefix: '[')
					removeSuffix: ']') splitOn: $,)
						collect: [ :each | each trimBoth ]) asArray ].
	^ GtLJSONSchemaValidationErrorDomainObject new 
			path: (self location ifNil: [ { nil } ] ifNotNil: [ :aLocation | aLocation asArray ]);
			errorMessage: self messageText
]
