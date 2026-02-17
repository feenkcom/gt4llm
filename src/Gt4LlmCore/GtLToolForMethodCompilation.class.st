Class {
	#name : #GtLToolForMethodCompilation,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForMethodCompilation class >> leJsonV4Name [
	^ #gtLToolForMethodCompilation
]

{ #category : #visiting }
GtLToolForMethodCompilation >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForMethodCompilation: self
]

{ #category : #accessing }
GtLToolForMethodCompilation >> description [
	^ 'Compiles the provided method source code in the specified class or metaclass and reports the result.'
]

{ #category : #accessing }
GtLToolForMethodCompilation >> name [
	^ 'compileMethod'
]

{ #category : #accessing }
GtLToolForMethodCompilation >> parametersDescription [
	^ #('className' 'sourceCode' 'protocol' 'classSide')
]

{ #category : #private }
GtLToolForMethodCompilation >> privatePerformToolCall: aToolCall [
	| arguments className class classSideValue source protocol selector |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments
			at: 'className'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'className' ].
	class := className
			asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].
	classSideValue := arguments at: 'classSide' ifAbsent: [ false ].
	(classSideValue = true or: [ classSideValue asString = 'true' ])
		ifTrue: [ class := class class ].
	source := arguments
			at: 'sourceCode'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'sourceCode' ].
	source := source asString trimBoth.
	source isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'sourceCode' ].
	protocol := arguments at: 'protocol' ifAbsent: [ 'as yet unclassified' ].
	protocol := protocol ifNil: [ 'as yet unclassified' ].
	protocol := protocol asString.
	protocol isEmpty ifTrue: [ protocol := 'as yet unclassified' ].
	selector := [ [ class compile: source classified: protocol ]
			on: CodeError
			do: [ :notification | 
				^ GtLMethodCompilationExceptionDomainObject new
					freeze: notification;
					targetClass: class;
					protocolName: protocol;
					sourceCode: source;
					description: 'Syntax error while compiling given method source code' ] ]
			on: Error
			do: [ :error | 
				^ GtLMethodCompilationExceptionDomainObject new
					freeze: error;
					targetClass: class;
					protocolName: protocol;
					sourceCode: source;
					description: 'Compilation error while compiling given method source code' ].

	^ GtLMethodDomainObject new
		method: (class methodDict at: selector)
]
