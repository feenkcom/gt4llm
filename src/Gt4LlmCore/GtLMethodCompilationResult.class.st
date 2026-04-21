"
Result of a successful method compilation operation.
"
Class {
	#name : #GtLMethodCompilationResult,
	#superclass : #GtLMethodChangeResult,
	#instVars : [
		'oldMethod',
		'newMethod',
		'status'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #testing }
GtLMethodCompilationResult >> existsInImage [
	^ self newMethod notNil and: [
		self newMethod existsInImage ]
]

{ #category : #views }
GtLMethodCompilationResult >> gtDetailsFor: aView [
	<gtView>
	<gtCodeChangeView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [
			{'Method' -> (self newMethod ifNotNil: [ :m | m methodReference methodSignature ]).
			 'Status' -> self status.
			 'Old source' -> (self oldMethod ifNotNil: #sourceCode).
			 'New source' -> (self newMethod ifNotNil: #sourceCode)} ];
		column: 'Property' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #views }
GtLMethodCompilationResult >> gtViewChangeIcon [
	self isMethodAdditionResult
		ifTrue: [ ^ self class additionIcon ].
	^ self class modificationIcon
]

{ #category : #testing }
GtLMethodCompilationResult >> hasOldSourceCode [
	^ oldMethod notNil
]

{ #category : #testing }
GtLMethodCompilationResult >> isErrorDomainObject [
	^false
]

{ #category : #testing }
GtLMethodCompilationResult >> isMethodAdditionResult [
	^ self oldMethod isNil
]

{ #category : #testing }
GtLMethodCompilationResult >> isMethodModificationResult [
	^ self oldMethod notNil
]

{ #category : #'llm views' }
GtLMethodCompilationResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLMethodCompilationResult >> newCompiledMethod [
	^ newMethod compiledMethod
]

{ #category : #accessing }
GtLMethodCompilationResult >> newMethod [
	^ newMethod
]

{ #category : #accessing }
GtLMethodCompilationResult >> newMethod: aGtLMethodWithSource [
	newMethod := aGtLMethodWithSource
]

{ #category : #accessing }
GtLMethodCompilationResult >> newStateMethodSourceCode [
	^ self newMethod
			ifNil: [ '' ]
			ifNotNil: [ :aMethod | aMethod sourceCode ]
]

{ #category : #accessing }
GtLMethodCompilationResult >> oldMethod [
	^ oldMethod
]

{ #category : #accessing }
GtLMethodCompilationResult >> oldMethod: aGtLMethodWithSource [
	oldMethod := aGtLMethodWithSource
]

{ #category : #accessing }
GtLMethodCompilationResult >> oldStateMethodSourceCode [
	^ self oldMethod
			ifNil: [ '' ]
			ifNotNil: [ :aMethod | aMethod sourceCode ]
]

{ #category : #printing }
GtLMethodCompilationResult >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		self newMethod ifNotNil: [ :m |
			aStream nextPutAll: m methodReference methodSignature ].
		aStream nextPutAll: ' — '.
		self status ifNotNil: [ :s | aStream nextPutAll: s ] ]
]

{ #category : #accessing }
GtLMethodCompilationResult >> status [
	^ status
]

{ #category : #accessing }
GtLMethodCompilationResult >> status: aString [
	status := aString
]

{ #category : #magritte }
GtLMethodCompilationResult >> statusDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Status';
		accessor: #status;
		beRequired
]

{ #category : #accessing }
GtLMethodCompilationResult >> targetMethod [
	^ self newMethod 
]

{ #category : #accessing }
GtLMethodCompilationResult >> targetMethodReferenceDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
			accessor: #targetMethodReference;
			classes: {
				GtLMethodCompilationRequest };
			beRequired
]

{ #category : #accessing }
GtLMethodCompilationResult >> targetMethodSourceCode [

	^ self targetMethod sourceCode 
]
