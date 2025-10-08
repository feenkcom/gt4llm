Class {
	#name : #GtLlmToolForClassViews,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmToolForClassViews class >> leJsonV4Name [
	^ #gtLlmToolForClassViews
]

{ #category : #'llm-generated' }
GtLlmToolForClassViews >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassViews: self
]

{ #category : #'llm-generated' }
GtLlmToolForClassViews >> description [
	^ 'Gets a class by name and returns a list of its views.'
]

{ #category : #'llm-generated' }
GtLlmToolForClassViews >> name [
	^ 'getClassViews'
]

{ #category : #'llm-generated' }
GtLlmToolForClassViews >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLlmToolForClassViews >> privatePerformToolCall: aToolCall [
	| argument class pragmas selectors |
	argument := aToolCall anyArgument.
	class := argument
		ifNil: [ nil ]
		ifNotNil: [ argument asClassIfAbsent: [ nil ] ].
	^ class
		ifNil: [ 'Class not found' ]
		ifNotNil: [ :targetClass |
			pragmas := Pragma allNamed: #gtView from: targetClass toButExcluding: Object.
			pragmas isEmpty
				ifTrue: [ 'No views found' ]
				ifFalse: [
					selectors := pragmas collect: [ :each | each method gtDisplayString ].
					Character cr join: selectors ] ]
]
