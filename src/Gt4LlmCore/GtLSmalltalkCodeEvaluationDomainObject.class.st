"
I represent the result of a Smalltalk code evaluation together with the evaluated code.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'code',
		'object',
		'objectId'
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
				addChild: ((object gtViewsFor: GtPhlowEmptyView new) asElement
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude;
						vFitContentLimited) ]
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationDomainObject >> object [
	^ object
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationDomainObject >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationDomainObject >> objectId [
	^ objectId
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationDomainObject >> objectId: anObject [
	objectId := anObject
]

{ #category : #serialization }
GtLSmalltalkCodeEvaluationDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'code' put: self code;
		at: 'objectValue' put: (GtLValueSerializer new 
			serializeValue: self object);
		at: 'objectId' put: self objectId;
		yourself
]
