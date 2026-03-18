"
Represents the successful result of a Smalltalk code evaluation with the code, serialized object value, and optional object ID.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationResult,
	#superclass : #GtLObjectStorageValueResult,
	#instVars : [
		'code'
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

{ #category : #descriptions }
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

{ #category : #printing }
GtLSmalltalkCodeEvaluationResult >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' code: '; nextPutAll: self code
]
