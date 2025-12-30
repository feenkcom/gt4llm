Class {
	#name : #GtLToolForClassActions,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLToolForClassActions class >> leJsonV4Name [
	^ #gtLlmToolForClassActions
]

{ #category : #accessing }
GtLToolForClassActions >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassActions: self
]

{ #category : #accessing }
GtLToolForClassActions >> description [
	^ 'Gets a class by name and returns a list of its actions.'
]

{ #category : #accessing }
GtLToolForClassActions >> name [
	^ 'getClassActions'
]

{ #category : #accessing }
GtLToolForClassActions >> parameters [
	^ #('className')
]

{ #category : #accessing }
GtLToolForClassActions >> privatePerformToolCall: aToolCall [
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
