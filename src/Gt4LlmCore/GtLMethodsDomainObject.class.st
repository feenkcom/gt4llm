Class {
	#name : #GtLMethodsDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'methods',
		'mayHaveMore'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'gt - extensions' }
GtLMethodsDomainObject >> gtMethodsFor: aView [
	<gtView>
	<gtLlmView>
	methods ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Found methods';
		priority: 1;
		items: [ self methods ];
		column: 'Value' text: [ :each | each gtDisplayString ]
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
