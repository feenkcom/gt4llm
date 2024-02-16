Class {
	#name : #GtLlmCheckRunResultViewModel,
	#superclass : #Object,
	#traits : 'TGtLlmWithCheckRunResult + TGtAnnouncer',
	#classTraits : 'TGtLlmWithCheckRunResult classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #actions }
GtLlmCheckRunResultViewModel >> addToNewMessage [
	self
		announce: (GtLlmAddMessageContentsRequest new
				messageContents: self messageContents)
]

{ #category : #announcer }
GtLlmCheckRunResultViewModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmCheckRunResultViewModel >> executionResult [
	^ checkRunResult executionResult
]

{ #category : #accessing }
GtLlmCheckRunResultViewModel >> messageContents [
	<return: #String>
	^ self executionResult asString
]

{ #category : #accessing }
GtLlmCheckRunResultViewModel >> sendToChat [
	^ checkRunResult sendToChat
]
