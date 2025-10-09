Class {
	#name : #GtLlmToolForClassViews,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForClassViews class >> leJsonV4Name [
	^ #gtLlmToolForClassViews
]

{ #category : #accessing }
GtLlmToolForClassViews >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassViews: self
]

{ #category : #accessing }
GtLlmToolForClassViews >> description [
	^ 'Gets a class by name and returns a list of its views.'
]

{ #category : #accessing }
GtLlmToolForClassViews >> name [
	^ 'getClassViews'
]

{ #category : #accessing }
GtLlmToolForClassViews >> parameters [
	^ #('className')
]

{ #category : #accessing }
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
