Trait {
	#name : #TGtOpenAIThreadMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
TGtOpenAIThreadMessage >> annotations [
	^ self explicitRequirement
]

{ #category : #testing }
TGtOpenAIThreadMessage >> contentText [
	^ self explicitRequirement
]

{ #category : #testing }
TGtOpenAIThreadMessage >> createdAt [
	<return: #DateAndTime>
	^ self explicitRequirement
]

{ #category : #accessing }
TGtOpenAIThreadMessage >> elementClass [
	^ self explicitRequirement
]

{ #category : #testing }
TGtOpenAIThreadMessage >> hasResponse [
	^ self explicitRequirement
]

{ #category : #accessing }
TGtOpenAIThreadMessage >> id [
	^ self explicitRequirement
]

{ #category : #testing }
TGtOpenAIThreadMessage >> isAssistantRole [
	^ self explicitRequirement
]

{ #category : #testing }
TGtOpenAIThreadMessage >> isFailure [
	^ false
]

{ #category : #accessing }
TGtOpenAIThreadMessage >> styler [
	^ self explicitRequirement
]
