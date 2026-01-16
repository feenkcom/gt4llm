Class {
	#name : #GtLMethodsDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'methods',
		'mayHaveMore'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLMethodsDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitMethodsDomainObject: self
]

{ #category : #accessing }
GtLMethodsDomainObject >> mayHaveMore [
	^ mayHaveMore ifNil: [ false ]
]

{ #category : #accessing }
GtLMethodsDomainObject >> mayHaveMore: anObject [
	mayHaveMore := anObject
]

{ #category : #accessing }
GtLMethodsDomainObject >> methods [
	^ methods ifNil: [ #() ]
]

{ #category : #accessing }
GtLMethodsDomainObject >> methods: anObject [
	methods := anObject
]

{ #category : #'api - serializing' }
GtLMethodsDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methods'
			put: (self methods collect: [ :eachMethod | eachMethod name ] as: Array);
		at: 'mayHaveMoreReferences' put: self mayHaveMore;
		yourself
]
