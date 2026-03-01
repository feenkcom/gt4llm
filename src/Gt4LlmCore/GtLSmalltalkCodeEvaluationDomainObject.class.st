"
I represent the result of a Smalltalk code evaluation together with the evaluated code.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'code',
		'value'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLSmalltalkCodeEvaluationDomainObject >> code [
	^ code
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationDomainObject >> code: aString [
	code := aString
]

{ #category : #views }
GtLSmalltalkCodeEvaluationDomainObject >> gtCodeFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Code';
		priority: 9;
		stencil: [ (GtPharoSnippetCoder new
				forSource: self code;
				subscribeToSystem;
				asExpandedOnlyElement) vFitContentLimited ]
]

{ #category : #'as yet unclassified' }
GtLSmalltalkCodeEvaluationDomainObject >> gtValueLiveFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Object';
		priority: 8;
		stencil: [ | container |
			container := BrVerticalPane new
					matchParent;
					background: BrGlamorousColors backdropColor.
			container
				addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
				addChild: ((value gtViewsFor: GtPhlowEmptyView new) asElement
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude;
						vFitContentLimited) ]
]

{ #category : #serialization }
GtLSmalltalkCodeEvaluationDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'code' put: self code;
		at: 'value' put: (GtLValueSerializer new serializeValue: self value);
		yourself
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationDomainObject >> value [
	^ value
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationDomainObject >> value: anObject [
	value := anObject
]
