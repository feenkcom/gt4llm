Extension { #name : #GtWardleyMapCanvasElement }

{ #category : #'*Gt4Llm' }
GtWardleyMapCanvasElement >> onSpawnAnnouncement: anAnnouncement [
	self phlow spawnObject: anAnnouncement object
]

{ #category : #'*Gt4Llm' }
GtWardleyMapCanvasElement >> subscribeToLlm [
	self unsubscribeFromWardleyMapViewModel.
	self subscribeToWardleyMapViewModel.
	
	self wardleyMapViewModel weak
		when: GtLlmSpawnRequestAnnouncement
		send: #onSpawnAnnouncement:
		to: self
]
