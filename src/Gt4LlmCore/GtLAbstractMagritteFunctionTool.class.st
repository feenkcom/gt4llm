Class {
	#name : #GtLAbstractMagritteFunctionTool,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #testing }
GtLAbstractMagritteFunctionTool class >> isAbstract [
	^ self name = #GtLAbstractMagritteFunctionTool
]

{ #category : #accessing }
GtLAbstractMagritteFunctionTool >> computeParametersFormat [
	^ self parametersDescription
]

{ #category : #'as yet unclassified' }
GtLAbstractMagritteFunctionTool >> gtMagritteFor: aView [
	"do not show the view"
	^ aView	empty
]

{ #category : #utils }
GtLAbstractMagritteFunctionTool >> parametersDescription [
	^ GtLResponseMagritteFormat new
			name: 'Parameters';
			modelClass: self class
]

{ #category : #utils }
GtLAbstractMagritteFunctionTool >> performToolCall: aToolCall [
	| domainObject resultObject |
	
	[ | arguments |
		arguments := self parametersDescription 
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
