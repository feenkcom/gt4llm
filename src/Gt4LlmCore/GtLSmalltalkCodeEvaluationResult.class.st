"
Represents the successful result of a Smalltalk code evaluation with the code, serialized object value, and optional object ID.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationResult,
	#superclass : #Object,
	#instVars : [
		'code',
		'objectValue',
		'objectId',
		'object'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> code [
	^ code
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> code: aString [
	code := aString
]

{ #category : #magritte }
GtLSmalltalkCodeEvaluationResult >> codeDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Code';
		accessor: #code;
		beRequired
]

{ #category : #views }
GtLSmalltalkCodeEvaluationResult >> gtCodeFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Code and object';
		priority: 9;
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
				addChild: ((object gtViewsFor: GtPhlowEmptyView new) asElement
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude;
						vFitContentLimited;
						hMatchParent) ]
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> object [
	"Return the actual result object (not serialized)."
	^ object
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> object: anObject [
	"Set the actual result object (not serialized)."
	object := anObject
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> objectId [
	^ objectId ifNil: [ '' ]
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> objectId: aString [
	objectId := aString
]

{ #category : #magritte }
GtLSmalltalkCodeEvaluationResult >> objectIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Object ID';
		accessor: #objectId;
		beRequired
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> objectValue [
	^ objectValue
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> objectValue: aGtLSerializedObjectValue [
	objectValue := aGtLSerializedObjectValue
]

{ #category : #magritte }
GtLSmalltalkCodeEvaluationResult >> objectValueDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Object value';
		accessor: #objectValue;
		classes: { GtLSerializedObjectValue };
		beRequired
]

{ #category : #printing }
GtLSmalltalkCodeEvaluationResult >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (code ifNil: [ '' ] ifNotNil: [ code truncateTo: 30 ]);
		nextPut: $)
]
