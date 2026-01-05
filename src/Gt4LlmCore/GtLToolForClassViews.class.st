Class {
	#name : #GtLToolForClassViews,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForClassViews class >> leJsonV4Name [
	^ #gtLToolForClassViews
]

{ #category : #accessing }
GtLToolForClassViews >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassViews: self
]

{ #category : #accessing }
GtLToolForClassViews >> description [
	^ 'Gets a class by name and returns a list of its views.'
]

{ #category : #accessing }
GtLToolForClassViews >> name [
	^ 'getClassViews'
]

{ #category : #accessing }
GtLToolForClassViews >> parameters [
	^ #('className')
]

{ #category : #accessing }
GtLToolForClassViews >> privatePerformToolCall: aToolCall [
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
