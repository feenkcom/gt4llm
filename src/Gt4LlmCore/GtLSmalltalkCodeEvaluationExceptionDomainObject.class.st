"
I describe a Smalltalk code evaluation error together with the code that triggered it.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationExceptionDomainObject,
	#superclass : #GtLExceptionDomainObject,
	#instVars : [
		'code'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionDomainObject >> code [
	^ code
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionDomainObject >> code: aString [
	code := aString
]

{ #category : #'gt-views' }
GtLSmalltalkCodeEvaluationExceptionDomainObject >> gtCodeFor: aView [
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

{ #category : #accessing }
GtLSmalltalkCodeEvaluationExceptionDomainObject >> llmRawDataViewFor: aDataView [
	^ aDataView 
			title: 'Exception generic details';
			jsonData: [ 
				NeoJSONObject new
					at: 'errorReason' put: self description;
					at: 'code' put: self code;
					yourself ]
]
