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
GtLAbstractFunctionTool class >> serializationProperties [
	^ {#type -> #type. }
]

{ #category : #accessing }
GtLAbstractFunctionTool >> computeParametersFormat [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLAbstractFunctionTool >> description [
	^ self subclassResponsibility
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionAnthropic [
	^ {'name' -> self name.
		'description' -> self description.
		'input_schema' -> self parametersJsonSchemaDictionary} asDictionary
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionGemini [
	^ {'name' -> self name.
		'description' -> self description.
		'parameters' -> self parametersJsonSchemaDictionary} asDictionary
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> functionOpenAI [
	^ {'name' -> self name.
		'type' -> self type.
		'description' -> self description.
		'parameters' -> self parametersJsonSchemaDictionary} asDictionary
]

{ #category : #'api - responses' }
GtLAbstractFunctionTool >> parametersJsonSchemaDictionary [
	| parametersFormat |
	parametersFormat := self computeParametersFormat.
	^ parametersFormat asJsonSchemaDictionary
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
