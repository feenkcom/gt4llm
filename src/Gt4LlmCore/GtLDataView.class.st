Class {
	#name : #GtLDataView,
	#superclass : #Object,
	#instVars : [
		'title',
		'buildContext',
		'dataKey',
		'definingMethodProvider'
	],
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #'api - views' }
GtLDataView class >> empty [
	^ GtLEmptyDataView new
]

{ #category : #accessing }
GtLDataView class >> handledExceptions [
	"We allow now here Halt and Warning.
	However as in case an action raising 
	those exceptions is embedded in the debugger it will trigger an
	infinite chain of debuggers.
	https://github.com/feenkcom/gtoolkit/issues/4383"
	
	^ Error ", Halt, Warning"
]

{ #category : #testing }
GtLDataView class >> isAbstract [
	^ self name = #GtLDataView 
]

{ #category : #accessing }
GtLDataView >> allDefiningMethods [
	"I return an object that understands #gtSourceFor:.
	I return all methods that are involved in a view definition."
	
	^ self definingMethodProvider 
		ifNotNil: [ :aMethodProvider | 
			aMethodProvider allDefiningMethods  ].
]

{ #category : #'message performing' }
GtLDataView >> basicOn: anObject perform: aMessageSymbol withArguments: aCollectionOfArguments [
	<return: #GtPhlowView>
	<gtCollector>
	| dataView |
	
	dataView := thisContext
		object: anObject
		perform: aMessageSymbol
		withArguments: aCollectionOfArguments
		inClass: anObject class.
		
	dataView = self ifTrue: [
		^Error signal: 'Cannot return the same data.' ].
			
	dataView object: anObject arguments: aCollectionOfArguments.
	^ dataView
]

{ #category : #accessing }
GtLDataView >> buildContext [
	^buildContext
]

{ #category : #accessing }
GtLDataView >> buildContext: aBuildContext [
	buildContext := aBuildContext
]

{ #category : #decorating }
GtLDataView >> compositeData [
	^ GtLCompositeDataView new
			originalView: self;
			definingMethod: (GtPhlowDefiningMethodsCollector forContext: thisContext) collect
]

{ #category : #accessing }
GtLDataView >> dataKey [
	^dataKey
]

{ #category : #accessing }
GtLDataView >> dataKey: anObject [
	dataKey := anObject
]

{ #category : #accessing }
GtLDataView >> definingMethod [
	^ self definingMethodProvider 
		ifNotNil: [ :aMethodProvider | 
			aMethodProvider definingMethod  ].
]

{ #category : #accessing }
GtLDataView >> definingMethod: anObject [
	definingMethodProvider := GtPhlowConcreteDefiningMethodProvider new
		definingMethod: anObject
]

{ #category : #accessing }
GtLDataView >> definingMethodProvider [
	^definingMethodProvider
]

{ #category : #accessing }
GtLDataView >> definingMethodProvider: anObject [
	definingMethodProvider := anObject
]

{ #category : #building }
GtLDataView >> documentData [
	^ GtLDocumentDataView new
		originalView: self;
		definingMethod: (GtPhlowDefiningMethodsCollector forContext: thisContext) collect
]

{ #category : #decorating }
GtLDataView >> emptyData [
	^ GtLEmptyDataView new
			originalView: self;
			definingMethod: (GtPhlowDefiningMethodsCollector forContext: thisContext) collect
]

{ #category : #'message performing' }
GtLDataView >> ensureContext [

	(self buildContext notNil and: [ 
		 self buildContext hasContext ]) ifTrue: [ 
		^ self buildContext context ].

	^ GtPhlowContext new
]

{ #category : #'message performing' }
GtLDataView >> errorViewWithException: anException isFrozen: aBoolean [
	^ self errorViewWithException: anException reason: nil isFrozen: aBoolean
]

{ #category : #'message performing' }
GtLDataView >> errorViewWithException: anException reason: anExceptionReason isFrozen: aBoolean [
	| errorName frozenException |
	
	frozenException := aBoolean 
		ifTrue: [ anException ]
		ifFalse: [ GtSystemUtility freeze: anException ].
		
	errorName := self title isNotNil
		ifTrue: [ self title asString, ' (Error)' ] 
		ifFalse: [ 'Error' ].
		
	^ GtLDataViewWithError new
		title: errorName;
		exception: frozenException;
		errorReason: anExceptionReason
]

{ #category : #decorating }
GtLDataView >> forwardObject [
	^ GtLForwardObjectDataView new
			originalView: self;
			definingMethod: (GtPhlowDefiningMethodsCollector forContext: thisContext) collect
]

{ #category : #decorating }
GtLDataView >> forwardObject: aBlockClosure [
	^ self forwardObject
		object: aBlockClosure
]

{ #category : #views }
GtLDataView >> gtDefiningMethodFor: aView [
	<gtView>
	^(aView forward)
		title: 'Defining Method';
		priority: 40;
		object: [definingMethodProvider allDefiningMethods];
		view: #gtSourceFor:
]

{ #category : #'gt - extensions' }
GtLDataView >> gtInspectPrimitiveDataButtonFor: anAction [
	<gtAction>
	^(anAction button)
		priority: 1;
		label: 'Primitive Data';
		icon: BrGlamorousVectorIcons inspect;
		action: 
				[:aButton |
				aButton phlow spawnObject: self serializeToLlmPrimiteData]
]

{ #category : #'gt - extensions' }
GtLDataView >> gtPhlowTreeChildren [
	^ #()
]

{ #category : #'gt - extensions' }
GtLDataView >> gtViewSerializationJSONFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	^ aView forward
			title: 'LLM JSON';
			priority: 62;
			object: [ self serializeToLlmPrimiteData ];
			view: #gtViewSerializationJSONFor:
]

{ #category : #'gt - extensions' }
GtLDataView >> gtViewSerializationObjectsFor: aView [
	<gtView>
	
	^ aView forward
			title: 'LLM Objects';
			priority: 60;
			object: [  self serializeToLlmPrimiteData ];
			view: #gtViewSerializationObjectsFor:
]

{ #category : #decorating }
GtLDataView >> imageData [
	^GtLImageDataView new
			originalView: self;
			definingMethod: (GtPhlowDefiningMethodsCollector forContext: thisContext) collect
]

{ #category : #testing }
GtLDataView >> isErrorView [
	^false
]

{ #category : #decorating }
GtLDataView >> jsonData [
	^ GtLJsonDataView new
			originalView: self;
			definingMethod: (GtPhlowDefiningMethodsCollector forContext: thisContext) collect
]

{ #category : #decorating }
GtLDataView >> jsonData: aBlock [
	^self jsonData
		data: aBlock
]

{ #category : #decorating }
GtLDataView >> jsonObject: aBlock [
	^self jsonData
		object: aBlock
]

{ #category : #decorating }
GtLDataView >> magritteObject [
	^ GtLMagritteDataView new
			originalView: self;
			definingMethod: (GtPhlowDefiningMethodsCollector forContext: thisContext) collect
]

{ #category : #decorating }
GtLDataView >> magritteObject: aBlockClosure [
	^ self magritteObject	
			object: aBlockClosure
]

{ #category : #utils }
GtLDataView >> object: anObject arguments: theExecutionArguments [
	self buildContext: (GtLDataViewBuildContext new
		object: anObject;
		arguments: theExecutionArguments)
]

{ #category : #'message performing' }
GtLDataView >> on: anObject perform: aMessageSymbol [
	<return: #GtLDataView>
	<gtCollector>
	
	^ self 
		on: anObject 
		perform: aMessageSymbol 
		withSomeArguments: { 
			  self.
			  self ensureContext }
]

{ #category : #'message performing' }
GtLDataView >> on: anObject perform: aMessageSymbol withArguments: aCollectionOfArguments [
	<return: #GtLDataView>
	<gtCollector>
	
	^ [ 
			self 
				basicOn: anObject 
				perform: aMessageSymbol 
				withArguments: aCollectionOfArguments
	] 
		on: self class handledExceptions do: [ :anException |
			self 
				errorViewWithException: anException 
				reason: ('Error executing the view method {1} on the class {2}' 
					format: {
						aMessageSymbol.
						anObject class name })
				isFrozen: false ]
]

{ #category : #'message performing' }
GtLDataView >> on: anObject perform: aMessageSymbol withContext: aContext [
	<return: #GtLDataView>
	<gtCollector>
	
	^ self 
		on: anObject 
		perform: aMessageSymbol 
		withSomeArguments: { self. aContext }
]

{ #category : #'message performing' }
GtLDataView >> on: anObject perform: aMessageSymbol withSomeArguments: aCollectionOfArguments [
	<return: #GtLDataView>
	<gtCollector>
	| newCollectionOfArguments |
	
	aCollectionOfArguments size = aMessageSymbol numArgs ifTrue: [ 
		^ self 
			on: anObject 
			perform: aMessageSymbol 
			withArguments: aCollectionOfArguments ].
			
	newCollectionOfArguments := aCollectionOfArguments 
		copyFrom: 1 
		to: aMessageSymbol numArgs.
		
	^ self 
		on: anObject 
		perform: aMessageSymbol 
		withArguments: newCollectionOfArguments
]

{ #category : #accessing }
GtLDataView >> originMethodsInto: aStream [
	self definingMethod ifNotNil: [ :aMethod | 
		aMethod gtOriginMethodsInto: aStream ]
]

{ #category : #'message performing' }
GtLDataView >> performComputation: aBlockClosure onErrorDataDo: anErrorBlock withReason: anErrorReason withBuilder: aBuilder [
	^self 
		performComputation: aBlockClosure
		onErrorView: [ :anErrorView |
			^ anErrorBlock cull: ((anErrorView 
					errorReason: anErrorReason) 
						serializeToLlmPrimiteDataOn: aBuilder) ].
]

{ #category : #'message performing' }
GtLDataView >> performComputation: aBlockClosure onErrorView: anErrorBlock [
	^aBlockClosure
		on: Error 
		do: [ :anError |
			^anErrorBlock value: (self 
				errorViewWithException: anError 
				reason: nil
				isFrozen: false) ].
]

{ #category : #printing }
GtLDataView >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		self viewDescriptionOn:  aStream ]
]

{ #category : #accessing }
GtLDataView >> priority [
	^ 1000
]

{ #category : #serialization }
GtLDataView >> serializeToAnthropicResponseOutput [
	^self serializeToLlmPrimiteData serializeForAnthropic
]

{ #category : #serialization }
GtLDataView >> serializeToLlmPrimiteData [
	| dataBuilder |
	
	dataBuilder := GtLPrimitiveMessageDataBuilder new.
	dataBuilder sourceDataView: self.
	self serializeToLlmPrimiteDataOn:  dataBuilder.
	
	^dataBuilder messageDataBlock
]

{ #category : #serialization }
GtLDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	self subclassResponsibility
]

{ #category : #serialization }
GtLDataView >> serializeToOpenAIResponseOutput [
	^self serializeToLlmPrimiteData serializeForOpenAI
]

{ #category : #accessing }
GtLDataView >> title [
	^title
]

{ #category : #accessing }
GtLDataView >> title: anObject [
	title := anObject
]

{ #category : #printing }
GtLDataView >> viewDescriptionOn: aStream [

	self title 
		ifNotNil: [ 
			aStream 
				<< self title;
				<<'; '].
			
	aStream 
			<< 'key: ';
			print: (self dataKey ifNil: [ '<none>' ])
]
