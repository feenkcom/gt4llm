Class {
	#name : #GtLToolForMethodSource,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForMethodSource class >> leJsonV4Name [
	^ #gtLlmToolForMethodSource
]

{ #category : #accessing }
GtLToolForMethodSource >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForMethodSource: self
]

{ #category : #accessing }
GtLToolForMethodSource >> description [
	^ 'Gets a method by name and returns its source code. The third argument (classSide) should be true if the method is on the class side. It should be false if the method if on the instance side.'
]

{ #category : #accessing }
GtLToolForMethodSource >> name [
	^ 'getCodeOfMethod'
]

{ #category : #accessing }
GtLToolForMethodSource >> parameters [
	^ #('className' 'methodName' 'classSide')
]

{ #category : #accessing }
GtLToolForMethodSource >> privatePerformToolCall: aToolCall [
	| arguments className class methodName classSideValue methodSymbol method |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments at: 'className' ifAbsent: [ ^ 'Class name not provided' ].
	class := className asClassIfAbsent: [ ^ 'Class not found' ].
	methodName := arguments at: 'methodName' ifAbsent: [ ^ 'Method name not provided' ].
	classSideValue := arguments at: 'classSide' ifAbsent: [ false ].
	((classSideValue = true) or: [ classSideValue asString = 'true' ]) ifTrue: [ class := class class ].
	methodSymbol := methodName asSymbol.
	^ class allMethods
		detect: [ :each | each selector = methodSymbol ]
		ifFound: [ :m | m sourceCode ]
		ifNone: [ ^ 'Method not found' ]
]
