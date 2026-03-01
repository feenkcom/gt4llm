Class {
	#name : #GtLValueDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'value'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLValueDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitValueDomainObject: self
]

{ #category : #views }
GtLValueDomainObject >> gtValueLiveFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Object';
		priority: 1;
		stencil: [ | container |
			container := BrVerticalPane new
					matchParent;
					background: BrGlamorousColors backdropColor.
			container
				addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
				addChild: ((value gtViewsFor: GtPhlowEmptyView new) asElement
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude) ]
]

{ #category : #'api - serializing' }
GtLValueDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ [ GtLValueSerializer new serializeValue: self value ]
		on: Error
		do: [ :anError | 
			anError
				return: (GtLExceptionDomainObject new
						freeze: anError;
						description: 'Cannot serialize object';
						serializeToOpenAIResponseJsonObject) ]
]

{ #category : #accessing }
GtLValueDomainObject >> value [
	^ value
]

{ #category : #accessing }
GtLValueDomainObject >> value: anObject [
	value := anObject
]
