Class {
	#name : #GtWardleyMapChangeSpecification,
	#superclass : #Object,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #testing }
GtWardleyMapChangeSpecification class >> isConcrete [
	^self subclasses isEmpty
]

{ #category : #changes }
GtWardleyMapChangeSpecification >> asChangeIn: aWardleyMapModel [
	self subclassResponsibility
]

{ #category : #private }
GtWardleyMapChangeSpecification >> edgeFrom: fromString to: toString in: aWardleyMapModel [
	| from to |
	from := UUID gtFromString: fromString.
	to := UUID gtFromString: toString.
	^ aWardleyMapModel edges
		detect: [ :each | each fromNode id = from and: [ each toNode id = to ] ]
		ifNone: [  ]
]

{ #category : #private }
GtWardleyMapChangeSpecification >> nodeWithId: aString in: aWardleyMapModel [
	| id |
	id := UUID gtFromString: aString.
	^ aWardleyMapModel
		nodeWithId: id
		ifFound: [ :each | each ]
		ifNone: [  ]
]

{ #category : #private }
GtWardleyMapChangeSpecification >> noteWithId: aString in: aWardleyMapModel [
	| id |
	id := UUID gtFromString: aString.
	^ aWardleyMapModel
		noteWithId: id
		ifFound: [ :each | each ]
		ifNone: [  ]
]

{ #category : #changes }
GtWardleyMapChangeSpecification >> proposeModificationsIn: aWardleyMapModel [
	
]

{ #category : #private }
GtWardleyMapChangeSpecification >> updateNewUidsUsing: aDictionary [
]
