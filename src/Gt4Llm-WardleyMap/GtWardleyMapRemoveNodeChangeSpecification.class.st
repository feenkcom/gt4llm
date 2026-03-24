Class {
	#name : #GtWardleyMapRemoveNodeChangeSpecification,
	#superclass : #GtWardleyMapNodeChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapRemoveNodeChangeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapRemoveNode'
]

{ #category : #'as yet unclassified' }
GtWardleyMapRemoveNodeChangeSpecification >> asChangeIn: aWardleyMapModel [
	^ (GtWardleyMapRemoveNodeChange onMap: aWardleyMapModel)
		node: (self nodeWithId: nodeId in: aWardleyMapModel);
		yourself
]

{ #category : #'as yet unclassified' }
GtWardleyMapRemoveNodeChangeSpecification >> proposeModificationsIn: aWardleyMapModel [
	| change proposition |
	change := self asChangeIn: aWardleyMapModel.
	proposition := GtWardleyMapRemoveProposition new.
	change node addWardleyMapDecoratorModel: proposition
]
