Class {
	#name : #GtLMethodReference,
	#superclass : #Object,
	#instVars : [
		'methodName',
		'classSide',
		'methodClassName'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLMethodReference class >> fromCompiledMethod: aMethod [ 
	^ self new 
			initializeFromCompiledMethod: aMethod 
]

{ #category : #comparing }
GtLMethodReference >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	(self class = anObject class) ifFalse: [ ^ false ].
	^ self methodClassName = anObject methodClassName
		and: [ self methodName = anObject methodName
		and: [ self classSide = anObject classSide ] ]
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
		beRequired
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

	self isClassSide ifTrue: [ 
		targetClass := targetClass class ].
	methodSymbol := self methodName asSymbol.
	method := targetClass lookupSelector: methodSymbol.
	method ifNil: [ ^ anErrorBlock 
			value:  (GtLMissingDomainObject new
				objectName: self methodSignature) ].
						
	^ aPresentBlock value: method
]

{ #category : #testing }
GtLMethodReference >> existsInImage [
	^ self 
			compiledMethodIfPresent: [ :each | true ] 
			ifMissing: [ :each | false ]
]

{ #category : #'gt - views' }
GtLMethodReference >> gtActionBrowseEntryFor: anAction [
	<gtAction>
	
	self existsInImage ifFalse: [ ^ anAction noAction ].
	
	^ anAction button
			label: 'Browse';
			priority: 3;
			tooltip: 'Browse current version of this method';
			action: [ :aButton | 
				aButton phlow spawnTool: (GtMethodCoderTool compiledMethod:
						self compiledMethod)  ] 
]

{ #category : #views }
GtLMethodReference >> gtClassCoderViewFor: aView [
	<gtView>
	<gtCodeChangeView>
	
	self existsInImage ifFalse: [ ^ aView empty ].
	
	^ aView explicit
		title: 'Coder';
		priority: 20;
		stencil: [ (GtCoderElement forMethod: self compiledMethod) disablePlayPage ]
]

{ #category : #'gt - views' }
GtLMethodReference >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 2;
		items: [ {
			'Method class' -> self methodClassName.
			'Method name' -> self methodName.
			'Class side' -> self classSide.
			'Signature' -> self methodSignature.
			'Exists in image' -> self existsInImage } ];
		column: 'Property' text: [ :assoc | assoc key ] width: 250;
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #comparing }
GtLMethodReference >> hash [
	^ (self methodClassName hash bitXor: self methodName hash)
		bitXor: self classSide hash
]

{ #category : #initialization }
GtLMethodReference >> initializeFromCompiledMethod: aMethod [ 
	methodClassName := aMethod methodClass instanceSide name.
	methodName := aMethod selector. 
	classSide := aMethod methodClass isClassSide
]

{ #category : #testing }
GtLMethodReference >> isClassSide [ 
	^ classSide 
		ifNil: [ false ]
		ifNotNil: [ :aValue | #(true 'true' 't') includes: aValue ]
]

{ #category : #'llm views' }
GtLMethodReference >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
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
				ifTrue: [ GtLMethodWithSource fromCompiledMethod: aMethod ]
				ifFalse: [ GtLNotSourceSearchableMethod  fromCompiledMethod: aMethod ] ]
		ifMissing: anErrorBlock
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
