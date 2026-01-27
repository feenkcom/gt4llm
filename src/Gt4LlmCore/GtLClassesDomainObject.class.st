Class {
	#name : #GtLClassesDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'query',
		'foundClasses'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLClassesDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitClassSearchDomainObject: self
]

{ #category : #accessing }
GtLClassesDomainObject >> foundClasses [
	^ foundClasses
]

{ #category : #accessing }
GtLClassesDomainObject >> foundClasses: aCollection [
	"Set collection of classes that match the query"

	foundClasses := aCollection asArray
]

{ #category : #views }
GtLClassesDomainObject >> gtFoundClassesFor: aView [
	<gtView>
	<gtLlmView>
	foundClasses ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Classes';
		priority: 1;
		items: [ self foundClasses ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #'api - serializing' }
GtLClassesDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'foundClasses' put: (self foundClasses collect: #name as: Array);
		yourself
]
