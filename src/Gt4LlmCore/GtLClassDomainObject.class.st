Class {
	#name : #GtLClassDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'foundClass'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLClassDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitClassDomainObject: self
]

{ #category : #accessing }
GtLClassDomainObject >> foundClass [
	^ foundClass
]

{ #category : #accessing }
GtLClassDomainObject >> foundClass: anObject [
	foundClass := anObject
]

{ #category : #'gt - extensions' }
GtLClassDomainObject >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Class';
		priority: 10;
		stencil: [ | container |
			container := BrVerticalPane new
					matchParent;
					background: BrGlamorousColors backdropColor.
			container
				addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
				addChild: ((GtCoderElement forClass: self foundClass)
						disablePlayPage;
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude).
			container ]
]

{ #category : #'api - serializing' }
GtLClassDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ GtLValueSerializer new serializeClass: self foundClass
]
