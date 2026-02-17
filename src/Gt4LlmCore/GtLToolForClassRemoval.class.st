Class {
	#name : #GtLToolForClassRemoval,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLToolForClassRemoval class >> leJsonV4Name [
	^ #gtLToolForClassRemoval
]

{ #category : #accessing }
GtLToolForClassRemoval >> description [
	^ 'Removes the class with the provided name from the image.'
]

{ #category : #accessing }
GtLToolForClassRemoval >> name [
	^ 'removeClass'
]

{ #category : #accessing }
GtLToolForClassRemoval >> parametersDescription [
	^ #('className')
]

{ #category : #execution }
GtLToolForClassRemoval >> privatePerformToolCall: aToolCall [
	| arguments classNameValue classNameString class removalResult |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	classNameValue := arguments
		at: 'className'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'className' ].
	classNameString := classNameValue asString trimBoth.
	classNameString isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'className' ].
	class := Smalltalk globals
		at: classNameString asSymbol
		ifAbsent: [ ^ GtLMissingDomainObject new objectName: classNameString ].
	[ class removeFromSystem ]
		on: Error
		do: [ :ex |
			^ GtLExceptionDomainObject new
				freeze: ex;
				description: 'Error while removing class';
				yourself ].
	removalResult := {
		'removedClassName' -> classNameString.
		'status' -> 'removed'
	} asDictionary.
	^ GtLValueDomainObject new value: removalResult
]
