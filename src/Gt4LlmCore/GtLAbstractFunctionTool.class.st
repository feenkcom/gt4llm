Class {
	#name : #GtLAbstractFunctionTool,
	#superclass : #GtLTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLAbstractFunctionTool class >> leJsonV4Name [
	^ #gtLAbstractFunctionTool
]

{ #category : #accessing }
GtLAbstractFunctionTool class >> serializationProperties [
	^ {#type -> #type. #function -> #function}
]

{ #category : #'as yet unclassified' }
GtLAbstractFunctionTool >> description [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLAbstractFunctionTool >> function [
	^ {'name' -> self name.
		'description' -> self description.
		'parameters'
			-> {'type' -> 'object'.
					'properties'
						-> (self parameters collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> self parameters.
					'additionalProperties' -> false} asDictionary.
		'strict' -> true} asDictionary
]

{ #category : #'as yet unclassified' }
GtLAbstractFunctionTool >> functionAnthropic [
	^ {'name' -> self name.
		'description' -> self description.
		'input_schema'
			-> {'type' -> 'object'.
					'properties'
						-> (self parameters collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> self parameters} asDictionary} asDictionary
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
GtLAbstractFunctionTool >> functionResponse [
	^ {'name' -> self name.
		'type' -> self type.
		'description' -> self description.
		'parameters'
			-> {'type' -> 'object'.
					'properties'
						-> (self parameters
								collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> self parameters.
					'additionalProperties' -> false} asDictionary} asDictionary
]

{ #category : #'as yet unclassified' }
GtLAbstractFunctionTool >> parameters [
	"An array of strings representing parameter names"
	^ self subclassResponsibility
]

{ #category : #'llm-generated' }
GtLAbstractFunctionTool >> performToolCall: aToolCall [
	| result |
	aToolCall performedByTool: self.
	result := self privatePerformToolCall: aToolCall.
	aToolCall result: result.
	^ result
]

{ #category : #'llm-generated' }
GtLAbstractFunctionTool >> privatePerformToolCall: aToolCall [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLAbstractFunctionTool >> type [
	^ 'function'
]
