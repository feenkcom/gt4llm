"
Magritte-based tool for executing a gtExample method and reporting the result.
"
Class {
	#name : #GtLToolForExampleMethodRun,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'database'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForExampleMethodRun >> database: aDatabase [
	database := aDatabase
]

{ #category : #accessing }
GtLToolForExampleMethodRun >> description [
	^ 'Execute a gtExample method. It returns:
- status: Succeess, Error, Failure, Skipped.
- and the result:
  1. if it succeeds: 
    - the resulting object as one or more JSON or image entries, each representing a view of the resulting object. Look at all of them to interpret the result.
    - the object id that you can use as reference for other tool calls.
    - the playgroundPageReference to the contextual playground page. Use that page to look for object specific snippets and explanations.
  2. if there is an exception, it gets the errorDetails (errorMessage, stackTrace, errorClass). It can also get other JSON or image entries each representing a view of the exception. Look at all of them to interpret the result.'
]

{ #category : #magritte }
GtLToolForExampleMethodRun >> exampleReferenceDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
		accessor: #exampleReference;
		classes: {GtLExampleReference};
		beRequired
]

{ #category : #initialization }
GtLToolForExampleMethodRun >> initialize [
	super initialize.
	
	database := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLToolForExampleMethodRun >> name [
	^ 'exampleMethodRun'
]

{ #category : #execution }
GtLToolForExampleMethodRun >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments exampleReference |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	exampleReference := arguments at: 'exampleReference'.
	
	^ exampleReference 
		compiledMethodIfPresent: [ :aMethod | 
			self 
				runExample: aMethod 
				fromReference: exampleReference 
				inContext: anExecutionContext 
				toolCall: aToolCall ]
		ifMissing: [ :anErrorResult | anErrorResult ]
]

{ #category : #private }
GtLToolForExampleMethodRun >> runExample: method fromReference: exampleReference inContext: anExecutionContext toolCall: aToolCall [
	^self 
		runExample: method 
		fromReference: exampleReference 
		inContext: anExecutionContext 
		toolCall: aToolCall 
		ifError: [ :anError | anError ]
]

{ #category : #running }
GtLToolForExampleMethodRun >> runExample: method fromReference: exampleReference inContext: anExecutionContext toolCall: aToolCall ifError: anErrorBlock [
	| example exampleResult objectId |
	
	(method pragmas anySatisfy: [ :pragma | pragma selector = #gtExample ])
		ifFalse: [ ^ GtLMethodIsNotExampleDomainObject new method: method ].
	example := method gtExample asExampleWithResult.
	example ifNil: [ ^ anErrorBlock cull: (GtLMethodIsNotExampleDomainObject new
		 method: method) ].
	
	[ exampleResult := example run ]
		on: Error
		do: [ :ex | 
			^ anErrorBlock cull: (GtLExceptionDomainObject new
					freeze: ex;
					description: ('Example execution failed: {1}' format: {method name})) ].
				
	objectId := anExecutionContext objectStorage ifNotNil: [ :aStorage |
		aStorage
			addNewObject: exampleResult returnValue
			reason: (GtLStoredObjectExampleMethodReason toolCall: aToolCall) ].
			
	^ GtLExampleWithResult new
		exampleWithResult: example;
		objectId: objectId;
		updatelaygroupdPageReferenceForDatabase: database;
		yourself
]
