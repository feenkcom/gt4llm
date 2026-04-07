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

{ #category : #changes }
GtWardleyMapChangeSpecification >> proposeModificationsIn: aWardleyMapModel [
	
]

{ #category : #private }
GtWardleyMapChangeSpecification >> updateNewUidsUsing: aDictionary [
]
