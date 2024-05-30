Class {
	#name : #GtLlmSendActionToChat,
	#superclass : #Announcement,
	#instVars : [
		'action',
		'arguments'
	],
	#category : #'Gt4Llm-Announcements'
}

{ #category : #accessing }
GtLlmSendActionToChat class >> action: aString arguments: aListOfStrings [
	^ self new
		action: aString;
		arguments: aListOfStrings
]

{ #category : #accessing }
GtLlmSendActionToChat >> action [
	^ action
]

{ #category : #accessing }
GtLlmSendActionToChat >> action: anObject [
	action := anObject
]

{ #category : #accessing }
GtLlmSendActionToChat >> arguments [
	^ arguments
]

{ #category : #accessing }
GtLlmSendActionToChat >> arguments: anObject [
	arguments := anObject
]
