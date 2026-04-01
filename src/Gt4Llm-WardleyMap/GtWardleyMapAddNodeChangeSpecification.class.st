Class {
	#name : #GtWardleyMapAddNodeChangeSpecification,
	#superclass : #GtWardleyMapNodePropertiesChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapAddNodeChangeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapAddNode'
]

{ #category : #changes }
GtWardleyMapAddNodeChangeSpecification >> changeClass [
	^ GtWardleyMapAddNodeChange
]

{ #category : #changes }
GtWardleyMapAddNodeChangeSpecification >> proposeModificationsIn: aWardleyMapModel [
	| change proposition |
	change := self asChangeIn: aWardleyMapModel.
	change execute.
	proposition := GtWardleyMapAddProposition new.
	change newNode addWardleyMapDecoratorModel: proposition
]

{ #category : #private }
GtWardleyMapAddNodeChangeSpecification >> updateNewUidsUsing: aDictionary [
	| newId |
	super updateNewUidsUsing: aDictionary.
	newId := UUID new printString.
	aDictionary at: nodeId put: newId.
	nodeId := newId
]
