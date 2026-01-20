Class {
	#name : #GtLClassSearchDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'query',
		'foundClasses'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLClassSearchDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitClassSearchDomainObject: self
]

{ #category : #accessing }
GtLClassSearchDomainObject >> foundClasses [
	^ foundClasses
]

{ #category : #accessing }
GtLClassSearchDomainObject >> foundClasses: aCollection [
	"Set collection of classes that match the query"

	foundClasses := aCollection
]

{ #category : #views }
GtLClassSearchDomainObject >> gtFoundClassesFor: aView [
	<gtView>
	<gtLlmView>
	foundClasses ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Classes';
		items: [ self foundClasses ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #accessing }
GtLClassSearchDomainObject >> query [
	^ query
]

{ #category : #accessing }
GtLClassSearchDomainObject >> query: aString [
	"Set a query that was used to search classes"

	query := aString
]

{ #category : #'api - serializing' }
GtLClassSearchDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'query' put: self query;
		at: 'foundClasses' put: (self foundClasses collect: #name as: Array);
		yourself
]
