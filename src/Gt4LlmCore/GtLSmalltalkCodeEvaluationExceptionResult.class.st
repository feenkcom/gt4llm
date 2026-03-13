"
Represents an exception that occurred during Smalltalk code evaluation. Stores the exception object for debugging but serializes error details via Magritte.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationExceptionResult,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'code',
		'errorMessage',
		'errorClassName',
		'whatFailed',
		'stackTrace',
		'exception'
	],
	#classVars : [
		':parameter>',
		'</antml',
		'<parameter',
		'name="package">Gt4LlmCore'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> code [
	^ code
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> code: aString [
	code := aString
]

{ #category : #magritte }
GtLSmalltalkCodeEvaluationExceptionResult >> codeDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Code';
		accessor: #code;
		beRequired
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> errorClassName [
	"Return the class name of the exception."
	^ errorClassName ifNil: [ '' ]
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> errorClassName: aString [
	"Set the class name of the exception."
	errorClassName := aString
]

{ #category : #magritte }
GtLSmalltalkCodeEvaluationExceptionResult >> errorClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Error class name';
		accessor: #errorClassName;
		beRequired
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> errorMessage [
	"Return the error message string."
	^ errorMessage ifNil: [ '' ]
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> errorMessage: aString [
	"Set the error message string."
	errorMessage := aString
]

{ #category : #magritte }
GtLSmalltalkCodeEvaluationExceptionResult >> errorMessageDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Error message';
		accessor: #errorMessage;
		beRequired
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> exception [
	"Return the stored exception object (not serialized)."
	^ exception
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> exception: anException [
	"Set the exception object (not serialized)."
	exception := anException
]

{ #category : #initialization }
GtLSmalltalkCodeEvaluationExceptionResult >> freeze: anException [
	"Freeze the exception and populate error details."
	| frozenException |
	frozenException := GtSystemUtility freeze: anException.
	self exception: frozenException.
	self errorMessage: frozenException  description.
	self errorClassName: frozenException class name.
	self stackTrace: (frozenException signalerContext
		ifNotNil: [ :ctx | String lf join: ((ctx stackOfSize: 30) collect: [ :each | 
			each gtDisplayString]) ]
		ifNil: [ | str | 
			str := frozenException stackString ifNil: [''].
			str takeFirst: 1000 ]).
]

{ #category : #views }
GtLSmalltalkCodeEvaluationExceptionResult >> gtCodeFor: aView [
	<gtView>
	<gtLlmView>
	code ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Code and exception';
		priority: 0;
		stencil: [ | container |
			container := BrVerticalPane new.
			container matchParent
				addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
				background: BrGlamorousColors backdropColor;
				addChild: ((GtPharoSnippetCoder new
						forSource: self code;
						subscribeToSystem;
						asExpandedOnlyElement)
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude;
						vFitContentLimited);
				addChild: ((exception gtViewsFor: GtPhlowEmptyView new) asElement
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude;
						vFitContentLimited;
						hMatchParent) ]
]

{ #category : #views }
GtLSmalltalkCodeEvaluationExceptionResult >> gtExceptionStackFor: aView [
	<gtView>
	<gtLlmView>
	exception ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Exception stack';
		priority: 1;
		object: [ self exception ];
		view: #gtLiveFor:
]

{ #category : #printing }
GtLSmalltalkCodeEvaluationExceptionResult >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (errorClassName ifNil: [ '' ]);
		nextPutAll: ': ';
		nextPutAll: (errorMessage ifNil: [ '' ] ifNotNil: [ errorMessage truncateTo: 30 ]);
		nextPut: $)
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> stackTrace [
	^ stackTrace ifNil: [ '' ]
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> stackTrace: aString [
	stackTrace := aString
]

{ #category : #magritte }
GtLSmalltalkCodeEvaluationExceptionResult >> stackTraceDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Stack trace';
		accessor: #stackTrace;
		beRequired
]

{ #category : #testing }
GtLSmalltalkCodeEvaluationExceptionResult >> wasMovedToMagritteDescriptions [
	^ true
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> whatFailed [
	^ whatFailed ifNil: [ '' ]
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionResult >> whatFailed: aString [
	whatFailed := aString
]

{ #category : #magritte }
GtLSmalltalkCodeEvaluationExceptionResult >> whatFailedDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'What failed';
		accessor: #whatFailed;
		beRequired
]
