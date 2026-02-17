Class {
	#name : #GtLMethodReference,
	#superclass : #Object,
	#instVars : [
		'methodName',
		'classSide',
		'methodClassName'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLMethodReference class >> fromCompiledMethod: aMethod [ 
	^ self new 
			initializeFromCompiledMethod: aMethod 
]

{ #category : #accessing }
GtLMethodReference >> classSide [
	^ classSide 
]

{ #category : #accessing }
GtLMethodReference >> classSide: anObject [
	classSide := anObject
]

{ #category : #descriptions }
GtLMethodReference >> classSideDescription [
	<magritteDescription>
	
	^ MABooleanDescription new
		label: 'Class side';
		accessor: #classSide;
		beOptional
]

{ #category : #accessing }
GtLMethodReference >> compiledMethod [
	^ self methodClass >>  self methodName asSymbol
]

{ #category : #enumerating }
GtLMethodReference >> compiledMethodIfPresent: aPresentBlock ifMissing: anErrorBlock [
	| targetClass methodSymbol method |
	
	self methodClassName
		ifNil: [ ^ anErrorBlock 
				value: (GtLMissingArgumentDomainObject new
					arguments: nil;
					missingArgument: 'targetClassName') ].
	self methodName
		ifNil: [ ^ anErrorBlock 
			value: (GtLMissingArgumentDomainObject new
				arguments: nil;
				missingArgument: 'methodName') ].
				
	targetClass := self methodClassName
		asClassIfAbsent: [ 
			^ anErrorBlock 
				value: (GtLMissingDomainObject new 
						objectName: self methodClassName) ].

	self isClassSide ifTrue: [ targetClass := targetClass class ].
	methodSymbol := self methodName asSymbol.
	method := targetClass lookupSelector: methodSymbol.
	method ifNil: [ ^ anErrorBlock 
			value:  (GtLMissingDomainObject new
				objectName: self methodSignature) ].
						
	^ aPresentBlock value: method
]

{ #category : #initialization }
GtLMethodReference >> initializeFromCompiledMethod: aMethod [ 
	methodClassName := aMethod methodClass name.
	methodName := aMethod selector. 
	classSide := aMethod methodClass isClassSide
]

{ #category : #testing }
GtLMethodReference >> isClassSide [ 
	^ classSide 
		ifNil: [ false ]
		ifNotNil: [ :aValue | #(true 'true' 't') includes: aValue ]
]

{ #category : #accessing }
GtLMethodReference >> methodClass [
	| targetClass |
	targetClass := self methodClassName asClass.
	self isClassSide 
		ifTrue: [ targetClass := targetClass class ].
	^ targetClass
]

{ #category : #accessing }
GtLMethodReference >> methodClassName [
	^ methodClassName
]

{ #category : #accessing }
GtLMethodReference >> methodClassName: anObject [
	methodClassName := anObject
]

{ #category : #descriptions }
GtLMethodReference >> methodClassNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Class name';
		accessor: #methodClassName;
		beRequired
]

{ #category : #accessing }
GtLMethodReference >> methodName [
	^ methodName
]

{ #category : #accessing }
GtLMethodReference >> methodName: anObject [
	methodName := anObject
]

{ #category : #descriptions }
GtLMethodReference >> methodNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodName;
		beRequired
]

{ #category : #enumerating }
GtLMethodReference >> methodObjectIfMissing: anErrorBlock [
	^ self 
		compiledMethodIfPresent: [ :aMethod |
			aMethod isSourceSearchable 
				ifTrue: [
					GtLMethodWithSource fromCompiledMethod: aMethod ]
				ifFalse: [ 
					GtLNotSourceSearchableMethodDomainObject new 
						method: aMethod ].]
		ifMissing: anErrorBlock.
]

{ #category : #printing }
GtLMethodReference >> methodSignature [
	^ '{1}{2}>>#{3}'
			format: {
				self methodClassName.
				self isClassSide ifTrue: [ ' class' ] ifFalse: [ '' ].
				self methodName}
]

{ #category : #printing }
GtLMethodReference >> printOn: aStream [ 
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self methodSignature]
]
