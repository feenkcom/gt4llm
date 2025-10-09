Class {
	#name : #GtLlmToolForClassActions,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmToolForClassActions class >> leJsonV4Name [
	^ #gtLlmToolForClassActions
]

{ #category : #accessing }
GtLlmToolForClassActions >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassActions: self
]

{ #category : #accessing }
GtLlmToolForClassActions >> description [
	^ 'Gets a class by name and returns a list of its actions.'
]

{ #category : #accessing }
GtLlmToolForClassActions >> name [
	^ 'getClassActions'
]

{ #category : #accessing }
GtLlmToolForClassActions >> parameters [
	^ #('className')
]

{ #category : #accessing }
GtLlmToolForClassActions >> privatePerformToolCall: aToolCall [
	| argument class pragmas selectors |
	argument := aToolCall anyArgument.
	class := argument
		ifNil: [ nil ]
		ifNotNil: [ argument asClassIfAbsent: [ nil ] ].
	^ class
		ifNil: [ 'Class not found' ]
		ifNotNil: [ :targetClass |
			pragmas := Pragma allNamed: #gtAction from: targetClass toButExcluding: Object.
			pragmas isEmpty
				ifTrue: [ 'No actions found' ]
				ifFalse: [
					selectors := pragmas collect: [ :each | each method gtDisplayString ].
					Character cr join: selectors ] ]
]
