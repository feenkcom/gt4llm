Class {
	#name : #GtLlmToolForClassReferences,
	#superclass : #GtLlmTool,
	#category : #'Gt4Llm-GToolkit-Tools'
}

{ #category : #accessing }
GtLlmToolForClassReferences class >> leJsonV4Name [

	^ #gtLlmToolForClassReferences
]

{ #category : #accessing }
GtLlmToolForClassReferences class >> serializationProperties [
	^ {#type -> #type. #function -> #function}
]

{ #category : #'as yet unclassified' }
GtLlmToolForClassReferences >> description [
	^ 'Search the image for the references to the given class'
]

{ #category : #'as yet unclassified' }
GtLlmToolForClassReferences >> functionResponse [
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
GtLlmToolForClassReferences >> name [
	^ 'classReferences'
]

{ #category : #'as yet unclassified' }
GtLlmToolForClassReferences >> parameters [
	^ #('className')
]

{ #category : #'as yet unclassified' }
GtLlmToolForClassReferences >> performToolCall: aToolCall [
	| class |
	class := aToolCall anyArgument asSymbol asClassIfAbsent: [ nil ].
	^ class
		ifNil: [ 'Class not found' ]
		ifNotNil: [ :c | Character cr join: (c gtReferences result toArray wait collect: #name) ]
]

{ #category : #'as yet unclassified' }
GtLlmToolForClassReferences >> type [
	^ 'function'
]
