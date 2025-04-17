Class {
	#name : #GtOpenAISseEventAdded,
	#superclass : #Announcement,
	#instVars : [
		'event'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAISseEventAdded >> event [
	^ event
]

{ #category : #accessing }
GtOpenAISseEventAdded >> event: anObject [
	event := anObject
]
