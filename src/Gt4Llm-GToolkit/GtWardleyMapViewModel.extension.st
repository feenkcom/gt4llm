Extension { #name : #GtWardleyMapViewModel }

{ #category : #'*Gt4Llm-GToolkit' }
GtWardleyMapViewModel >> onActionFinished [
	self wardleyMapModel
		removeWardleyMapDecoratorModel: (self wardleyMapModel wardleyMapDecoratorModels
				detect: [ :aDecorator | aDecorator isKindOf: GtLlmWardleyMapInProgressDecorator ]
				ifNone: [ nil ])
]

{ #category : #'*Gt4Llm-GToolkit' }
GtWardleyMapViewModel >> onActionStarted [
	self wardleyMapModel
		addWardleyMapDecoratorModel: GtLlmWardleyMapInProgressDecorator new
]

{ #category : #'*Gt4Llm-GToolkit' }
GtWardleyMapViewModel >> onSpawnRequest: anAnnouncement [
	self announce: (GtWardleyMapSpawnRequest new object: anAnnouncement object)
]
