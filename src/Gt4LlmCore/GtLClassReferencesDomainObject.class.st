Class {
	#name : #GtLClassReferencesDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'foundClass',
		'references'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLClassReferencesDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitClassSearchDomainObject: self
]

{ #category : #accessing }
GtLClassReferencesDomainObject >> foundClass [
	^ foundClass
]

{ #category : #accessing }
GtLClassReferencesDomainObject >> foundClass: anObject [
	foundClass := anObject
]

{ #category : #'gt - extensions' }
GtLClassReferencesDomainObject >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Class';
		priority: 10;
		stencil: [ (GtCoderElement forClass: self foundClass) disablePlayPage ]
]

{ #category : #views }
GtLClassReferencesDomainObject >> gtReferencesFor: aView [
	<gtView>
	<gtLlmView>
	references ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'References';
		items: [ self references ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #accessing }
GtLClassReferencesDomainObject >> references [
	^ references ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassReferencesDomainObject >> references: anObject [
	references := anObject
]

{ #category : #'api - serializing' }
GtLClassReferencesDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'class' put: self foundClass name asString;
		at: 'references'
			put: (self references
					collect: [ :eachCompiledMethod | eachCompiledMethod name ]
					as: Array);
		yourself
]
