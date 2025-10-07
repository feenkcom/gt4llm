Class {
	#name : #GtLlmAbstractFunctionTool,
	#superclass : #GtLlmTool,
	#category : #'Gt4Llm-GToolkit-Tools'
}

{ #category : #accessing }
GtLlmAbstractFunctionTool class >> leJsonV4Name [
	^ #gtLlmAbstractFunctionTool
]

{ #category : #accessing }
GtLlmAbstractFunctionTool class >> serializationProperties [
	^ {#type -> #type. #function -> #function}
]

{ #category : #'as yet unclassified' }
GtLlmAbstractFunctionTool >> description [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmAbstractFunctionTool >> function [
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
GtLlmAbstractFunctionTool >> functionAnthropic [
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
GtLlmAbstractFunctionTool >> functionResponse [
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
GtLlmAbstractFunctionTool >> parameters [
	"An array of strings representing parameter names"
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLlmAbstractFunctionTool >> performToolCall: aToolCall [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLlmAbstractFunctionTool >> type [
	^ 'function'
]
