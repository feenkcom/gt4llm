Class {
	#name : #GtLToolForMethodSource,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForMethodSource class >> leJsonV4Name [
	^ #gtLToolForMethodSource
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
	| arguments className class methodName isClassSide methodSymbol method |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments
			at: 'className'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'className' ].
	class := className
			asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].
	methodName := arguments
			at: 'methodName'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'methodName' ].
	isClassSide := arguments
			at: 'classSide'
			ifPresent: [ :aValue | #(true 'true' 't') includes: aValue ]
			ifAbsent: [ false ].
	isClassSide ifTrue: [ class := class class ].
	methodSymbol := methodName asSymbol.
	method := class lookupSelector: methodSymbol.
	method
		ifNil: [ ^ GtLMissingDomainObject new
				objectName: ('{1}{2}>>#{3}'
						format: {className.
								isClassSide ifTrue: [ ' class' ] ifFalse: [ '' ].
								methodName}) ].
	^ GtLMethodDomainObject new method: method
]
