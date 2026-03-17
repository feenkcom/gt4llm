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
	#category : 'Gt4LlmCore-Domain Objects'
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
