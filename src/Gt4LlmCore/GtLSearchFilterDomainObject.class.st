Class {
	#name : #GtLSearchFilterDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'query',
		'filter',
		'items',
		'mayHaveMore'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLSearchFilterDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitSearchFilterDomainObject: self
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> filter [
	^ filter
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> filter: aSearchFilter [
	filter := aSearchFilter
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> items [
	^ items ifNil: [ items := #() ]
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> items: anObject [
	items := anObject
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> mayHaveMore [
	^ mayHaveMore ifNil: [ mayHaveMore := false ]
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> mayHaveMore: aBoolean [
	mayHaveMore := aBoolean
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> query [
	^ query
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> query: anObject [
	query := anObject
]

{ #category : #'api - serializing' }
GtLSearchFilterDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'items' put: (self items collect: #printString as: Array);
		at: 'query' put: self query;
		at: 'mayHaveMoreItems' put: self mayHaveMore;
		yourself
]
