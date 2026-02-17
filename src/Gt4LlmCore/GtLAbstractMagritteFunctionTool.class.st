Class {
	#name : #GtLAbstractMagritteFunctionTool,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #testing }
GtLAbstractMagritteFunctionTool class >> isAbstract [
	^ self name = #GtLAbstractMagritteFunctionTool
]

{ #category : #utils }
GtLAbstractMagritteFunctionTool >> parametersFormat [
	^ GtLResponseMagritteFormat new
			name: 'Parameters';
			modelClass: self class
]

{ #category : #utils }
GtLAbstractMagritteFunctionTool >> performToolCall: aToolCall [
	| domainObject resultObject |
	
	[ | arguments |
		arguments := self parametersFormat 
			readGenericDomainObjectsFrom: aToolCall rawArgumentsJsonString.
		aToolCall arguments: arguments  ]
		on: NeoJSONParseError
		do: [ :e | 
			Error signal: 'to handle'.
			aToolCall result: e.
			^ e ] .
	
	aToolCall performedByTool: self.
	domainObject := self privatePerformToolCall: aToolCall.
	resultObject := GtLMagritteInputModel new 
		name: 'Response';
		model: domainObject.
	aToolCall result: resultObject.
	
	^ resultObject
]
