Class {
	#name : #GtLDataView,
	#superclass : #Object,
	#instVars : [
		'title',
		'buildContext'
	],
	#category : #Gt4LlmCore
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
]

{ #category : #decorating }
GtLDataView >> emptyData [
	^ GtLEmptyDataView new
]

{ #category : #'message performing' }
GtLDataView >> errorViewWithException: anException isFrozen: aBoolean [
	| errorName frozenException |
	
	frozenException := aBoolean 
		ifTrue: [ anException ]
		ifFalse: [ GtSystemUtility freeze: anException ].
		
	errorName := self name isNotNil
		ifTrue: [ self name asString, ' (Error)' ] 
		ifFalse: [ 'Error' ].
		
	^ GtPhlowViewWithError new
		title: errorName;
		exception: frozenException
]

{ #category : #utils }
GtLDataView >> gtViewSerializationJSONFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	^ aView columnedList
			title: 'LLM JSON';
			priority: 62;
			items: [ (Pragma
				allNamed: #llmSerialization:
				from: self class
				to: Object) collect: [ :eachPragma |
						eachPragma arguments first -> eachPragma methodSelector ] ];
			column: 'LLM' text: [ :assoc | assoc key ];
			send: [ :assoc | [
					(self perform: assoc value)  asGtJson] 
							on: Error do: [ :each | GtSystemUtility freeze: each] ]
]

{ #category : #utils }
GtLDataView >> gtViewSerializationObjectsFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	^ aView columnedList
			title: 'LLM Objects';
			priority: 60;
			items: [ (Pragma
				allNamed: #llmSerialization:
				from: self class
				to: Object) collect: [ :eachPragma |
						eachPragma arguments first -> ([self perform: eachPragma methodSelector] 
								on: Error do: [ :each | GtSystemUtility freeze: each]) ] ];
			column: 'LLM' text: [ :assoc | assoc key ] width: 200;
			column: 'Object count' text: [ :assoc | 
				assoc value isCollection ifTrue: [ assoc value size ] ifFalse: ['-'] ] width: 100;
			column: 'Value' text: [ :assoc | assoc value gtDisplayString ];
			send: [ :assoc | assoc value ]
]

{ #category : #decorating }
GtLDataView >> imageData [
	^ GtLImageDataView new
]

{ #category : #decorating }
GtLDataView >> jsonData [
	^ GtLJsonDataView new
]

{ #category : #decorating }
GtLDataView >> jsonData: aBlock [
	^self jsonData
		jsonObject: aBlock
]

{ #category : #utils }
GtLDataView >> object: anObject arguments: theExecutionArguments [
	self buildContext: (GtLDataViewBuildContext new
		object: anObject;
		arguments: theExecutionArguments)
]

{ #category : #'message performing' }
GtLDataView >> on: anObject perform: aMessageSymbol withArguments: aCollectionOfArguments [
	<return: #GtPhlowView>
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
				isFrozen: false ]
]

{ #category : #'message performing' }
GtLDataView >> on: anObject perform: aMessageSymbol withContext: aContext [
	<return: #GtPhlowView>
	<gtCollector>
	
	^ self 
		on: anObject 
		perform: aMessageSymbol 
		withSomeArguments: { self. aContext }
]

{ #category : #'message performing' }
GtLDataView >> on: anObject perform: aMessageSymbol withSomeArguments: aCollectionOfArguments [
	<return: #GtPhlowAction>
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
GtLDataView >> priority [
	^ 1000
]

{ #category : #serialization }
GtLDataView >> serializeToAnthropicResponseOutput [
	<llmSerialization: 'Anthropic'>
	self subclassResponsibility
]

{ #category : #serialization }
GtLDataView >> serializeToOpenAIResponseOutput [
	<llmSerialization: 'OpenAI'>
	self subclassResponsibility
]

{ #category : #accessing }
GtLDataView >> title [
	^title
]

{ #category : #accessing }
GtLDataView >> title: anObject [
	title := anObject
]
