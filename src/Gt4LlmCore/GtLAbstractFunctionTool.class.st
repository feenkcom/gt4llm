Class {
	#name : #GtLAbstractFunctionTool,
	#superclass : #GtLTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #testiung }
GtLAbstractFunctionTool class >> isAbstract [
	^ self name = #GtLAbstractFunctionTool
]

{ #category : #accessing }
GtLAbstractFunctionTool class >> leJsonV4Name [
	^ #gtLAbstractFunctionTool
]

{ #category : #accessing }
GtLAbstractFunctionTool class >> serializationProperties [
	^ {#type -> #type. #function -> #functionResponse}
]

{ #category : #accessing }
GtLAbstractFunctionTool >> description [
	^ self subclassResponsibility
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionAnthropic [
	^ {'name' -> self name.
		'description' -> self description.
		'input_schema' -> self functionJsonSchema} asDictionary
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionGemini [
	^ {'name' -> self name.
		'description' -> self description.
		'parameters'
			-> {'type' -> 'object'.
					'properties'
						-> (self parameters collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> self parameters} asDictionary} asDictionary
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionJsonSchema [
	| parametersFormat |
	parametersFormat := self parametersFormat.
	^ parametersFormat asJsonSchemaDictionary
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionResponse [
	^ {'name' -> self name.
		'type' -> self type.
		'description' -> self description.
		'parameters' -> self functionJsonSchema} asDictionary
]

{ #category : #accessing }
GtLAbstractFunctionTool >> parameters [
	"An array of strings representing parameter names"
	^ self subclassResponsibility
]

{ #category : #utils }
GtLAbstractFunctionTool >> parametersFormat [
	| parametersFormat |
	
	parametersFormat := GtLResponseCompositeFormat new.
	self parameters do: [ :aParameterFormatOrString | 
		| parameterFormat |
		parameterFormat := aParameterFormatOrString isString
			ifTrue: [ GtLResponseStringFormat named: aParameterFormatOrString  ] 
			ifFalse: [ aParameterFormatOrString ].
		parametersFormat addSchemaDescription: parameterFormat ].
	
	^ parametersFormat
]

{ #category : #execution }
GtLAbstractFunctionTool >> performToolCall: aToolCall [
	| result |
	aToolCall performedByTool: self.
	result := self privatePerformToolCall: aToolCall.
	aToolCall result: result.
	^ result
]

{ #category : #execution }
GtLAbstractFunctionTool >> privatePerformToolCall: aToolCall [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLAbstractFunctionTool >> type [
	^ 'function'
]
