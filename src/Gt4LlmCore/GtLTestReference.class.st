"
Reference to a test method, used as a parameter for the Magritte-based test method run tool. Unlike GtLExampleReference, tests cannot be on the class side.
"
Class {
	#name : #GtLTestReference,
	#superclass : #Object,
	#instVars : [
		'testClassName',
		'methodName'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLTestReference >> compiledMethod [
	^ self testClass >> self methodName asSymbol
]

{ #category : #resolving }
GtLTestReference >> compiledMethodIfPresent: aPresentBlock ifMissing: anErrorBlock [
	| targetClass methodSymbol method |
	
	targetClass := self testClassName
		asClassIfAbsent: [ 
			^ anErrorBlock 
				value: (GtLMissingDomainObject new 
						objectName: self testClassName) ].

	(targetClass isTestCase)
		ifFalse: [ ^ anErrorBlock
				value: (GtLIncorrectArgumentTypeDomainObject new
					argumentName: 'testClassName';
					argumentValue: self testClassName;
					expectedArgumentValueKind: 'a subclass of TestCase') ].
	
	methodSymbol := self methodName asSymbol.
	method := targetClass lookupSelector: methodSymbol.
	method ifNil: [ ^ anErrorBlock 
			value:  (GtLMissingDomainObject new
				objectName: self methodSignature) ].
						
	^ aPresentBlock value: method value: targetClass
]

{ #category : #accessing }
GtLTestReference >> methodName [
	^ methodName
]

{ #category : #accessing }
GtLTestReference >> methodName: anObject [
	methodName := anObject
]

{ #category : #'magritte description' }
GtLTestReference >> methodNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodName;
		beRequired
]

{ #category : #accessing }
GtLTestReference >> methodSignature [
	^ '{1}>>#{2}'
		format: {
			self testClassName.
			self methodName }
]

{ #category : #printing }
GtLTestReference >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		aStream << self methodSignature ]
]

{ #category : #accessing }
GtLTestReference >> testClass [
	^ self testClassName asClass
]

{ #category : #accessing }
GtLTestReference >> testClassName [
	^ testClassName
]

{ #category : #accessing }
GtLTestReference >> testClassName: anObject [
	testClassName := anObject
]

{ #category : #'magritte description' }
GtLTestReference >> testClassNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Test class name';
		accessor: #testClassName;
		beRequired
]
