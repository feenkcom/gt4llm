Trait {
	#name : #TGtLlmThreadMessage,
	#category : #Gt4Llm
}

{ #category : #accessing }
TGtLlmThreadMessage >> annotations [
	^ self explicitRequirement
]

{ #category : #testing }
TGtLlmThreadMessage >> contentText [
	^ self explicitRequirement
]

{ #category : #testing }
TGtLlmThreadMessage >> createdAt [
	<return: #DateAndTime>
	^ self explicitRequirement
]

{ #category : #accessing }
TGtLlmThreadMessage >> elementClass [
	^ self explicitRequirement
]

{ #category : #testing }
TGtLlmThreadMessage >> hasResponse [
	^ self explicitRequirement
]

{ #category : #accessing }
TGtLlmThreadMessage >> id [
	^ self explicitRequirement
]

{ #category : #testing }
TGtLlmThreadMessage >> isAssistantRole [
	^ self explicitRequirement
]

{ #category : #testing }
TGtLlmThreadMessage >> isFailure [
	^ false
]

{ #category : #accessing }
TGtLlmThreadMessage >> styler [
	^ self explicitRequirement
]
