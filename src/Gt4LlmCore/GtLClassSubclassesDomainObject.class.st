Class {
	#name : #GtLClassSubclassesDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'foundClass',
		'subclasses'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLClassSubclassesDomainObject >> foundClass [
	^ foundClass
]

{ #category : #accessing }
GtLClassSubclassesDomainObject >> foundClass: anObject [
	foundClass := anObject
]

{ #category : #'gt - extensions' }
GtLClassSubclassesDomainObject >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Class';
		priority: 10;
		stencil: [ (GtCoderElement forClass: self foundClass) disablePlayPage ]
]

{ #category : #'gt - extensions' }
GtLClassSubclassesDomainObject >> gtSubclassesFor: aView [
	<gtView>
	<gtLlmView>
	subclasses ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Subclasses';
		items: [ self subclasses ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #'api - serializing' }
GtLClassSubclassesDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'class' put: self foundClass name;
		at: 'subclasses'
			put: (self subclasses
					collect: [ :eachSubclass | eachSubclass name asString ]
					as: Array);
		yourself
]

{ #category : #accessing }
GtLClassSubclassesDomainObject >> subclasses [
	^ subclasses ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassSubclassesDomainObject >> subclasses: anObject [
	subclasses := anObject
]
