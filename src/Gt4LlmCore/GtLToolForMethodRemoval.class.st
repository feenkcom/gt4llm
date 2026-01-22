Class {
	#name : #GtLToolForMethodRemoval,
	#superclass : #GtLAbstractFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #'as yet unclassified' }
GtLToolForMethodRemoval class >> leJsonV4Name [
	^ #gtLToolForMethodRemoval
]

{ #category : #accessing }
GtLToolForMethodRemoval >> description [
	^ 'Removes a method from the specified class. Provide the class name, method name, and optionally set classSide to true to remove class-side methods.'
]

{ #category : #accessing }
GtLToolForMethodRemoval >> name [
	^ 'removeMethod'
]

{ #category : #accessing }
GtLToolForMethodRemoval >> parameters [
	^ #('className' 'methodName' 'classSide')
]

{ #category : #execution }
GtLToolForMethodRemoval >> privatePerformToolCall: aToolCall [
	| arguments classNameValue classNameString classSymbol targetClass classSideValue classSide behavior methodNameValue methodNameString selector compiledMethod missingName |
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
	classSymbol := classNameString asSymbol.
	targetClass := Smalltalk globals
		at: classSymbol
		ifAbsent: [ ^ GtLMissingDomainObject new objectName: classNameString ].
	classSideValue := arguments at: 'classSide' ifAbsent: [ false ].
	classSide := classSideValue = true.
	classSide
		ifFalse: [ (classSideValue notNil and: [ classSideValue respondsTo: #asString ])
			ifTrue: [ classSide := classSideValue asString asLowercase = 'true' ] ].
	behavior := classSide
		ifTrue: [ targetClass class ]
		ifFalse: [ targetClass ].
	methodNameValue := arguments
		at: 'methodName'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'methodName' ].
	methodNameString := methodNameValue asString trimBoth.
	methodNameString isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'methodName' ].
	selector := methodNameString asSymbol.
	compiledMethod := behavior
		compiledMethodAt: selector
		ifAbsent: [
			missingName := behavior name asString , '>>' , methodNameString.
			^ GtLMissingDomainObject new objectName: missingName ].
	[ behavior removeSelector: selector ]
		on: Error
		do: [ :ex |
			^ GtLExceptionDomainObject new
				freeze: ex;
				description: 'Error while removing method';
				yourself ].
	^ GtLMethodDomainObject new method: compiledMethod
]
