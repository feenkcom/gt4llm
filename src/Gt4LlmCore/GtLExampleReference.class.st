"
Reference to an example method, used as a parameter for the Magritte-based example method run tool.
"
Class {
	#name : #GtLExampleReference,
	#superclass : #Object,
	#instVars : [
		'exampleClassName',
		'methodName',
		'classSide'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLExampleReference class >> fromCompiledMethod: aMethod [ 
	^ self new 
		initializeFromCompiledMethod: aMethod
]

{ #category : #accessing }
GtLExampleReference >> classSide [
	^ classSide
]

{ #category : #accessing }
GtLExampleReference >> classSide: anObject [
	classSide := anObject
]

{ #category : #magritte }
GtLExampleReference >> classSideDescription [
	<magritteDescription>
	
	^ MABooleanDescription new
		label: 'Class side';
		accessor: #classSide;
		beRequired
]

{ #category : #accessing }
GtLExampleReference >> compiledMethod [
	^ self exampleClass >> self methodName asSymbol
]

{ #category : #accessing }
GtLExampleReference >> compiledMethodIfPresent: aPresentBlock ifMissing: anErrorBlock [
	| targetClass methodSymbol method |
	
	targetClass := self exampleClassName
		asClassIfAbsent: [ 
			^ anErrorBlock 
				value: (GtLMissingDomainObject new 
						objectName: self exampleClassName) ].

	self isClassSide ifTrue: [ 
		targetClass := targetClass class ].
	
	methodSymbol := self methodName asSymbol.
	method := targetClass lookupSelector: methodSymbol.
	method ifNil: [ ^ anErrorBlock 
			value:  (GtLMissingDomainObject new
				objectName: self methodSignature) ].
						
	^ aPresentBlock value: method
]

{ #category : #accessing }
GtLExampleReference >> exampleClass [
	| targetClass |
	targetClass := self exampleClassName asClass.
	self isClassSide 
		ifTrue: [ targetClass := targetClass class ].
	^ targetClass
]

{ #category : #accessing }
GtLExampleReference >> exampleClassName [
	^ exampleClassName
]

{ #category : #accessing }
GtLExampleReference >> exampleClassName: anObject [
	exampleClassName := anObject
]

{ #category : #magritte }
GtLExampleReference >> exampleClassNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Example class name';
		accessor: #exampleClassName;
		beRequired
]

{ #category : #initialization }
GtLExampleReference >> initializeFromCompiledMethod: aMethod [ 
	exampleClassName := aMethod methodClass instanceSide name.
	methodName := aMethod selector. 
	classSide := aMethod methodClass isClassSide
]

{ #category : #testing }
GtLExampleReference >> isClassSide [
	^ classSide 
		ifNil: [ false ]
		ifNotNil: [ :aValue | #(true 'true' 't') includes: aValue ]
]

{ #category : #accessing }
GtLExampleReference >> methodName [
	^ methodName
]

{ #category : #accessing }
GtLExampleReference >> methodName: anObject [
	methodName := anObject
]

{ #category : #magritte }
GtLExampleReference >> methodNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodName;
		beRequired
]

{ #category : #accessing }
GtLExampleReference >> methodSignature [
	^ '{1}{2}>>#{3}'
			format: {
				self exampleClassName.
				self isClassSide ifTrue: [ ' class' ] ifFalse: [ '' ].
				self methodName}
]

{ #category : #printing }
GtLExampleReference >> printOn: aStream [ 
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self methodSignature]
]
