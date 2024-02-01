Class {
	#name : #Gt4OpenAIThreadMessage,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'id',
		'createdAt',
		'threadId',
		'content',
		'fileIds',
		'assistantId',
		'runId',
		'metadata'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIThreadMessage >> assistantId [
	^ assistantId
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> content [
	^ content
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> content: anObject [
	content := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> contentText [
	^ content at: #text at: #value
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> createdAt: anObject [
	createdAt := DateAndTime fromUnixTime: anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> fileIds [
	^ fileIds
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> fileIds: anObject [
	fileIds := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> id [
	^ id
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> id: anObject [
	id := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> metadata [
	^ metadata
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> runId [
	^ runId
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> runId: anObject [
	runId := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> threadId [
	^ threadId
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> threadId: anObject [
	threadId := anObject
]
