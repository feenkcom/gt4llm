"
Magritte-based tool for executing a gtExample method and reporting the result.
"
Class {
	#name : #GtLToolForExampleMethodRun,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForExampleMethodRun >> description [
	^ 'Execute a gtExample method and report:
- status: Succeess, Error, Failure, Skipped.
- result: 
if it succeeds, it gets the resulting object. 
if there is a failure or error it gets the exception object and the stack trace.'
]

{ #category : #magritte }
GtLToolForExampleMethodRun >> exampleReferenceDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
		accessor: #exampleReference;
		classes: {GtLExampleReference};
		beRequired
]

{ #category : #testing }
GtLToolForExampleMethodRun >> isUsingDataViews [
	^true
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

{ #category : #private }
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
		objectId: objectId
]
