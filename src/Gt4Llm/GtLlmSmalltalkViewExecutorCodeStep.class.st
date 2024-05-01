Class {
	#name : #GtLlmSmalltalkViewExecutorCodeStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmSmalltalkViewExecutorCodeStep class >> stepName [
	^ 'Smalltalk view executor'
]

{ #category : #accessing }
GtLlmSmalltalkViewExecutorCodeStep >> createErrorString: anError [
	^ 'Encountered an error in the view: ' , anError messageText
		, '
Trace:
' , (self createStackString: anError)
]

{ #category : #accessing }
GtLlmSmalltalkViewExecutorCodeStep >> createStackString: anError [
	(anError isKindOf: SyntaxErrorNotification)
		ifTrue: [ ^ 'Syntax Error: ' , anError messageText ].

	^ String
		streamContents: [ :stream | 
			anError signalContext stack
				do: [ :stackItem | 
					stream
						print: stackItem;
						cr ] ]
]

{ #category : #accessing }
GtLlmSmalltalkViewExecutorCodeStep >> runStep: aContext [
	| view ast return script viewVariableName |
	view := aContext lastResult.
	instance := aContext instance.
	ast := GtPharoParser parse: view methodSource.
	return := (ast // GtPharoReturnNode) anyOne.
	script := '.' join: (ast body statements collect: #source).
	viewVariableName := view methodAst arguments first name.


	aContext
		addResult: ([ | createdView |
			createdView := OpalCompiler new
					source: script;
					receiver: instance;
					bindings: {viewVariableName -> GtPhlowEmptyView new};
					evaluate.
			createdView
				asElementDo: [ :anElement | 
					| scripter listOfErrors |
					scripter := BlScripter new.
					scripter element: anElement.
					scripter elementWithoutParent.
					listOfErrors := (anElement query // GtPhlowExceptionId) all
							, (anElement id = GtPhlowExceptionId asBlocElementId
									ifTrue: [ {anElement} ]
									ifFalse: [ {} ])
							collect: [ :anErrorElement | anErrorElement userData at: #exception ].
					listOfErrors
						ifNotEmpty: [ :aList | 
							aContext
								addResult: (GtLlmStepError new
										checker: self;
										content: aList;
										contentString: (self createErrorString: aList first) asString).
							^ self ] ].
			GtLlmStepSuccess new
				checker: self;
				content: createdView ]
				on: Error
				do: [ :anError | 
					GtLlmStepError new
						checker: self;
						content: anError;
						contentString: (self createErrorString: anError) asString ])
]
