Class {
	#name : #GtWardleyMapRemoveNodeChangeSpecification,
	#superclass : #GtWardleyMapNodeChangeSpecification,
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #'json schema' }
GtWardleyMapRemoveNodeChangeSpecification class >> jsonSchemaLabel [
	^ 'WardleyMapRemoveNode'
]

{ #category : #changes }
GtWardleyMapRemoveNodeChangeSpecification >> asChangeIn: aWardleyMapModel [
	^ (GtWardleyMapRemoveNodeChange onMap: aWardleyMapModel)
		nodeId: nodeId;
		yourself
]

{ #category : #changes }
GtWardleyMapRemoveNodeChangeSpecification >> proposeModificationsIn: aWardleyMapModel [
	| change proposition |
	change := self asChangeIn: aWardleyMapModel.
	proposition := GtWardleyMapRemoveProposition new.
	change node addWardleyMapDecoratorModel: proposition
]
