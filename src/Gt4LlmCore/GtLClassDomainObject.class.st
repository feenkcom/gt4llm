Class {
	#name : #GtLClassDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'foundClass',
		'originalClassName',
		'originalSuperclassName',
		'originalPackageName',
		'originalInstanceVariableNames',
		'originalClassVariableNames',
		'originalTraitCompositionString'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

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

{ #category : #accessing }
GtLClassDomainObject >> originalClassName [
	^ originalClassName
]

{ #category : #accessing }
GtLClassDomainObject >> originalClassName: aString [
	originalClassName := aString
]

{ #category : #accessing }
GtLClassDomainObject >> originalClassVariableNames [
	^ originalClassVariableNames
]

{ #category : #accessing }
GtLClassDomainObject >> originalClassVariableNames: aString [
	originalClassVariableNames := aString
]

{ #category : #accessing }
GtLClassDomainObject >> originalInstanceVariableNames [
	^ originalInstanceVariableNames
]

{ #category : #accessing }
GtLClassDomainObject >> originalInstanceVariableNames: aString [
	originalInstanceVariableNames := aString
]

{ #category : #accessing }
GtLClassDomainObject >> originalPackageName [
	^ originalPackageName
]

{ #category : #accessing }
GtLClassDomainObject >> originalPackageName: aString [
	originalPackageName :=  aString
]

{ #category : #accessing }
GtLClassDomainObject >> originalSuperclassName [
	^ originalSuperclassName 
]

{ #category : #accessing }
GtLClassDomainObject >> originalSuperclassName: aString [
	originalSuperclassName := aString
]

{ #category : #accessing }
GtLClassDomainObject >> originalTraitCompositionString [
	^ originalTraitCompositionString
]

{ #category : #accessing }
GtLClassDomainObject >> originalTraitCompositionString: aString [
	originalTraitCompositionString := aString
]

{ #category : #'api - serializing' }
GtLClassDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ GtLValueSerializer new serializeClass: self foundClass
]
